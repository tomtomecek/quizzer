class EnrollmentMailer < ActionMailer::Base
  default from: "support@squizzer.com"

  def welcome_signature_track(user, course)
    @student = user
    @course = course
    mail to: check_for_staging, subject: "Signature track - confirmed"
  end

private

  def check_for_staging
    Rails.env.staging? ? ENV['ADMIN_EMAIL'] : @student.email
  end
end
