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

  def update
    @quiz = Quiz.find_by(slug: params[:quiz_id])
    @exam = current_user.exams.find(params[:id])
    student_answers = @exam.generated_answers.
                        where(id: params[:student_answer_ids])
    if answers_valid?(student_answers)
      student_answers.each { |a| a.update_column(:student_marked, true) }
      flash[:success] = "xxx"
      redirect_to [@quiz, @exam]
    else
      flash[:danger] = "Failed"
      render :new
    end
  end

private

  def answers_valid?(student_answers)
    student_answers.count == params[:student_answer_ids].count
  end
end
