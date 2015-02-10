class Admin::ExamsController < AdminController
  def index
    @exams = Exam.all
  end

  def show
    @exam = Exam.find(params[:id])
    render 'exams/show'
  end
end
