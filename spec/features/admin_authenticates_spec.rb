require "spec_helper"

feature "admin authenticates with Quizzer" do
  given!(:admin) do
    Fabricate(:admin, email: "admin@tealeaf.com", password: "secret")
  end

  scenario "successful sign in" do
    visit root_path
    click_on "Administration"
    expect_to_see "Administrator Login"
    filling_sign_in_form_and_submits

    expect_to_see "Login was successful!"
    expect_to_not_have_sign_out_link_for_student
    expect_to_have_sign_out_link_for_admin
    expect_to_be_in admin_courses_path
  end

  scenario "failed sign in" do
    visit root_path
    click_on "Administration"
    expect_to_see "Administrator Login"
    logging_in_with(password: "no match")
    expect_to_be_in admin_sign_in_path
    expect_to_see "Incorrect email or password. Please try again."

    logging_in_with(email: "no match")
    expect_to_be_in admin_sign_in_path
    expect_to_see "Incorrect email or password. Please try again."
  end

  scenario "signs out" do
    sign_in_admin(admin)
    click_on "Sign out"
    expect_to_see "Logged out successfully."
    expect_to_be_in root_path
  end

  scenario "client side validations", :js, :slow do
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
alias :filling_sign_in_form_and_submits :logging_in_with

def expect_to_have_sign_out_link_for_admin
  expect(page).to have_xpath("//a[@href='/admin/sign_out']")
end

def expect_to_not_have_sign_out_link_for_student
  expect(page).to have_no_xpath("//a[@href='/sign_out']")
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
