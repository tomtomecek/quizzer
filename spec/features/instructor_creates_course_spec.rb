require 'spec_helper'

feature "instructor creates a new course" do
  given(:kevin) { Fabricate(:instructor, username: "Kevin", activated: true) }
  background { sign_in_admin kevin }

  scenario "standard course creation" do
    navigate_to_new_course
    fill_in "Title", with: "HTML and CSS basics"
    fill_in "Description", with: "front end course"
    fill_in "Duration", with: "4 weeks"
    select "Kevin", from: "Instructors"
    fill_in "Quizzes to pass", with: "4"
    attach_file 'Image', 'spec/support/images/ruby_on_rails.jpg'

    click_on "Create Course"
    expect_to_see "Unpublished course has been created."
  end

  scenario "check error messages", :js do
    navigate_to_new_course
    fill_in "Title", with: ""
    expect_to_see "This value is required."

    fill_in "Description", with: ""
    expect_to_see "This value is required."

    fill_in "Duration", with: ""
    expect_to_see "This value is required."

    select "Select Instructors", from: "Instructors"
    expect_to_see "Course must have at least 1 instructor."

    select "Select Minimum", from: "Quizzes to pass"
    expect_to_see "You must select minimum amount of quizzes to pass."
  end
end

def navigate_to_new_course
  click_on "Courses"
  click_on "New Course"
end
