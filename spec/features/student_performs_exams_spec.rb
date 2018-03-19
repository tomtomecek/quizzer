require "spec_helper"

feature "student performs an exams" do
  given!(:ruby)  { create_course(title: "Introduction to Ruby") }
  given!(:rails) { create_course(title: "Rapid Prototyping") }
  given!(:week1) do
    Fabricate(:quiz,
              course: ruby,
              title: "Week 1-Procedural",
              passing_percentage: 50,
              published: true) do
      questions do
        [
          Fabricate(:question, points: 3, content: "1+1") do
            answers { incorrect(4) + correct(1, content: "Answer is 2") }
          end,
          Fabricate(:question, points: 4, content: "2+2") do
            answers do
              incorrect(2) + incorrect(1, content: "W") +
              correct(1, content: "Answer is 4")
            end
          end,
          Fabricate(:question, points: 5, content: "3+3") do
            answers { incorrect(4) + correct(1, content: "Answer is 6") }
          end
        ]
      end
    end
  end
  given!(:week2) do
    Fabricate(:quiz,
              course: ruby,
              title: "Week 2-OOP",
              published: true,
              passing_percentage: 10)
  end
  given!(:q1) { week1.questions.first }
  given!(:q2) { week1.questions.second }
  given!(:q3) { week1.questions.last }

  background do
    clear_emails
    sign_in
    student = User.first
    enr = Fabricate(:enrollment, course: ruby, student: student, paid: false)
    Fabricate(:permission, student: student, quiz: week1, enrollment: enr)
  end
  after { clear_emails }

  scenario "student checks course page and enters a course" do
    visit courses_path
    expect(page).to have_content "Introduction to Ruby"
    expect(page).to have_content "Rapid Prototyping"
    within("#course_#{ruby.id}") { click_on "Continue with exams" }
    expect_to_be_in course_path(ruby.slug)
    expect(page).to have_content "Quizzes: 0 / 2"
    within(:css, '.quizzes') { expect(page).to have_css('.row', count: 2) }
  end

  scenario "student checks course for quizzes" do
    visit course_path(ruby.slug)
    expect(page).to have_content "Week 1-Procedural"
    expect(page).to have_content "Week 2-OOP"
    within("#quiz_#{week1.id}") { click_on "Start Quiz" }
    expect_to_be_in new_quiz_exam_path(week1.slug)
  end

  scenario "exam with successfull answers" do
    visit new_quiz_exam_path(week1.slug)
    within_exam_question(q1) do
      expect(page).to have_content "1+1"
      expect(page).to have_content "3 points"
      check("Answer is 2")
    end
    within_exam_question(q2) { check("Answer is 4") }
    within_exam_question(q3) { check("Answer is 6") }
    click_on "Submit Answers"
    expect_to_be_in quiz_exam_path(week1.slug, Exam.first)
    expect(page).to have_content "Score: 12 from 12 points"
    expect(page).to have_content "Congratulations. You have passed the quiz."
  end

  scenario "exam with missing and incorrect answers" do
    visit new_quiz_exam_path(week1.slug)
    within_exam_question(q1) { check("Answer is 2") }
    within_exam_question(q2) { check("W") }
    click_on "Submit Answers"

    expect(page).to have_content "Score: 3 from 12 points"
    expect(page).to have_content "Sorry, you have to re-attempt the quiz."
    within_exam_question(q1) do
      expect(page).to have_content "You earned 3 points"
    end
    within_exam_question(q2) do
      expect(page).to have_content "One of the answers was wrong"
    end
  end
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

def create_course(options = {})
  Fabricate(:course, title: options[:title] , published: true)
end
