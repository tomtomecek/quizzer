require 'spec_helper'

feature "student enrolls course" do
  given(:ruby) { Fabricate(:course, title: "Ruby") }
  background do
    Fabricate.times(3, :quiz, course: ruby)
    sign_in
  end

  scenario "student enrolls course for free", :js, :slow, driver: :selenium do
    expect_to_see_no_modal
    within(:css, "#course_#{ruby.id}") { click_on "Enroll now" }

    within_modal do
      find(:xpath, "//label[contains(.,'Free')]").click
      check "I agree"
      click_on "Enroll now!"
    end

    expect_to_see_no_modal
    expect_to_be_in course_path(ruby.slug)
    expect_to_see "You have now enrolled course #{ruby.title}"
    expect_to_see "Enrollment: Free"
    expect_to_see "Quizzes: 0 / 3"
  end

  scenario "student does not agree on honor code", :js, :slow do
    within(:css, "#course_#{ruby.id}") { click_on "Enroll now" }

    within_modal do
      uncheck "I agree"
      click_on "Enroll now!"
      expect_to_see "Honor code must be accepted"
    end
  end
end
