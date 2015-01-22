require 'spec_helper'

feature "student authenticates successfully" do

  scenario "signs in - has no account" do
    visit root_path
    click_on "Sign in with GitHub"
    expect_to_see "Sign out"
    expect_to_see "Signed in!"
    expect_to_see "alicewang"
    expect_to_not_see "Sign in with GitHub"
  end

  scenario "signs in - has an account" do
    Fabricate(:user, provider: "github", uid: "12345", username: "alicewang")
    visit root_path
    click_on "Sign in with GitHub"
    expect_to_see "Sign out"
    expect_to_see "alicewang"
    expect_to_not_see "Sign in with GitHub"
  end

  scenario "signs out" do
    sign_in
    click_on "Sign out"
    expect_to_see "Sign in with GitHub"
    expect_to_not_see "Sign out"
  end

end