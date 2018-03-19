require 'spec_helper'

feature "admin checks on exams" do
  scenario "admin finds exams and goes through the list" do
    alice = Fabricate(:user)
    jake = Fabricate(:user)
    ruby = Fabricate(:course)
    rails = Fabricate(:course)
    week1_ruby = Fabricate(:quiz, course: ruby)
    week1_rails = Fabricate(:quiz, course: rails)
    exam1 = Fabricate(:exam, student: alice, quiz: week1_ruby)
    Fabricate(:exam, student: jake, quiz: week1_rails)
    sign_in_admin

    within(".navbar") { click_on "Exams" }
    expect_to_be_in admin_exams_path
    expect(find("tbody")).to have_css("tr", count: 2)

    within(:css, "tr#exam_#{exam1.id}") do
      expect(page).to have_content alice.username
      expect(page).to have_content week1_ruby.title
      expect(page).to have_content ruby.title
      click_on "View"
    end

    expect_to_be_in admin_exam_path(exam1)
  end
end
