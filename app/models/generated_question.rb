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

  def yield_points?
    notes = generated_answers.where(student_marked: true).
      inject(0) do |notes, ganswer|
        verify_student_answer?(ganswer) ? notes += 1 : notes -= 1
        notes
    end
    verify_question?(notes)
  end

private

  def verify_student_answer?(ganswer)
    ganswer.correct? && generated_answers.include?(ganswer)
  end

  def verify_question?(notes)
    notes == generated_answers.select(&:correct?).count
  end
end
