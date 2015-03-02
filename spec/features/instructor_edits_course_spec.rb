require 'spec_helper'

feature "instructor edits course" do
  given(:kevin) { Fabricate(:instructor, username: "Kevin") }
  given!(:ruby) { Fabricate(:course) }
  background { sign_in_admin(kevin) }

  scenario "successfull edit" do
    visit edit_admin_course_path(ruby.slug)
    expect_to_see "Edit course #{ruby.title}"

    fill_in "Title", with: "HTML and CSS basics"
    fill_in "Description", with: "front end course"
    fill_in "Duration", with: "4 weeks"
    select "Kevin", from: "Instructor"
    fill_in "Quizzes to pass", with: "3"
    fill_in "Certificate (in $)", with: "419.99"
    attach_file 'Image', 'spec/support/images/ruby.jpg'

    click_on "Submit changes"

    within_nav { click_on "Quizzer" }
    expect(page).to have_css("img[src='#{ruby.image_cover_url}']", visible: true)
  end

  scenario "fail edit - error messages" do
    visit edit_admin_course_path(ruby.slug)
  end
end
