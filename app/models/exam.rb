class Exam < ActiveRecord::Base
  belongs_to :quiz
  before_create :default_student_answer_ids

  def default_student_answer_ids
    self.student_answer_ids = [] if student_answer_ids.nil?
  end

  def student_score
    score = 0
    quiz.questions.each do |question|
      @generated_answers = question.answers_for(self) { :generated_answer_ids }
      notes = 0
      question.answers_for(self) { :student_answer_ids }.each do |answer|
        verify_student_answer?(answer) ? notes += 1 : notes -= 1
      end
      score += question.points if verify_question?(notes)
    end
    score
  end

private

  def verify_student_answer?(answer)
    answer.correct? && @generated_answers.include?(answer)
  end

  def verify_question?(notes)
    notes == @generated_answers.select(&:correct?).count
  end
end