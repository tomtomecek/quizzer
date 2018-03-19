require 'spec_helper'

feature "admin edits a quiz" do
  given!(:ruby) { Fabricate(:course, title: 'Ruby course') }
  given!(:quiz) do
    Fabricate(
      :quiz,
      course: ruby,
      title: "Week 1 - Procedural Ruby",
      description: "For beginners",
      passing_percentage: 60,
      published: false) do
      questions do
        [
          Fabricate.build(:question, content: "1 + 1?", points: 3) do
            answers do
              [
                Fabricate(:correct, content: "2"),
                Fabricate(:incorrect, content: "33"),
                Fabricate(:incorrect, content: "44"),
                Fabricate(:incorrect, content: "55"),
                Fabricate(:incorrect, content: "delete me")
              ]
            end
          end,
          Fabricate.build(:question, content: "2 + 2?", points: 4) do
            answers do
              [
                Fabricate(:correct, content: "4"),
                Fabricate(:incorrect, content: "wrong answer"),
                Fabricate(:incorrect, content: "444"),
                Fabricate(:incorrect, content: "555")
              ]
            end
          end
        ]
      end
    end
  end

  background do
    sign_in_admin
    visit admin_course_path(ruby)
    within(:css, "#quiz_#{quiz.id}") do
      click_on "Edit Quiz"
    end
  end

  scenario "admin changes a quiz and publishes it" do
    expect_to_be_in edit_quiz_path(quiz)
    fill_in "Title", with: "Hardcore Ruby"
    fill_in "Description", with: "For advanced programmers"
    select "50 %", from: "quiz_passing_percentage"
    check "Published"
    click_on "Update Quiz"

    expect_to_be_in admin_course_path(ruby)
    expect(page).to have_content "Quiz was successfully updated."

    within(:css, "#quiz_#{quiz.id}") do
      expect(page).to have_content "Published"
      click_on "View Quiz"
    end
    expect(page).to have_content "50 percents"
    expect(page).to have_content "Hardcore Ruby"
    expect(page).to have_content "For advanced programmers"
  end

  scenario "admin adds a question", :js do
    add_question(3, with: "Answer to life?", points: 9) do |question|
      create_all_answers_for(question)
    end
    click_on "Update Quiz"
    expect(page).to have_content "Quiz was successfully updated."
    click_on "View Quiz"
    within("#question_3") do
      expect(page).to have_content "Answer to life?"
      expect(page).to have_content "9 points"
    end
  end

  scenario "admin changes a question", :js do
    within_question(2) do
      fill_in "Question", with: "Better content is a king"
      select 6
    end
    click_on "Update Quiz"
    expect(page).to have_content "Quiz was successfully updated."
    click_on "View Quiz"
    expect(page).to_not have_content "Question: 3"
    within(:css, "#question_2") do
      expect(page).to have_content "Better content is a king"
      expect(page).to have_content "6 points"
    end
  end

  scenario "admin removes a question", :js do
    remove_question(2)
    click_on "Update Quiz"
    expect(page).to have_content "Quiz was successfully updated."
  end

  scenario "admin adds an answer", :js do
    within_question(2) do |question|
      add_answer(5, to: question, with: "new answer") { mark_incorrect }
    end
    click_on "Update Quiz"
    expect(page).to have_content "Quiz was successfully updated."
    view quiz
    expect(page).to have_content "new answer"
  end

  scenario "admin removes an answer", :js do
    remove_answer(5, from: 1)
    click_on "Update Quiz"
    expect(page).to have_content "Quiz was successfully updated."
  end

  scenario "reached answers limit", :js do
    within_question(1) do |question|
      add_answer(6, to: question, with: "an answer")
      add_answer(7, to: question, with: "an answer")
      add_answer(8, to: question, with: "an answer")
      add_answer(9, to: question, with: "an answer")
      add_answer(10, to: question, with: "an answer")
      add_answer(11, to: question, with: "an answer")
    end

    click_on "Update Quiz"
    expect(page).to have_content "Quiz creation failed -\
      Maximum 10 records are allowed. Got 11 records instead"
  end

  def view(quiz)
    within(:css, "#quiz_#{quiz.id}") do
      find('a', text: "View Quiz").click
    end
  end
end
