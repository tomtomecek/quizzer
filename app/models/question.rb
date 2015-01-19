class Question < ActiveRecord::Base
  belongs_to :quiz
  has_many :answers

  ANSWER_LIMIT = 4

  def answers_for(exam, method_name)
    results = exam.send(method_name).collect do |id|
      answer = Answer.find(id.to_i)
      answer if answer.question == self
    end
    results.compact
  end

  def generate_answers
    total = generate_correct_answers
    fill_up_with_incorrect_answers(total).shuffle
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

  def generate_correct_answers
    correct_answers = answers.select(&:correct?)
    if correct_answers.count > ANSWER_LIMIT
      max = ANSWER_LIMIT
    else
      max = correct_answers.count
    end
    correct_answers.shuffle.slice(0...rand(1..max))
  end

  def fill_up_with_incorrect_answers(total)
    incorrect_answers = answers.select(&:incorrect?).shuffle
    total << incorrect_answers.pop until reached_answer_limit?(total)
    total
  end

  def reached_answer_limit?(total)
    total.count == ANSWER_LIMIT
  end

  def verify_student_answer?(answer)
    answer.correct? && @generated_answers.include?(answer)
  end

  def verify_question?(notes)
    notes == @generated_answers.select(&:correct?).count
  end
end