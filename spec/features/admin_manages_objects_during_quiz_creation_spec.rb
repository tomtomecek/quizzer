require "spec_helper"

feature "object management during quiz creation" do
  given!(:ruby) { Fabricate(:course, title: "Ruby course") }
  background do
    sign_in_admin
    visit new_quiz_path(course_id: ruby.slug)
  end

  scenario "admin adds question", :js do
    expect(page).to have_no_css("fieldset")
    add_question(1, with: "x", points: 2)
    expect(page).to have_css("fieldset")
  end

  scenario "admin adds answer", :js do
    expect(page).to have_no_css("fieldset")
    add_question(1, with: "x", points: 2) do |question|
      add_answer(1, to: question, with: "some answer")
    end
    expect(page).to have_xpath("//form/fieldset[1]/fieldset[1]")
  end

  scenario "admin removes question", :js do
    add_question(1, with: "x", points: 2)
    expect(page).to have_css("fieldset")
    remove_question(1)
    expect(page).to have_no_css("fieldset")
  end

  scenario "admin removes answer", :js do
    add_question(1, with: "x", points: 2) do |question|
      add_answer(1, to: question, with: "some answer")
    end
    expect(page).to have_xpath("//form/fieldset[1]/fieldset[1]")
    remove_answer(1, from: 1)
    expect(page).to have_no_xpath("//form/fieldset[1]/fieldset[1]")
  end
end
