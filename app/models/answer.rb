class Answer < ActiveRecord::Base
  include AnswerExceptions
  CORRECT_ANSWER_COUNT_MIN = 1
  ANSWER_COUNT_MIN = 4

  belongs_to :question
  validates :content, presence: true

  validate :check_correct_sibling_answers, on: :update
  validate :check_answers_count, on: :update

  def incorrect?
    !self.correct?
  end

  def destroy
    arr = []
    arr << self.question.answers
    arr.flatten!
    arr.delete(self)
    unless arr.map(&:correct?).any?
      message = "At least 1 answer must be correct."
      raise AnswerException.new(message: message)
    end
    unless arr.count >= 4
      message = "Question requires at least 4 answers."
      raise AnswerException.new(message: message)
    end
    super
  end

private

  def check_correct_sibling_answers
    return true if question_id.nil?
    unless question.answers.pluck(:correct).any?
      errors.add(:base, :answers_incorrect)
    end
  end

  def answers_count_valid?
    question.answers.count >= ANSWER_COUNT_MIN
  end

  def check_answers_count
    return true if question_id.nil?
    unless answers_count_valid?
      errros.add(:base, :answers_too_short)
    end
  end
end
