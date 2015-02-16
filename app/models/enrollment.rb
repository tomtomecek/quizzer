class Enrollment < ActiveRecord::Base
  belongs_to :course
  belongs_to :student, class_name: "User"

  has_many :exams

  validates :honor_code, acceptance: true

  def passed_exams
    exams.passed
  end

  def is_completed?
    passed_exams.count >= 3 && (passed_exams.count == course.published_quizzes.count)
  end
end
