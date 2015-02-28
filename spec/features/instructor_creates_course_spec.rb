require 'spec_helper'

feature "instructor creates a new course" do
  given(:kevin) { Fabricate(:instructor, username: "Kevin", activated: true) }
  given(:course) { Course.first }
  background { sign_in_admin kevin }

  scenario "standard course creation" do
    visit new_admin_course_path
    fill_in "Title", with: "HTML and CSS basics"
    fill_in "Description", with: "front end course"
    fill_in "Duration", with: "4 weeks"
    select "Kevin", from: "Instructors"
    fill_in "Quizzes to pass", with: "4"
    attach_file 'Image', 'spec/support/images/ruby_on_rails.jpg'

    click_on "Create Course"
    expect_to_see "Unpublished course has been created."

    click_on "Quizzer"
    expect(page).to have_css("img[src='#{course.image_cover_url}']")
  end

  scenario "check error messages", :js do
    visit new_admin_course_path
    validate_required_error_message_for("Title")
    validate_required_error_message_for("Description")
    validate_required_error_message_for("Duration")

    select "Select Instructors", from: "Instructors"

    fill_in "Quizzes to pass", with: ""
    expect_to_see "Set minimum amount of quizzes to pass."

    click_on "Create Course"
    expect_to_see "Course must have at least 1 instructor."
  end
end

def navigate_to_new_course
  click_on "Courses"
  click_on "New Course"
end

def validate_required_error_message_for(label)
  fill_in label, with: ""
  expect_to_see "This value is required."
  fill_in label, with: "something"
end
