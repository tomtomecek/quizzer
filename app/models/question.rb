class Question < ActiveRecord::Base
  MAX_ANSWER_LIMIT = 10
  MIN_ANSWER_LIMIT = 4
  belongs_to :quiz
  has_many :answers, dependent: :destroy

  validates_presence_of :content
  validates_numericality_of :points, only_integer: true
  validate do
    check_answers_number
    one_must_be_correct
  end

  accepts_nested_attributes_for(
    :answers,
    reject_if: proc { |a| a[:content].blank? },
    limit: proc { MAX_ANSWER_LIMIT },
    allow_destroy: true
  )

  attr_reader :total

  def generate_answers
    @total = [answers.select(&:correct?).sample]
    fill_up_answer_limit.shuffle
  end

private

  def one_must_be_correct
    unless answers.map(&:correct?).any?
      errors[:answers] << "- at least 1 must be correct."
    end
  end

  def answers_count_valid?
    answers.reject(&:marked_for_destruction?).size < MIN_ANSWER_LIMIT
  end

  def check_answers_number
    if answers_count_valid?
      errors[:answers] << "- there must be at least 4 answers."
    end
  end

  def fill_up_answer_limit
    add_answer_to_total until reached_answer_limit?
    total
  end

  def add_answer_to_total
    total << answers.sample
    total.uniq!
  end

  def reached_answer_limit?
    total.count == MIN_ANSWER_LIMIT
  end

end
