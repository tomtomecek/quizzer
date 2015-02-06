class Answer < ActiveRecord::Base
  CORRECT_ANSWER_COUNT_MIN = 1
  ANSWER_COUNT_MIN = 4

  belongs_to :question
  validates_presence_of :content

  validate :check_correct_sibling_answers, on: :update
  validate :check_answers_count, on: :update

  def incorrect?
    !self.correct?
  end

private

  def check_correct_sibling_answers
    unless self.question.answers.pluck(:correct).any?
      errors.add(:base, :answers_incorrect)
    end
  end

  def answers_count_valid?
    self.question.answers.count >= ANSWER_COUNT_MIN
  end

  def check_answers_count
    unless answers_count_valid?
      errros.add(:base, :answers_too_short)
    end
  end
end
