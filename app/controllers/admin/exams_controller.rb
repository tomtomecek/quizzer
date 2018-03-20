class Admin::ExamsController < AdminController
  def index
    @exams = Exam.all
  end

  def show
    @exam = Exam.find(params[:id])
    @quiz = @exam.quiz
    render "exams/show"
  end
end
