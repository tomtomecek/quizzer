class GeneratedQuestion < ActiveRecord::Base
  belongs_to :question
  belongs_to :exam
  has_many :generated_answers, dependent: :destroy

  def build_answers!
    question.generate_answers.each do |ga|
      generated_answers.build(
        answer: ga,
        content: ga.content,
        correct: ga.correct
      )
    end
  end
end
