require 'spec_helper'

feature "student goes through whole course" do
  given(:year)  { Time.now.year + 3 }
  given(:ruby)  { Fabricate(:course, published: true, min_quiz_count: 3) }
  given(:quiz1) { build_quiz(ruby) }
  given(:quiz2) { build_quiz(ruby) }
  given(:quiz3) { build_quiz(ruby) }
  given!(:q1)   { quiz1.questions.first }
  given!(:q2)   { quiz2.questions.first }
  given!(:q3)   { quiz3.questions.first }
  background { clear_emails }
  after { clear_emails }

  scenario "full course experience", :js, :vcr do
    sign_in
    enroll_paid
    within(".jumbotron") { expect(page).to have_content "Quizzes: 0 / 3" }
    within("#quiz_#{quiz2.id}") do
      expect(page).to have_content "You have to pass previous quiz first"
    end
    within("#quiz_#{quiz3.id}") do
      expect(page).to have_content "You have to pass previous quiz first"
    end
    within("#quiz_#{quiz1.id}") { click_on "Start Quiz" }
    within_exam_question(q1) { check("Correct Answer") }
    click_on "Submit Answers"
    expect(page).to have_content "Congratulations. You have passed the quiz."
    within(".jumbotron") { click_on "Course area" }

    within(".jumbotron") { expect(page).to have_content "Quizzes: 1 / 3" }
    within("#quiz_#{quiz1.id}") { expect(page).to have_content "Exam passed" }
    within("#quiz_#{quiz3.id}") do
      expect(page).to have_content "You have to pass previous quiz first"
    end
    within("#quiz_#{quiz2.id}") { click_on "Start Quiz" }
    within_exam_question(q2) { check("Correct Answer") }
    click_on "Submit Answers"
    expect(page).to have_content "Congratulations. You have passed the quiz."
    within(".jumbotron") { click_on "Course area" }

    within(".jumbotron") { expect(page).to have_content "Quizzes: 2 / 3" }
    within("#quiz_#{quiz1.id}") { expect(page).to have_content "Exam passed" }
    within("#quiz_#{quiz2.id}") { expect(page).to have_content "Exam passed" }
    within("#quiz_#{quiz3.id}") { click_on "Start Quiz" }
    expect_to_not_see "You have to pass previous quiz first"
    within_exam_question(q3) { check("Correct Answer") }
    click_on "Submit Answers"
    expect(page).to have_content "Congratulations. You have passed the quiz."
    within(".jumbotron") { click_on "Course area" }

    within("#quiz_#{quiz1.id}") { expect(page).to have_content "Exam passed" }
    within("#quiz_#{quiz2.id}") { expect(page).to have_content "Exam passed" }
    within("#quiz_#{quiz3.id}") { expect(page).to have_content "Exam passed" }
    within(".jumbotron") do
      expect(page).to have_content "Quizzes: 3 / 3"
      expect(page).to have_content "Your PDF certificate is ready:"
      expect(page).to have_css('img.linkedin-button', visible: true)
    end
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
        Fabricate.times(3, :incorrect) <<
        Fabricate(:correct, content: "Correct Answer")
      }
    end
  ]
end

def enroll_paid
  click_on "Enroll now"
  find(:xpath, "//label[contains(.,'Signature Track')]").trigger('click')
  fill_in "Credit Card Number", with: "4242424242424242"
  fill_in "Security Code", with: "123"
  select "1 - January", from: "date_month"
  select year, from: "date_year"
  find('input[type=checkbox]').trigger('click')
  find('#stripeSubmit').trigger('click')
end
