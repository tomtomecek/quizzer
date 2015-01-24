require "spec_helper"

feature "admin adds a quiz to a course" do
  given!(:ruby) { Fabricate(:course, title: "Ruby course") }

  scenario "successful quiz creation" do
    sign_in_admin
    click_on "Ruby course"
    click_on "New Quiz"

    fill_in "Title", with: "Week 1 - Ruby basics"
    fill_in "Description", with: "Quiz focused on Ruby methods and iterations"
    uncheck "Published"
    click_on "Create Quiz"

    expect_to_be_in admin_course_path(ruby)
    expect_to_see "Week 1 - Ruby basics"
    expect_to_see "Successfully created new quiz."
  end

  scenario "failed attempt on quiz creation" do
    sign_in_admin
    click_on "Ruby course"
    click_on "New Quiz"

    fill_in "Title", with: ""
    fill_in "Description", with: "Quiz focused on Ruby methods and iterations"
    uncheck "Published"
    click_on "Create Quiz"

    expect_to_see "Quiz creation failed"
    expect_to_be_in new_admin_quiz_path(course_id: ruby.slug)
  end
end
