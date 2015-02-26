require "spec_helper"

feature "admin authenticates with Quizzer" do
  context "account activated" do
    given(:activated_admin) do
      Fabricate(:admin,
                email: "admin@example.com",
                password: "secret",
                activated: true)
    end

    scenario "successful sign in" do
      navigate_to_admin_login(activated_admin)
      expect_to_see "Administrator Login"
      logging_in_with(email: "admin@example.com", password: "secret")

      expect_to_see "Login was successful!"
      expect_to_not_have_sign_out_link_for_student
      expect_to_have_sign_out_link_for_admin
      expect_to_be_in admin_courses_path
    end

    scenario "failed sign in" do
      navigate_to_admin_login(activated_admin)

      logging_in_with(email: "admin@example.com", password: "no match")
      expect_to_see "Incorrect email or password. Please try again."

      logging_in_with(email: "no match", password: "secret")
      expect_to_see "Incorrect email or password. Please try again."
    end

    scenario "signs out" do
      sign_in_admin(activated_admin)
      click_on "Sign out"
      expect_to_see "Logged out successfully."
      expect_to_be_in root_path
    end
  end

  context "account not activated" do
    given(:not_activated_admin) do
      Fabricate(:admin,
                email: "admin@example.com",
                password: nil,
                activated: false)
    end

    scenario "failed sign in" do
      navigate_to_admin_login(not_activated_admin)

      logging_in_with(email: "admin@example.com", password: "secret")
      expect_to_see "Your account has not been activated yet."
    end
  end

  scenario "client side validations", :js do
    visit admin_sign_in_path
    validate_email_error_messages
    validate_password_error_messages
  end
end

def logging_in_with(options = {})
  fill_in "Email",    with: options[:email] || "admin@tealeaf.com"
  fill_in "Password", with: options[:password] || "secret"
  click_on "Sign in"
end

def expect_to_have_sign_out_link_for_admin
  expect(page).to have_xpath("//a[@href='/admin/sign_out']")
end

def expect_to_not_have_sign_out_link_for_student
  expect(page).to have_no_xpath("//a[@href='/sign_out']")
end

def navigate_to_admin_login(admin)
  visit root_path
  click_on "Administration"
end

def validate_email_error_messages
  fill_in "Email", with: ""
  click_on "Sign in"
  expect_to_see "This value is required"
  fill_in "Email", with: "admin"
  click_on "Sign in"
  expect_to_see "This value should be a valid email"
end

def validate_password_error_messages
  fill_in "Password", with: ""
  click_on "Sign in"
  expect_to_see "This value is required"
  fill_in "Password", with: "123"
  click_on "Sign in"
  expect_to_see "Password must have at least 6 charact"
end
