class Admin::CoursesController < AdminController
  before_action :require_instructor, only: [:new]

  def new
    @course = Course.new
  end

  def index
    @courses = Course.all
  end

  def show
    @course = Course.find_by(slug: params[:id])
  end

private

  def require_instructor
    unless current_admin.instructor?
      flash[:danger] = "You are not Instructor"
      redirect_to admin_courses_url
    end
  end
end
