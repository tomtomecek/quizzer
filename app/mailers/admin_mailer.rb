class AdminMailer < ActionMailer::Base
  default from: "admin-support@squizzer.com"

  def send_reset_token(admin)
    @admin = admin
    mail to: @admin.email, subject: "Reset Password - #{@admin.email}"
  end

private

  def staging(email)
    Rails.env.staging? ? ENV['ADMIN_EMAIL'] : email
  end
end
