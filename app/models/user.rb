class User < ActiveRecord::Base
  has_many :exams, foreign_key: "student_id"
  has_many :enrollments, foreign_key: "student_id"
  has_many :permissions, foreign_key: "student_id"
  has_many :certificates, foreign_key: "student_id"

  def self.from_omniauth(auth)    
    User.find_by_provider_and_uid(auth) || User.create_from_omniauth(auth)
  end

  def has_enrolled?(course)
    enrollments.where(course: course).exists?
  end

  def has_permission?(quiz)
    permissions.pluck(:quiz_id).include? quiz.id
  end

  def examined_from?(quiz)
    exams.pluck(:quiz_id).include? quiz.id
  end

  def exam(quiz)
    exams.find_by(quiz: quiz)
  end

  def passed_exam?(quiz)
    exams.passed.pluck(:quiz_id).include? quiz.id
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
