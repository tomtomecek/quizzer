require 'spec_helper'

feature "student goes through whole course" do
  given(:year) { Time.now.year + 3 }
  given(:ruby) { Fabricate(:course) }

  scenario "full course experience", :js, :vcr, driver: :selenium do
    quiz1 = build_quiz(ruby)
    quiz2 = build_quiz(ruby)
    quiz3 = build_quiz(ruby)
    q1 = quiz1.questions.first
    q2 = quiz2.questions.first
    q3 = quiz3.questions.first
    sign_in
    enroll_paid

    within(:css, ".well") { expect_to_see "Quizzes: 0 / 3" }
    within(:css, "#quiz_#{quiz2.id}") do
      expect_to_see "You have to pass previous quiz first"
    end
    within(:css, "#quiz_#{quiz3.id}") do
      expect_to_see "You have to pass previous quiz first"
    end
    within(:css, "#quiz_#{quiz1.id}") { click_on "Start Quiz" }
    within_exam_question(q1) { check("Correct Answer") }
    click_on "Submit Answers"
    expect_to_see "Congratulations. You have passed the quiz."
    click_on "Back to course area"

    within(:css, ".well") { expect_to_see "Quizzes: 1 / 3" }
    within(:css, "#quiz_#{quiz1.id}") { expect_to_see "Exam passed" }
    within(:css, "#quiz_#{quiz3.id}") do
      expect_to_see "You have to pass previous quiz first"
    end
    within(:css, "#quiz_#{quiz2.id}") { click_on "Start Quiz" }
    within_exam_question(q2) { check("Correct Answer") }
    click_on "Submit Answers"
    expect_to_see "Congratulations. You have passed the quiz."
    click_on "Back to course area"

    within(:css, ".well") { expect_to_see "Quizzes: 2 / 3" }
    within(:css, "#quiz_#{quiz1.id}") { expect_to_see "Exam passed" }
    within(:css, "#quiz_#{quiz2.id}") { expect_to_see "Exam passed" }
    within(:css, "#quiz_#{quiz3.id}") { click_on "Start Quiz" }
    expect_to_not_see "You have to pass previous quiz first"
    within_exam_question(q3) { check("Correct Answer") }
    click_on "Submit Answers"
    expect_to_see "Congratulations. You have passed the quiz."
    click_on "Back to course area"

    within(:css, "#quiz_#{quiz1.id}") { expect_to_see "Exam passed" }
    within(:css, "#quiz_#{quiz2.id}") { expect_to_see "Exam passed" }
    within(:css, "#quiz_#{quiz3.id}") { expect_to_see "Exam passed" }
    save_and_open_screenshot
    within(:css, ".well") do
      expect_to_see "Quizzes: 3 / 3"
      expect_to_see "Congratulations! Check out your certification"
      click_on "here"
    end
    save_and_open_screenshot
  end
end

def build_quiz(ruby)
  Fabricate(:quiz, course: ruby, published: true, passing_percentage: 50) do
    questions { build_question }
  end
end

def build_question
  [
    Fabricate(:question, points: 10) do
      answers {
        Fabricate.times(3, :incorrect) << Fabricate(:correct, content: "Correct Answer")
      }
    end
  ]
end

def enroll_paid
  click_on "Enroll now"
  find(:xpath, "//label[contains(.,'Signature Track')]").click
  fill_in "Credit Card Number", with: "4242424242424242"
  fill_in "Security Code",      with: "123"
  select "1 - January", from: "date_month"
  select year, from: "date_year"
  check "I agree"
  click_on "Enroll now!"
end