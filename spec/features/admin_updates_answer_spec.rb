require 'spec_helper'

feature "Admin updates answer from view quiz" do
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
    scenario "successfull attempt", :js do
      click_edit_on(answer)

      within_modal do
        fill_in "Answer's content", with: ""
        submit_changes
        expect(page).to have_content "These errors needs to be fixed:"
        expect(page).to have_content "Content can't be blank"

        fill_in "Answer's content", with: "new answer"
        submit_changes
      end

      expect(page).to have_content "Successfully updated answer"
      within(:css, "#answer_#{answer.id}") do
        expect(page).to have_content "new answer"
      end
    end

    scenario "failed attempt none correct", :js do
      click_edit_on(correct_answer)
      within_modal do
        untick_checkbox
        submit_changes
        expect(page).to have_content "At least 1 answer must be correct."
      end
      expect(page).to have_css(".modal")
    end

    scenario "redundant flash messages", :js do
      click_edit_on(answer)
      sleep 1

      within_modal do
        fill_in "Answer's content", with: "new content"
        click_on "Submit changes"
        sleep 1
      end

      click_edit_on(answer)
      sleep 1
      within_modal do
        expect(page).to have_no_content "Successfully updated answer"
      end
    end
  end

  context "admin deletes answer" do
    scenario "successfull attempt", :js do
      click_delete_on(redundant_answer)
      expect(page).to have_content "Successfully deleted the answer"
      expect(page).to have_no_content "delete me"
    end

    scenario "failed attempt", :js do
      click_delete_on(correct_answer)
      expect(page).to have_content "At least 1 answer must be correct."
    end
  end

  def click_edit_on(answer)
    within(:css, "#answer_#{answer.id}") do
      find(:css, ".fa-edit").trigger('click')
    end
  end

  def click_delete_on(answer)
    within(:css, "#answer_#{answer.id}") do
      find(:css, ".fa-times-circle").click
    end
  end

  def untick_checkbox
    find('input[type=checkbox]').trigger('click')
  end

  def submit_changes
    find('input[type=submit]').trigger('click')
  end
end
