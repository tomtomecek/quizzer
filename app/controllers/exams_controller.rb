class ExamsController < ApplicationController
  before_action :require_user

  def new
    @quiz = Quiz.find_by(slug: params[:quiz_id])
    @exam = current_user.exams.find_or_create_by(quiz: @quiz) do |exam|
      exam.student = current_user
      exam.quiz = @quiz
      exam.build_questions_with_answers!
      exam.save!
    end
  end

  def show
    @exam = Exam.find(params[:id])
    @quiz = @exam.quiz
  end
end
