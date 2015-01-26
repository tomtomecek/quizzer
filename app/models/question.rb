class Question < ActiveRecord::Base
  belongs_to :quiz
  has_many :answers

  validates_presence_of :content
  validates_numericality_of :points, only_integer: true
  accepts_nested_attributes_for :answers, allow_destroy: true

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
