require 'spec_helper'

feature "admin adds a quiz to a course" do
  given!(:ruby) { Fabricate(:course, title: "Ruby course") }
  background do
    sign_in_admin
    click_on "Ruby course"
    click_on "New Quiz"
  end

  scenario "successful quiz creation", js: true, slow: true do
    fill_in_valid_quiz_attributes

    add_question(1, with: "How much is 1 + 1?", points: 3) do |question|
      add_answer(1, to: question, with: "correct answer 2") { mark_correct }
      add_answer(2, to: question, with: "correct answer 2") { mark_correct }
      add_answer(3, to: question, with: "incorrect answer") { mark_incorrect }
      add_answer(4, to: question, with: "incorrect answer") { mark_incorrect }
    end

    add_question(2, with: "How much is 2 + 2?", points: 4) do |question|
      add_answer(1, to: question, with: "correct answer 4") { mark_correct }
      add_answer(2, to: question, with: "correct answer 4") { mark_correct }
      add_answer(3, to: question, with: "correct answer 4") { mark_correct }
      add_answer(4, to: question, with: "correct answer 4") { mark_correct }
    end

    click_on "Create Quiz"
    expect_to_be_in admin_course_path(ruby)
    expect_to_see "Week 1 - Ruby basics"
    expect_to_see "Successfully created new quiz."
  end

  scenario "quiz invalid" do
    fill_in "Title",       with: ""
    fill_in "Description", with: ""
    uncheck "Published"
    click_on "Create Quiz"

    expect_to_see "Quiz creation failed"
    expect_to_be_in quizzes_path
  end

  context "failed attempt on valid quiz", js: true do
    background { fill_in_valid_quiz_attributes }

    scenario "question blank", driver: :selenium, slow: true do
      add_question(1, with: "", points: 3) do |question|
        add_answer(1, to: question, with: "correct answer 2") { mark_correct }
        add_answer(2, to: question, with: "correct answer 2") { mark_correct }
        add_answer(3, to: question, with: "incorrect answer") { mark_incorrect }
        add_answer(4, to: question, with: "incorrect answre") { mark_incorrect }
      end

      click_on "Create Quiz"
      expect_to_see "This value is required."
    end

    scenario "reached answers limit", slow: true do
      add_question(1, with: "How much is 1 + 1?", points: 3) do |question|
        add_answer(1, to: question, with: "correct answer 2") { mark_correct }
        add_answer(2, to: question, with: "correct answer 2") { mark_correct }
        add_answer(3, to: question, with: "an answer")
        add_answer(4, to: question, with: "an answer")
        add_answer(5, to: question, with: "an answer")
        add_answer(6, to: question, with: "an answer")
        add_answer(7, to: question, with: "an answer")
        add_answer(8, to: question, with: "an answer")
        add_answer(9, to: question, with: "an answer")
        add_answer(10, to: question, with: "an answer")
        add_answer(11, to: question, with: "an answer")
      end

      click_on "Create Quiz"
      expect_to_see "Quiz creation failed -\
        Maximum 10 records are allowed. Got 11 records instead"
    end

    scenario "3 answers only", slow: true do
      add_question(1, with: "How much is 1 + 1?", points: 3) do |question|
        add_answer(1, to: question, with: "correct answer 2") { mark_correct }
        add_answer(2, to: question, with: "correct answer 2") { mark_correct }
        add_answer(3, to: question, with: "an answer")
      end

      click_on "Create Quiz"
      expect_to_see "Quiz creation failed"
      expect_to_see "Answers - there must be at least 4 answers."
    end

    scenario "question missing", slow: true do
      click_on "Create Quiz"
      expect_to_see "Quiz creation failed"
      expect_to_see "Questions requires at least 1 question."
    end

    scenario "all incorrect answers", slow: true do
      add_question(1, with: "How much is 1 + 1?", points: 3) do |question|
        add_answer(1, to: question, with: "incorrect") { mark_incorrect }
        add_answer(2, to: question, with: "incorrect") { mark_incorrect }
        add_answer(3, to: question, with: "incorrect") { mark_incorrect }
        add_answer(4, to: question, with: "incorrect") { mark_incorrect }
      end

      click_on "Create Quiz"
      expect_to_see "Quiz creation failed"
      expect_to_see "Answers - at least 1 must be correct."
    end
  end

  context "client side validations", js: true do
    scenario "check on quiz", driver: :selenium, slow: true do
      fill_in "Title", with: ""
      click_away
      expect_to_see "This value is required."
      fill_in "Title", with: "Some title"
      click_away
      expect_to_not_see "This value is required."

      fill_in "Description", with: ""
      click_away
      expect_to_see "This value is required."
      fill_in "Description", with: "Some description"
      click_away
      expect_to_not_see "This value is required."
    end

    scenario "check on question", driver: :selenium, slow: true do
      fill_in_valid_quiz_attributes
      add_question(1, with: "", points: 3) do
        click_away
        expect_to_see "This value is required."
        fill_in "Question", with: "Some question"
        click_away
        expect_to_not_see "This value is required."

        select "Select Points"
        click_away
        expect_to_see "This value is required."
        select 3
        click_away
        expect_to_not_see "This value is required."
      end
    end

    scenario "check on answer", slow: true do
      fill_in_valid_quiz_attributes
      add_question(1, with: "Some question", points: 3) do |question|
        add_answer(1, to: question, with: "") do
          click_away
          expect_to_see "This value is required."
          fill_in "Answer", with: "Some answer"
          click_away
          expect_to_not_see "This value is required."
        end
      end
    end
  end
end

def fill_in_valid_quiz_attributes
  fill_in "Title",       with: "Week 1 - Ruby basics"
  fill_in "Description", with: "Ruby methods and iterations"
  uncheck "Published"
end
