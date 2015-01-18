class ExamsController < ApplicationController
  def new
    @quiz = Quiz.find_by(slug: params[:quiz_id])
    @exam = Exam.new(quiz: @quiz)
  end

  def create
    quiz = Quiz.find_by(slug: params[:quiz_id])
    exam = Exam.create(
      quiz: quiz,
      generated_answer_ids: params[:generated_answer_ids],
      student_answer_ids: params[:student_answer_ids])    
    redirect_to [quiz, exam]
  end

  def show    
    @exam = Exam.find(params[:id])
    @quiz = @exam.quiz    
  end
end