require "spec_helper"

feature "student authenticates successfully" do
  scenario "signs in - has no account" do
    visit root_path
    click_on "Sign in with GitHub"
    expect(page).to have_content "Sign out"
    expect(page).to have_content "Signed in!"
    expect(page).to have_content "alicewang"
    expect(page).to_not have_content "Sign in with GitHub"
  end

  scenario "signs in - has an account" do
    Fabricate(:user, provider: "github", uid: "12345", username: "alicewang")
    visit root_path
    click_on "Sign in with GitHub"
    expect(page).to have_content "Sign out"
    expect(page).to have_content "alicewang"
    expect(page).to_not have_content "Sign in with GitHub"
  end

  scenario "signs out" do
    sign_in
    click_on "Sign out"
    expect(page).to have_content "Sign in with GitHub"
    expect(page).to_not have_content "Sign out"
  end
end
