require 'spec_helper'

feature "admin activates account" do
  given(:kevin) { Fabricate(:instructor, activated: true) }
  given(:email) { "new_admin@email.com" }
  given(:admin) { Admin.last }
  given(:activation_path) { admin_activation_path(admin.activation_token) }

  background do
    sign_in_admin(kevin)
    create_admin_account(email: email)
  end
  after { clear_emails }

  scenario "receives email and activates the account", :js do
    open_email(email)
    current_email.click_on activation_path

    submit_with(username: "brandon", password: "strongPassword")
    validate_successful_activation
  end

  context "checks errors" do
    background do
      open_email(email)
      current_email.click_on activation_path
    end

    scenario "username errors", :js do
      Fabricate(:teaching_assistant, username: "brandon")
      submit_with(username: "", password: "strongPassword")
      expect_to_see "This value is required."
      submit_with(username: "brandon", password: "strongPassword")
      click_on "Enter Tealeaf Academy Quizzer"
      expect_to_see "Username has already been taken."
    end

    scenario "password errors", :js do
      submit_with(username: "brandon", password: "123")
      validate_password_error_message
      submit_with(username: "brandon", password: "")
      expect_to_see "This value is required."
    end
  end
end

def create_admin_account(options = {})
  visit new_admin_path
  fill_in "Email:", with: options[:email]
  role = options[:role] || "Teaching assistant"
  select role, from: "Admin role:"
  click_on "Add new admin"
  click_on "Sign out"
end

def submit_with(options = {})
  fill_in "User Name", with: options[:username]
  fill_in "Password", with: options[:password]
  click_on "Enter Tealeaf Academy Quizzer"
end

def validate_password_error_message
  expect_to_see "Password must have at least 6 characters"
end

def validate_successful_activation
  expect_to_see "Welcome to Tealeaf! You are new admin."
end
