class Exam < ActiveRecord::Base
  belongs_to :student, class_name: "User"
  belongs_to :quiz
  before_create :default_student_answer_ids
  has_many :generated_questions, dependent: :destroy

  def default_student_answer_ids
    self.student_answer_ids = [] if student_answer_ids.nil?
  end

  def student_score
    quiz.questions.inject(0) do |score, question|
      score += question.points if question.yield_points?(self)
      score
    end
  end

  def build_questions!
    quiz.questions.each do |question|
      generated_questions.build(
        question: question,
        content: question.content,
        points: question.points
      )
    end
  end
end
