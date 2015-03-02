require 'spec_helper'

feature "instructor edits course" do
  given(:kevin) do
    Fabricate(:instructor,
              username: "Kevin",
              full_name: "Kevin Wang",
              activated: true)
  end

  given!(:ruby) { Fabricate(:course) }
  background { sign_in_admin(kevin) }

  scenario "successfull edit" do
    click_on "Courses"
    click_on "Edit"
    expect_to_see "Edit course #{ruby.title}"

    fill_in "Title", with: "HTML and CSS basics"
    fill_in "Description", with: "front end course"
    fill_in "Duration", with: "7 weeks"
    select "Kevin", from: "Instructor"
    fill_in "Quizzes to pass", with: "3"
    fill_in "Certificate (in $)", with: "419.99"
    attach_file 'Image', 'spec/support/images/ruby.jpg'

    click_on "Submit changes"
    expect_to_see "Successfully updated the course HTML and CSS basics"
    click_on "Quizzer"

    validate_course_update(ruby)
  end

  scenario "fail edit - error messages" do
    visit edit_admin_course_path(ruby.slug)
  end
end

def validate_course_update(ruby)
  expect_to_see "Price $419.99"
  expect_to_see "7 weeks"
  expect_to_see "Kevin Wang"
  expect_to_see "front end course"
  expect(page).to have_css("img[src='#{ruby.reload.image_cover_url}']", visible: true)
end
