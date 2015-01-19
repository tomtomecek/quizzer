class Exam < ActiveRecord::Base
  belongs_to :quiz
  before_create :default_student_answer_ids

  def default_student_answer_ids
    self.student_answer_ids = [] if student_answer_ids.nil?
  end

  def student_score
    quiz.questions.inject(0) do |score, question|
      score += question.points if question.yield_points?(self)
      score
    end
  end
end