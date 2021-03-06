class AdminMailer < ActionMailer::Base
  default from: "admin-support@squizzer.com"

  def send_reset_token(admin)
    @admin = admin
    mail to: staging(@admin.email), subject: "Reset Password - #{@admin.email}"
  end

  def send_activation_link(admin)
    @admin = admin
    mail to: staging(@admin.email), subject: "Account activation"
  end

private

  def staging(email)
    Rails.env.staging? ? ENV['ADMIN_EMAIL'] : email
  end
end
