class Exam < ActiveRecord::Base
  belongs_to :student, class_name: "User"
  belongs_to :quiz
  before_create :default_student_answer_ids
  has_many :generated_questions, dependent: :destroy
  has_many :generated_answers, through: :generated_questions

  def default_student_answer_ids
    self.student_answer_ids = [] if student_answer_ids.nil?
  end

  def student_score
    quiz.questions.inject(0) do |score, question|
      score += question.points if question.yield_points?(self)
      score
    end
  end

  def build_questions_with_answers!
    quiz.questions.each do |question|
      generated_question = generated_questions.build(
        question: question,
        content: question.content,
        points: question.points
      )
      generated_question.build_answers!
    end
  end
end
