require 'spec_helper'

feature "admin adds a quiz to a course" do
  given!(:ruby) { Fabricate(:course, title: "Ruby course") }
  background do
    sign_in_admin
    click_on "Ruby course"
    click_on "New Quiz"
  end

  scenario "successful quiz creation", js: true do
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
      add_answer(5, to: question, with: "") { mark_correct }
    end

    click_on "Create Quiz"
    expect_to_be_in admin_course_path(ruby)
    expect_to_see "Week 1 - Ruby basics"
    expect_to_see "Successfully created new quiz."
  end

  scenario "failed attempt on quiz creation" do
    fill_in "Title",       with: ""
    fill_in "Description", with: ""
    uncheck "Published"
    click_on "Create Quiz"

    expect_to_see "Quiz creation failed"
    expect_to_be_in quizzes_path
  end

  scenario "failed attempt on quiz - question blank", js: true do
    fill_in_valid_quiz_attributes

    add_question(1, with: "", points: 3) do |question|
      add_answer(1, to: question, with: "correct answer 2") { mark_correct }
      add_answer(2, to: question, with: "correct answer 2") { mark_correct }
      add_answer(3, to: question, with: "incorrect answer") { mark_incorrect }
      add_answer(4, to: question, with: "incorrect answre") { mark_incorrect }
    end

    click_on "Create Quiz"
    expect_to_see "Quiz creation failed"
  end

  scenario "failed attempt on quiz - reached answers limit", js: true do
    fill_in_valid_quiz_attributes

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
    expect_to_see "Quiz creation failed"
  end
end

def fill_in_valid_quiz_attributes
  fill_in "Title",       with: "Week 1 - Ruby basics"
  fill_in "Description", with: "Ruby methods and iterations"
  uncheck "Published"
end

def mark_correct
  find(:css, "input[type=checkbox]").set(true)
end

def mark_incorrect
  find(:css, "input[type=checkbox]").set(false)
end
