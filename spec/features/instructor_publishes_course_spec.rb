require 'spec_helper'

feature "Instructor publishes a course" do
  given(:ruby) do
    Fabricate(:course, published: false, min_quiz_count: 3, title: "ruby")
  end
  given(:kevin) { Fabricate(:instructor, activated: true) }

  scenario "successfull publish" do
    Fabricate.times(3, :quiz, course: ruby, published: true)
    sign_in_admin kevin

    click_on "Publish"
    expect(page).to have_content "Course has been successfully published."
  end
end
