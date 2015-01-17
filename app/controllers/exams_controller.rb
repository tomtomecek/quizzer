class ExamsController < ApplicationController
  def new
    @quiz = Quiz.find_by(slug: params[:quiz_id])
    @exam = Exam.new(quiz: @quiz)
  end
end