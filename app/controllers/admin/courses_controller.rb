class Admin::CoursesController < AdminController
  before_action :require_instructor, only: [:new, :create]

  def new
    @course = Course.new
  end

  def create
    @course = Course.new(course_params)
    if @course.save
      flash[:success] = "Unpublished course has been created."
      redirect_to admin_courses_url
    else
      flash.now[:danger] = "These errors need to be fixed:"
      render :new
    end
  end

  def index
    @courses = Course.all
  end

  def show
    @course = Course.find_by(slug: params[:id])
  end

private

  def course_params
    params.
      require(:course).
      permit(:title,
             :description,
             :instructor_id,
             :min_quiz_count,
             :duration,
             :image_path)
  end

  def require_instructor
    unless current_admin.instructor?
      flash[:danger] = "You are not Instructor"
      redirect_to admin_courses_url
    end
  end
end
