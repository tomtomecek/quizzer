class Admin < ActiveRecord::Base
  has_secure_password validations: false

  def generate_password_reset_token
    begin
      token = SecureRandom.urlsafe_base64
    end while Admin.exists?(password_reset_token: token)

    update_column(:password_reset_token, token)
  end
end
