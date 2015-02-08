class Admin < ActiveRecord::Base
  has_secure_password validations: false

  validates :password, length: { minimum: 6 }

  def generate_password_reset_token
    begin
      token = SecureRandom.urlsafe_base64
    end while Admin.exists?(password_reset_token: token)

    update_columns(password_reset_token: token,
                   password_reset_expires_at: 2.hours.from_now)
  end

  def clear_token_and_expires_at!
    update_columns(password_reset_token: nil, password_reset_expires_at: nil)
  end
end
