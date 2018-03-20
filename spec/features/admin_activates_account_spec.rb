require 'spec_helper'

feature "Admin activates account", :js do
  given(:kevin) { Fabricate(:instructor, activated: true) }
  given(:email) { "new_admin@email.com" }
  given(:admin) { Admin.last }
  given(:activation_path) { admin_activation_path(admin.activation_token) }

  background do
    sign_in_admin(kevin)
    create_admin_account(email: email)
  end

  scenario "receives email and activates the account" do
    open_email(email)
    current_email.click_on activation_path

    submit_with(username: "brandon", password: "strongPassword")
    validate_successful_activation
  end

  context "checks errors" do
    background do
      open_email(email)
      current_email.click_link activation_path
    end

    scenario "username errors" do
      Fabricate(:teaching_assistant, username: "brandon")
      submit_with(username: "", password: "strongPassword")
      expect(page).to have_content "This value is required."
      submit_with(username: "brandon", password: "strongPassword")
      expect(page).to have_content "User Name has already been taken"
    end

    scenario "password errors" do
      submit_with(username: "brandon", password: "123")
      validate_password_error_message
      submit_with(username: "brandon", password: "")
      expect(page).to have_content "This value is required."
    end
  end

  def create_admin_account(options = {})
    visit new_admin_path
    fill_in "Full Name", with: "New Admin"
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
    expect(page).to have_content "Password must have at least 6 characters"
  end

  def validate_successful_activation
    expect(page).to have_content "Welcome to Tealeaf! You are new admin."
  end
end
