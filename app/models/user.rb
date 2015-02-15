class User < ActiveRecord::Base
  has_many :exams, foreign_key: "student_id"
  has_many :enrollments, foreign_key: "student_id"

  def self.from_omniauth(auth)    
    User.find_by_provider_and_uid(auth) || User.create_from_omniauth(auth)
  end

  def has_enrolled?(course)
    enrollments.where(course: course).exists?
  end

  def can_start?(quiz)
    return false unless quiz.published
    return true if quiz.position == 1
    return false if exams.empty?
    exams.find_by(quiz: quiz.previous).passed?
  end

private

  def self.create_from_omniauth(auth)
    create do |user|
      user.provider           = auth[:provider]
      user.uid                = auth[:uid]
      user.username           = auth[:info][:nickname]
      user.email              = auth[:info][:email]
      user.name               = auth[:info][:name]
      user.avatar_url         = auth[:info][:image]
      user.github_account_url = auth[:info][:urls][:GitHub]
    end
  end

  def self.find_by_provider_and_uid(auth)
    find_by(provider: auth[:provider], uid: auth[:uid])
  end
end
