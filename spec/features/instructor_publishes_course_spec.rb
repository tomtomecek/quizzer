require 'spec_helper'

feature "instructor publishes a course" do
  given(:ruby) { Fabricate(:course, published: false, min_quiz_count: 3, title: "ruby") }
  given(:kevin) { Fabricate(:instructor, activated: true) }

  scenario "successfull publish" do
    Fabricate.times(3, :quiz, course: ruby, published: true)
    sign_in_admin kevin

    click_on "Publish"
    expect(page).to have_content "Course has been successfully published."
  end
end
