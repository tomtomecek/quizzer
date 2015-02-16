class Enrollment < ActiveRecord::Base
  belongs_to :course
  belongs_to :student, class_name: "User"

  has_many :exams
  has_one :certificate

  validates :honor_code, acceptance: true

  def passed_exams
    exams.passed
  end

  def is_completed?
    reached_minimum_passed_exams? && passed_through_all_quizzes?
  end

private

  def reached_minimum_passed_exams?
    passed_exams.count >= 3
  end

  def passed_through_all_quizzes?
    passed_exams.count == course.published_quizzes.count
  end
end
