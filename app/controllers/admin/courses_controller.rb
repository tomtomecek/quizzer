class Admin::CoursesController < AdminController
  def index
    @courses = Course.all
  end

  def show
    @course = Course.find_by(slug: params[:id])
  end
end
