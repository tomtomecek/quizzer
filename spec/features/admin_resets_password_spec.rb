require 'spec_helper'

feature "admin resets password" do
  background { clear_emails }

  scenario "admin forgot password and resets it" do
    admin = Fabricate(:admin, email: "admin@example.com", password: "old_pswd")
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

    fill_in "New Password", with: "new_password"
    click_button "Reset Password"
    expect_to_be_in admin_sign_in_path
    expect_to_see "You can sign in with your new password now"

    fill_in "Email", with: "admin@example.com"
    fill_in "Password", with: "old_pswd"
    click_button "Sign in"
    expect_to_see "Incorrect email or password"

    fill_in "Email", with: "admin@example.com"
    fill_in "Password", with: "new_password"
    click_button "Sign in"

    expect_to_see "Login was successful"
    expect_to_be_in admin_courses_path
  end
end
