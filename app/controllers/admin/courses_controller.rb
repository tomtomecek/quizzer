class Admin::CoursesController < AdminController
  before_action :require_instructor, only: [:new, :create, :edit, :update, :publish]
  before_action :find_course, only: [:show, :edit, :update, :publish]

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
    @courses = Course.order(:created_at)
  end

  def show; end

  def edit; end

  def update
    if @course.update(course_params)
      flash[:success] = "Successfully updated the course #{@course.title}"
      redirect_to admin_courses_url
    else
      flash.now[:danger] = "These errors needs to be fixed:"
      render :edit
    end
  end

  def publish
    @course.update(published: true)
    flash[:success] = "Course has been successfully published."
    redirect_to root_url
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
             :price_dollars,
             :image_cover)
  end

  def find_course
    @course = Course.find_by(slug: params[:id])
  end

  def require_instructor
    unless current_admin.instructor?
      flash[:danger] = "You are not Instructor"
      redirect_to admin_courses_url
    end
  end
end
