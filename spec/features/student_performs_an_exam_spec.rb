require "spec_helper"

feature "student performs an exam" do
  given(:ruby)  { Fabricate(:course, title: "Introduction to Ruby") }
  given(:rails) { Fabricate(:course, title: "Rapid Prototyping") }
  given(:week1) do
    Fabricate(:quiz, course: ruby, title: "Week 1-Procedural") do
      questions do
        [
          Fabricate(:question, points: 3, content: "1+1") do
            answers { incorrect(4) + correct(1, content: "answer is 2") }
          end,
          Fabricate(:question, points: 4, content: "2+2") do
            answers do
              incorrect(2) + incorrect(1, content: "W") +
              correct(1, content: "answer is 4")
            end
          end,
          Fabricate(:question, points: 5, content: "3+3") do
            answers { incorrect(4) + correct(1, content: "answer is 6") }
          end
        ]
      end
    end
  end
  given(:week2) { Fabricate(:quiz, course: ruby, title: "Week 2-OOP") }
  given(:q1) { week1.questions.first }
  given(:q2) { week1.questions.second }
  given(:q3) { week1.questions.last }

  background do
    build_setup
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

def build_setup
  rails
  week1
  week2
end

def incorrect(n = 1, options = {})
  if options == {}
    Fabricate.times(n, :incorrect)
  else
    Fabricate.times(n, :incorrect, content: options[:content])
  end
end

def correct(n = 1, options = {})
  if options == {}
    Fabricate.times(n, :correct)
  else
    Fabricate.times(n, :correct, content: options[:content])
  end
end