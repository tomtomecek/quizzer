require 'spec_helper'

feature "admin edits a quiz" do
  given!(:ruby) { Fabricate(:course, title: 'Ruby course') }
  given!(:quiz) do
    Fabricate(
      :quiz,
      course: ruby,
      title: "Week 1 - Procedural Ruby",
      description: "For beginners",
      published: false) do
      questions do
        [
          Fabricate(:question, content: "How much is 1 + 1?", points: 3) do
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
          Fabricate(:question, content: "How much is 2 + 2?", points: 4) do
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
    within(:css, "#quiz_#{quiz.id}") { click_on "Edit Quiz" }
  end

  scenario "admin changes a quiz and publishes it" do
    expect_to_be_in edit_quiz_path(quiz)
    fill_in "Title",       with: "Hardcore Ruby"
    fill_in "Description", with: "For advanced programmers"
    check "Published"
    click_on "Update Quiz"

    expect_to_be_in admin_courses_path(ruby)
    expect_to_see "Quiz was successfully updated."

    within(:css, "#quiz_#{quiz.id}") do
      expect_to_see "Published"
      click_on "Start Quiz"
    end
    expect_to_see "Hardcore Ruby"
    expect_to_see "For advanced programmers"
  end

  scenario "admin adds a question" do
    add_question(3, with: "Answer to life?", points: 9) do |question|
      create_all_answers_for(question)
    end
    click_on "Update Quiz"
    expect_to_see "Quiz was successfully updated."
    within(:css, "#quiz_#{quiz.id}") { click_on "Start Quiz" }
    expect_to_see "Question: 3"
    expect_to_see "Answer to life?"
    expect_to_see "9 points"
  end

  scenario "admin changes a question" do
    within(:xpath, "//form/fieldset[2]") do
      fill_in "Question", with: "Better content is a king"
      select 6
    end
    click_on "Update Quiz"
    expect_to_see "Quiz was successfully updated."
    within(:css, "#quiz_#{quiz.id}") { click_on "Start Quiz" }
    expect_to_see "Better content is a king"
    expect_to_see "6 points"
    expect_to_not_see "Question: 3"
  end

  scenario "admin removes a question" do
    remove_question(2)
    click_on "Update Quiz"
    expect_to_see "Quiz was successfully updated."
    within(:css, "#quiz_#{quiz.id}") { click_on "Start Quiz" }
    expect_to_not_see "Question: 2"
    expect_to_not_see "How much is 2 + 2?"
    expect_to_not_see "4 points"
  end

  scenario "admin adds an answer" do
    within(:xpath, "//form/fieldset[2]") do
      add_answer(5, to: 2, content: "new answer") { mark_incorrect }
      remove_answer(4, from: 2)
    end
    click_on "Update Quiz"
    expect_to_see "Quiz was successfully updated."
    within(:css, "#quiz_#{quiz.id}") { click_on "Start Quiz" }
    expect_to_see "new answer" 
  end

  scenario "admin removes an answer" do
    remove_answer(5, from: 1)
    click_on "Update Quiz"
    expect_to_see "Quiz was successfully updated."
    within(:css, "#quiz_#{quiz.id}") { click_on "Start Quiz" }
    expect_to_not_see "delete me"
  end
end
