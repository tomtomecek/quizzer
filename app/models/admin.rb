class Admin < ActiveRecord::Base
  has_secure_password validations: false


  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]{2,}\z/i
  validates :email, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }, allow_nil: true
  validates :role, inclusion: { in: %w(Instructor Teaching\ assistant) }

  attr_accessor :remember_token

  def generate_password_reset_items
    begin
      token = SecureRandom.urlsafe_base64
    end while Admin.exists?(password_reset_token: token)

    update_columns(password_reset_token: token,
                   password_reset_expires_at: 2.hours.from_now)
  end

  def clear_token_and_expires_at!
    update_columns(password_reset_token: nil, password_reset_expires_at: nil)
  end

  def remember
    self.remember_token = generate_token
    update_column(:remember_digest, digest(remember_token))
  end

  def forget!
    update_column(:remember_digest, nil)
  end

  def authenticated?(token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(token)
  end

  def instructor?
    role == "Instructor"
  end

  def generate_activation_token!
    update_columns(activation_token: generate_token)
  end

private

  def generate_token
    SecureRandom.urlsafe_base64
  end

  def digest(string)
    if ActiveModel::SecurePassword.min_cost
      cost = BCrypt::Engine::MIN_COST
    else
      cost = BCrypt::Engine.cost
    end
    BCrypt::Password.create(string, cost: cost)
  end
end
