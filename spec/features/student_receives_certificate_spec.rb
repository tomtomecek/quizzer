require 'spec_helper'

feature "student receives certificate" do
  given(:ruby) { Fabricate(:course, published: true, min_quiz_count: 3) }
  given!(:quiz1) { Fabricate(:quiz, course: ruby, published: true) }
  given!(:quiz2) { Fabricate(:quiz, course: ruby, published: true) }
  given!(:quiz3) { build_quizz(ruby) }
  given(:q1) { quiz3.questions.first }
  given(:alice) { User.first }
  given(:cert) { Certificate.first }
  background do
    clear_emails
    sign_in
  end
  after { clear_emails }

  scenario "via email", :js do
    paid = Fabricate(:enrollment, paid: true, student: alice, course: ruby)
    Fabricate(:exam,
              passed: true,
              student: alice,
              quiz: quiz1,
              enrollment: paid)
    Fabricate(:exam,
              passed: true,
              student: alice,
              quiz: quiz2,
              enrollment: paid)
    Fabricate(:permission, student: alice, quiz: quiz1, enrollment: paid)
    Fabricate(:permission, student: alice, quiz: quiz2, enrollment: paid)
    Fabricate(:permission, student: alice, quiz: quiz3, enrollment: paid)
    visit course_path(ruby.slug)
    click_on "Start Quiz"
    within_exam_question(q1) { check("Correct Answer") }
    click_on "Submit Answers"
    expect(page).to have_content course_completion_message

    open_email("alice@example.com")
    expect_to_see_in_email "Please access your Certificate of Accomplishment"
    current_email.click_link "here"

    expect_to_be_in certificate_path(cert.licence_number)
  end

  scenario "via direct link visit", :no_travis do
    paid = Fabricate(:enrollment, paid: true, student: alice, course: ruby)
    Fabricate(:certificate, student: alice, enrollment: paid)
    visit certificate_path(cert.licence_number)

    click_on "Download as PDF"
    expect(response_headers['Content-Type']).to eq "application/pdf"
    expect(response_headers['Content-Disposition']).to include "inline; \
filename=\"#{cert.file_name}.pdf\""
  end
end

def build_quizz(ruby)
  Fabricate(:quiz, course: ruby, published: true) do
    questions do
      [
        Fabricate(:question) do
          answers do
            Fabricate.times(3, :incorrect) <<
              Fabricate(:correct, content: "Correct Answer")
          end
        end
      ]
    end
  end
end

def course_completion_message
  "You have successfully completed this course! We sent you email\
  with instructions about your certification"
end