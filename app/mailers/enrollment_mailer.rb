class EnrollmentMailer < ActionMailer::Base
  default from: "support@squizzer.com"

  def welcome_signature_track(user, course)
    @student = user
    @course = course
    mail to: check_for_staging, subject: "Signature track - confirmed"
  end

  def announce_certificate(user, certificate)
    @student = user
    @certificate = certificate
    mail to: check_for_staging, subject: "Your certification is ready!"
  end

private

  def check_for_staging
    Rails.env.staging? ? ENV['ADMIN_EMAIL'] : @student.email
  end
end
