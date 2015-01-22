require "spec_helper"

feature "admin signs in to Quizzer" do
  background do
    Fabricate(:admin, email: "admin@tealeaf.com", password: "secret")
  end

  scenario "successful sign in" do
    visit root_path
    find(:xpath, "//a[@href='/admin/sign_in']").click
    expect_to_see "Administrator Login"
    fill_in "Email", with: "admin@tealeaf.com"
    fill_in "Password", with: "secret"
    click_on "Sign in"

    expect(current_path).to eq admin_courses_path
  end

  scenario "failed sign in" do
    visit root_path
    find(:xpath, "//a[@href='/admin/sign_in']").click
    expect_to_see "Administrator Login"
    fill_in "Email", with: "admin@tealeaf.com"
    fill_in "Password", with: "no match"
    click_on "Sign in"

    expect(current_path).to eq admin_sign_in_path
    expect_to_see "Incorrect email or password. Please try again."

    fill_in "Email", with: "no match"
    fill_in "Password", with: "secret"
    click_on "Sign in"

    expect(current_path).to eq admin_sign_in_path
    expect_to_see "Incorrect email or password. Please try again."
  end
end
