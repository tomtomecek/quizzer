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

    submit_with(password: "123")
    validate_error_message
    submit_with(password: "strongPassword")
    validate_successful_activation
  end
end

def create_admin_account(options = {})
  visit new_admin_path
  role = options[:role] || "Teaching assistant"
  fill_in "Email:", with: options[:email]
  select role, from: "Admin role:"
  click_on "Add new admin"
  click_on "Sign out"
end

def submit_with(options = {})
  fill_in "Password", with: options[:password]
  click_on "Enter Tealeaf Academy Quizzer"
end

def validate_error_message
  expect_to_see "Password must have at least 6 characters"
end

def validate_successful_activation
  expect_to_see "Welcome to Tealeaf! You are new admin."
end
