require 'spec_helper'

feature "instructor creates an admin account" do
  given(:kevin) { Fabricate(:instructor, activated: true) }
  background do
    sign_in_admin(kevin)
  end
  after { clear_emails }

  scenario "Instructor creates Teaching assistent" do
    navigate_to_admin_new(verify: true)

    fill_in_email_select_role_and_submit(role: "Teaching assistant")

    validate_admin_creation
  end

  scenario "Instructor creates Instructor" do
    navigate_to_admin_new

    fill_in_email_select_role_and_submit(role: "Instructor")

    validate_admin_creation
  end
end

def fill_in_email_select_role_and_submit(options = {})
  fill_in "Full Name:", with: "New Admin"
  fill_in "Email:", with: "new_admin@email.com"
  select options[:role], from: "Admin role:"
  click_on "Add new admin"
end

def navigate_to_admin_new(options = {})
  click_on "Admin Management"
  expect_to_be_in management_admins_path if options[:verify]
  click_on "Add new admin"
  expect_to_be_in new_admin_path if options[:verify]
end

def validate_admin_creation
  expect(page).to have_content "New admin account was created, email was sent with\
 instructions"
end
