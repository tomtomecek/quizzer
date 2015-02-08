require 'spec_helper'

feature "admin updates answer from view quiz" do
  given!(:quiz) { Fabricate(:quiz) }
  given(:answer) { quiz.questions.first.answers.first }
  given(:correct_answer) do
    quiz.questions.first.answers.find_by(correct: true)
  end
  given!(:redundant_answer) do
    Fabricate(:incorrect, question: Question.first, content: "delete me")
  end

  background do
    sign_in_admin
    visit quiz_path(quiz)
  end

  context "admin edits answer" do
    scenario "successfull attempt", :js, :slow do
      expect_to_see_no_modal
      click_edit_on(answer)

      within(:css, ".modal") do
        fill_in "Answer's content", with: ""
        click_on "Submit changes"
        expect_to_see "These errors needs to be fixed:"
        expect_to_see "Content can't be blank"

        fill_in "Answer's content", with: "new answer"
        click_on "Submit changes"
      end

      expect_to_see_no_modal
      expect_to_see "Successfully updated answer"
      within(:css, "#answer_#{answer.id}") { expect_to_see "new answer" }
    end

    scenario "failed attempt none correct", :js do
      click_edit_on(correct_answer)
      within(:css, ".modal") do
        uncheck "Tick if answer is correct."
        click_on "Submit changes"
        expect_to_see "At least 1 answer must be correct."
      end
      expect(page).to have_css(".modal")
    end

    scenario "redundant flash messages", :js, :slow, driver: :selenium do
      click_edit_on(answer)

      within(:css, ".modal") do
        fill_in "Answer's content", with: "new content"
        click_on "Submit changes"
      end

      click_edit_on(answer)
      expect_to_not_see "Successfully updated answer"
    end
  end

  context "admin deletes answer" do
    scenario "successfull attempt", :js, :slow, driver: :selenium do
      accept_alert { click_delete_on(redundant_answer) }
      expect_to_see "Successfully deleted the answer"
      expect_to_not_see "delete me"
    end

    scenario "failed attempt", :js, :slow, driver: :selenium do
      accept_alert { click_delete_on(correct_answer) }
      expect_to_see "At least 1 answer must be correct."
    end
  end
end

def click_edit_on(answer)
  within(:css, "#answer_#{answer.id}") do
    find(:css, ".fa-edit").click
  end
end

def click_delete_on(answer)
  within(:css, "#answer_#{answer.id}") do
    find(:css, ".fa-times-circle").click
  end
end

def expect_to_see_no_modal
  expect(page).to have_no_css(".modal")
end
