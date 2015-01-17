class ExamsController < ApplicationController
  def new
    @quiz = Quiz.find_by(slug: params[:quiz_id])
    @exam = Exam.new(quiz: @quiz)
  end

  def create
    quiz = Quiz.find_by(slug: params[:quiz_id])
    student_id = 1
    exam = Exam.create(student_id: student_id, quiz: quiz)
    params[:student_answer_ids].each do |said|
      binding.pry
      StudentAnswer.create(exam: exam, answer_id: said.to_i)
    end

    redirect_to [quiz, exam]
  end
end