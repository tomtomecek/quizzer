class ExamsController < ApplicationController
  def new
    @quiz = Quiz.find_by(slug: params[:quiz_id])
    @exam = Exam.new(quiz: @quiz)
  end

  def create
    quiz = Quiz.find_by(slug: params[:quiz_id])
    student_id = 1
    exam = Exam.create(student_id: student_id, quiz: quiz)
    # params[:student_answer_ids].each do |said|
    #   student_answer = Answer.find(said.to_i)
    #   question = student_answer.question
      

    # end


    redirect_to [quiz, exam]
  end
end