class Question < ActiveRecord::Base
  belongs_to :quiz
  has_many :answers

  ANSWER_LIMIT = 4

  def answers_for(exam)
    results = exam.send(yield).collect do |id|
      answer = Answer.find(id.to_i)
      answer if answer.question == self
    end
    results.compact
  end

  def generate_answers
    total = generate_correct_answers
    incorrect_answers = answers.select(&:incorrect?)
    total << incorrect_answers.shuffle.pop until reached_answer_limit?(total)
    total.shuffle
  end

private

  def generate_correct_answers
    correct_answers = answers.select(&:correct?)
    if correct_answers.count > ANSWER_LIMIT
      max = ANSWER_LIMIT
    else
      max = correct_answers.count
    end
    correct_answers.shuffle.slice(0...rand(1..max))
  end

  def reached_answer_limit?(total)
    total.count == ANSWER_LIMIT
  end
end