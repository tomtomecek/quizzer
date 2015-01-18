class Question < ActiveRecord::Base
  belongs_to :quiz
  has_many :answers

  def generated_answers(exam)
    results = exam.generated_answer_ids.collect do |id|
      answer = Answer.find(id.to_i)
      answer if answer.question == self
    end
    results.compact
  end

end