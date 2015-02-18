require 'spec_helper'

feature "student receives certificate" do
  given(:ruby) { Fabricate(:course) }
  given!(:quiz1) { Fabricate(:quiz, course: ruby, published: true) }
  given!(:quiz2) { Fabricate(:quiz, course: ruby, published: true) }
  given!(:quiz3) { build_quiz }
  given(:q1) { quiz3.questions.first }
  given(:alice) { User.first }
  given(:cert) { Certificate.first }
  background { sign_in }

  scenario "via email", :js, driver: :selenium do
    paid = Fabricate(:enrollment, paid: true, student: alice, course: ruby)
    Fabricate(:exam, passed: true, student: alice, quiz: quiz1, enrollment: paid)
    Fabricate(:exam, passed: true, student: alice, quiz: quiz2, enrollment: paid)
    Fabricate(:permission, student: alice, quiz: quiz1, enrollment: paid)
    Fabricate(:permission, student: alice, quiz: quiz2, enrollment: paid)
    Fabricate(:permission, student: alice, quiz: quiz3, enrollment: paid)
    visit course_path(ruby.slug)    
    click_on "Start Quiz"
    within_exam_question(q1) { check("Correct Answer") }    
    click_on "Submit Answers"
    expect_to_see course_completion_message

    open_email("alice@example.com")
    expect_to_see_in_email "Please access your Certificate of Accomplishment"
    current_email.click_link "here"

    expect_to_be_in certificate_path(cert.licence_number)
    clear_emails
  end

  scenario "via direct link visit" do
    paid = Fabricate(:enrollment, paid: true, student: alice, course: ruby)
    Fabricate(:certificate, student: alice, enrollment: paid)
    visit certificate_path(cert.licence_number)
    click_on "Download as PDF"

    expect(response_headers['Content-Type']).to eq "application/pdf"
    expect(response_headers['Content-Disposition']).to include("filename='certificate.pdf'")
  end
end

def build_quiz
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
  "You have successfully completed this course! We sent you email
 with instructions about your certification"
end