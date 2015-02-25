require 'spec_helper'

feature "instructor creates an admin account" do
  after { clear_emails }

  scenario "instructor creates admin" do
    kevin = Fabricate(:instructor)
    sign_in_admin(kevin)
    save_and_open_page
    click_on "Admin Management"
    expect_to_be_in admins_path
    click_on "Add new TA"
    expect_to_be_in new_admin_path
    fill_in "email", with: "brandon@email.com"
    check "Teaching Assistent"
    click_on "Add new admin"
    expect_to_see "New admin account was created, email was sent with\
instructions"
  end

  scenario "instructor creates instructor" do
    kevin = Fabricate(:admin, role: "instructor")
    sign_in_admin(kevin)
    click_on "Admin management"
    expect_to_be_in admins_path
    click_on "Add new TA"
    expect_to_be_in new_admin_path
    fill_in "email", with: "chris@email.com"
    check "Instructor"
    click_on "Add new admin"
    expect_to_see "New admin account was created, email was sent with\
instructions"
  end
end