class Certificate < ActiveRecord::Base
  belongs_to :enrollment
  belongs_to :student, class_name: "User"

  delegate :course, to: :enrollment
  before_create :add_licence_number

  def add_licence_number
    begin
      num = generate_token
    end while Certificate.exists?(licence_number: num)
    self.licence_number = num
  end

  def file_name
    "certificate_#{student.username}_#{created_at.strftime('%Y-%m-%d')}"
  end

private

  def generate_token
    SecureRandom.urlsafe_base64
  end
end
