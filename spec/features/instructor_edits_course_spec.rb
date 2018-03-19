require 'spec_helper'

feature "instructor edits course" do
  given(:kevin) do
    Fabricate(:instructor,
              username: "Kevin",
              full_name: "Kevin Wang",
              activated: true)
  end

  given!(:ruby) { Fabricate(:course, published: true) }
  background { sign_in_admin(kevin) }

  scenario "successfull edit" do
    click_on "Courses"
    click_on "Edit"
    expect(page).to have_content "Editing #{ruby.title}"

    fill_in "Title", with: "HTML and CSS basics"
    fill_in "Description", with: "front end course"
    fill_in "Duration", with: "7 weeks"
    select "Kevin", from: "Instructor"
    fill_in "Quizzes to pass", with: "3"
    fill_in "Certificate (in $)", with: "419.99"
    attach_file 'Image', 'spec/support/images/ruby.jpg'

    click_on "Submit changes"
    expect(page).to have_content "Successfully updated the course HTML and CSS basics"
    click_on "Quizzer"

    validate_course_update(ruby)
  end

  scenario "fail edit - error messages", :js do
    visit edit_admin_course_path(ruby.slug)

    validate_required_error_message_for("Title")
    validate_required_error_message_for("Description")
    validate_required_error_message_for("Duration")

    fill_in "Certificate (in $)", with: ""
    expect(page).to have_content "Each course must have a certificate value."
    fill_in "Certificate (in $)", with: "-1"
    expect(page).to have_content "Minimum dollar amount of certificate is 0.01"

    fill_in "Quizzes to pass", with: ""
    expect(page).to have_content "Set minimum amount of quizzes to pass."
    fill_in "Quizzes to pass", with: "2"
    expect(page).to have_content "Minimum amount of quizzes to pass is 3."
  end
end

def validate_required_error_message_for(label)
  fill_in label, with: ""
  expect(page).to have_content "This value is required."
  fill_in label, with: "something"
end

def validate_course_update(ruby)
  expect(page).to have_content "Price $419.99"
  expect(page).to have_content "7 weeks"
  expect(page).to have_content "Kevin Wang"
  expect(page).to have_content "front end course"
  url = ruby.reload.image_cover_url
  expect(page).to have_css("img[src='#{url}']", visible: true)
end
