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
    select "Kevin", from: "Instructor"
    fill_in "Quizzes to pass", with: "3"
    fill_in "Certificate (in $)", with: "19.99"
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

    fill_in "Certificate (in $)", with: ""
    expect_to_see "Each course must have a certificate value."
    fill_in "Certificate (in $)", with: "-1"
    expect_to_see "Minimum dollar amount of certificate is 0.01"

    select "Select one", from: "Instructor"
    click_on "Create Course"
    expect_to_see "Course must have at least 1 instructor."

    fill_in "Quizzes to pass", with: ""
    expect_to_see "Set minimum amount of quizzes to pass."
    fill_in "Quizzes to pass", with: "2"
    expect_to_see "Minimum amount of quizzes to pass is 3."
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
