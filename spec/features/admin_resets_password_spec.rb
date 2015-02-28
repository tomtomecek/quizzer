require 'spec_helper'

feature "admin resets password" do
  background { clear_emails }
  after { clear_emails }

  scenario "admin forgot password and resets it" do
    admin = Fabricate(:admin,
                      email: "admin@example.com",
                      password: "old_pswd",
                      activated: true)
    visit admin_sign_in_path
    click_on "Forgot password?"

    expect_to_be_in new_password_reset_path
    expect_to_see "We will send you an email with a link that\
      you can use to reset your password."

    fill_in "Email", with: "admin@example.com"
    click_on "Send Email"

    expect_to_be_in confirm_password_reset_path
    expect_to_see "We have send an email with instruction to reset your\
      password."

    open_email("admin@example.com")
    current_email.click_link "Reset password link"

    expect_to_be_in edit_password_reset_path(admin.reload.password_reset_token)
    expect_to_see "Reset Your Password"

    fill_in_new_password_and_submit("new_password")
    expect_to_be_in admin_sign_in_path
    expect_to_see "You can sign in with your new password now"

    fill_in_login_details_and_submit(with: "old_pswd")
    expect_to_see "Incorrect email or password"

    fill_in_login_details_and_submit(with: "new_password")
    expect_to_see "Login was successful"
    expect_to_be_in admin_courses_path
  end

  scenario "reset password client side errors check", :js do
    admin = Fabricate(:admin,
                      password_reset_token: "123",
                      password_reset_expires_at: 1.hour.from_now)
    visit edit_password_reset_path(admin.password_reset_token)

    fill_in_new_password_and_submit("")
    expect_to_see "This value is required"

    fill_in_new_password_and_submit("123")
    expect_to_see "Password must have at least 6 characters"
  end

  scenario "sending pw reset client side errors check", :js do
    visit new_password_reset_path
    fill_in "Email", with: ""
    expect_to_see "This value is required"
    fill_in "Email", with: "admin"
    expect_to_see "This value should be a valid email"
  end
end

def fill_in_new_password_and_submit(password)
  fill_in "New Password", with: password
  click_button "Reset Password"
end

def fill_in_login_details_and_submit(options)
  fill_in "Email", with: "admin@example.com"
  fill_in "Password", with: options[:with]
  click_button "Sign in"
end
