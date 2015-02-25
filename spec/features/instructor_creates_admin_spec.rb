require 'spec_helper'

feature "instructor creates an admin account" do
  given(:kevin) { Fabricate(:instructor) }
  background do
    sign_in_admin(kevin)
  end
  after { clear_emails }

  scenario "instructor creates teaching assistent" do
    click_on "Admin Management"
    expect_to_be_in management_admins_path
    click_on "Add new admin"
    expect_to_be_in new_admin_path
    fill_in "Email:", with: "brandon@email.com"
    select "Teaching Assistant", from: "Admin role:"
    click_on "Add new admin"
    expect_to_see "New admin account was created, email was sent with\
instructions"
  end

  scenario "instructor creates instructor" do
    click_on "Admin management"
    expect_to_be_in management_admins_path
    click_on "Add new admin"
    expect_to_be_in new_admin_path
    fill_in "Email:", with: "chris@email.com"
    select "Instructor", from: "Admin role:"
    click_on "Add new admin"
    expect_to_see "New admin account was created, email was sent with\
instructions"
  end
end