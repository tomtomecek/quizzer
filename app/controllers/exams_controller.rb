class ExamsController < ApplicationController
  def new
    quiz = Quiz.find(params[:quiz_id])
    @exam = Exam.new(quiz: quiz)
  end
end