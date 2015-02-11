class Exam < ActiveRecord::Base
  belongs_to :student, class_name: "User"
  belongs_to :quiz
  belongs_to :enrollment

  has_many :generated_questions, dependent: :destroy
  has_many :generated_answers, through: :generated_questions

  scope :passed, -> { where(passed: true).order(:id) }

  def student_score
    generated_questions.inject(0) do |score, gquestion|
      score += gquestion.points if gquestion.yield_points?
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
