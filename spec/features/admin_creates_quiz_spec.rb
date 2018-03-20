require 'spec_helper'

feature "Admin adds a quiz to a course" do
  given!(:ruby) { Fabricate(:course, title: "Ruby course") }
  background do
    sign_in_admin
    click_on "Ruby course"
    click_on "New Quiz"
  end

  scenario "successful quiz creation", :js do
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
    expect(page).to have_content "Week 1 - Ruby basics"
    expect(page).to have_content "Successfully created new quiz."
  end

  scenario "quiz invalid" do
    fill_in "Title",       with: ""
    fill_in "Description", with: ""
    select "10 %", from: "quiz_passing_percentage"
    uncheck "Published"
    click_on "Create Quiz"

    expect(page).to have_content "Quiz creation failed"
    expect_to_be_in quizzes_path
  end

  context "failed attempt on valid quiz" do
    background { fill_in_valid_quiz_attributes }

    scenario "reached answers limit", :js do
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
      expect(page).to have_content "Quiz creation failed -\
        Maximum 10 records are allowed. Got 11 records instead"
    end

    scenario "3 answers only", :js do
      add_question(1, with: "How much is 1 + 1?", points: 3) do |question|
        add_answer(1, to: question, with: "correct answer 2") { mark_correct }
        add_answer(2, to: question, with: "correct answer 2") { mark_correct }
        add_answer(3, to: question, with: "an answer")
      end

      click_on "Create Quiz"
      expect(page).to have_content "Quiz creation failed"
      expect(page).to have_content "Answers - there must be at least 4 answers."
    end

    scenario "question missing", :js do
      click_on "Create Quiz"
      expect(page).to have_content "Quiz creation failed"
      expect(page).to have_content "Questions requires at least 1 question."
    end

    scenario "all incorrect answers", :js do
      add_question(1, with: "How much is 1 + 1?", points: 3) do |question|
        add_answer(1, to: question, with: "incorrect") { mark_incorrect }
        add_answer(2, to: question, with: "incorrect") { mark_incorrect }
        add_answer(3, to: question, with: "incorrect") { mark_incorrect }
        add_answer(4, to: question, with: "incorrect") { mark_incorrect }
      end

      click_on "Create Quiz"
      expect(page).to have_content "Quiz creation failed"
      expect(page).to have_content "Answers - at least 1 must be correct."
    end
  end

  context "client side validations" do
    scenario "check on quiz", :js do
      fill_in "Title", with: ""
      expect(page).to have_content "This value is required."
      fill_in "Title", with: "Some title"
      expect(page).to_not have_content "This value is required."

      fill_in "Description", with: ""
      expect(page).to have_content "This value is required."
      fill_in "Description", with: "Some description"
      expect(page).to_not have_content "This value is required."
    end

    scenario "check on question", :js do
      fill_in_valid_quiz_attributes
      add_question(1, with: "", points: 3) do
        expect(page).to have_content "This value is required."
        fill_in "Question", with: "Some question"
        expect(page).to_not have_content "This value is required."

        select "Select Points"
        find("select").trigger('blur')

        expect(page).to have_content "This value is required."
        select 3
        expect(page).to_not have_content "This value is required."
      end
    end

    scenario "check on answer", :js do
      fill_in_valid_quiz_attributes
      add_question(1, with: "Some question", points: 3) do |question|
        add_answer(1, to: question, with: "") do
          expect(page).to have_content "This value is required."
          fill_in "Answer", with: "Some answer"
          expect(page).to_not have_content "This value is required."
        end
      end
    end
  end

  def fill_in_valid_quiz_attributes
    fill_in "Title",       with: "Week 1 - Ruby basics"
    fill_in "Description", with: "Ruby methods and iterations"
    select "60 %", from: "quiz_passing_percentage"
    uncheck "Published"
  end
end
