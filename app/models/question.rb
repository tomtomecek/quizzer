class Question < ActiveRecord::Base
  belongs_to :quiz
  has_many :answers

  validates_presence_of :content
  validates_numericality_of :points, only_integer: true
  validate :minimum_answers
  validate :one_must_be_correct

  accepts_nested_attributes_for(
    :answers,
    reject_if: proc { |a| a[:content].blank? },
    limit: proc { 10 },
    allow_destroy: true
  )

  attr_reader :total

  ANSWER_LIMIT = 4

  def answers_for(exam, method_name)
    results = exam.send(method_name).collect do |id|
      answer = Answer.find(id.to_i)
      answer if answer.question == self
    end
    results.compact
  end

  def generate_answers
    @total = [answers.select(&:correct?).sample]
    fill_up_answer_limit.shuffle
  end

  def yield_points?(exam)
    @generated_answers = answers_for(exam, :generated_answer_ids)
    notes = answers_for(exam, :student_answer_ids).inject(0) do |notes, answer|
      verify_student_answer?(answer) ? notes += 1 : notes -= 1
      notes
    end
    verify_question?(notes)
  end

  def has_no_student_answer?(exam)
    answers_for(exam, :student_answer_ids).empty?
  end

private

  def one_must_be_correct
    unless answers.map(&:correct?).any?
      errors[:answers] << "- at least 1 must be correct."
    end
  end

  def minimum_answers
    if answers.size < 4
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
    total.count == ANSWER_LIMIT
  end

  def verify_student_answer?(answer)
    answer.correct? && @generated_answers.include?(answer)
  end

  def verify_question?(notes)
    notes == @generated_answers.select(&:correct?).count
  end
end
