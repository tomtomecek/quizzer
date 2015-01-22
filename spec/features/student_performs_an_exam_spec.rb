require "spec_helper"

feature "student performs an exam" do
  given!(:ruby)  { Fabricate(:course, title: "Introduction to Ruby") }
  given!(:rails) { Fabricate(:course, title: "Rapid Prototyping") }
  given!(:week1) { Fabricate(:quiz, course: ruby, title: "Week 1-Procedural") }
  given!(:week2) { Fabricate(:quiz, course: ruby, title: "Week 2-OOP") }
  given!(:q1) { Fabricate(:question, quiz: week1, points: 3, content: "1+1") }
  given!(:q2) { Fabricate(:question, quiz: week1, points: 4, content: "2+2") }
  given!(:q3) { Fabricate(:question, quiz: week1, points: 5, content: "3+3") }

  given!(:a1) do
    Fabricate(:answer, question: q1, correct: true, content: "answer is 2")
  end
  given!(:wrong_answer) do
    Fabricate(:answer, question: q2, correct: false, content: "w")
  end
  given!(:a2) do
    Fabricate(:answer, question: q2, correct: true, content: "answer is 4")
  end
  given!(:a3) do
    Fabricate(:answer, question: q3, correct: true, content: "answer is 6")
  end

  background do
    Fabricate.times(4, :answer, question: q1, correct: false, content: "x")
    Fabricate.times(2, :answer, question: q2, correct: false, content: "x")
    Fabricate.times(4, :answer, question: q3, correct: false, content: "x")
    sign_in
  end

  scenario "student checks course page and enters a course" do
    visit root_path
    expect_to_see "Introduction to Ruby"
    expect_to_see "Rapid Prototyping"
    within("#course_#{ruby.id}") { click_on "Enter" }
    expect(current_path).to eq course_path(ruby.slug)
  end

  scenario "student checks course for quizzes" do
    visit course_path(ruby.slug)
    expect_to_see "Week 1-Procedural"
    expect_to_see "Week 2-OOP"
    within("#quiz_#{week1.id}") { click_on "Start Quiz" }
    expect(current_path).to eq new_quiz_exam_path(week1.slug)
  end

  scenario "exam with successfull answers" do
    visit new_quiz_exam_path(week1.slug)
    within_question(q1) do
      expect_to_see "1+1"
      expect_to_see "3 points"
      check("Answer is 2")
    end

    within_question(q2) { check("Answer is 4") }
    within_question(q3) { check("Answer is 6") }
    click_on "Submit Answers"
    expect(current_path).to eq quiz_exam_path(week1.slug, Exam.first)
    expect_to_see "Score: 12 from 12 points"
  end

  scenario "exam with missing and incorrect answers" do
    visit new_quiz_exam_path(week1.slug)
    within_question(q1) { check("Answer is 2") }
    within_question(q2) { check("W") }
    click_on "Submit Answers"

    expect_to_see "Score: 3 from 12 points"
    within_question(q1) { expect_to_see "You earned 3 points" }
    within_question(q2) { expect_to_see "One of the answers was wrong" }
    within_question(q3) { expect_to_see "No answers submitted" }
  end
end

def within_question(question)
  within(:css, "#question_#{question.id}") do
    yield
  end
end
