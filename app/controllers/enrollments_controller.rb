class EnrollmentsController < ApplicationController
  before_action :require_user

  def new
    course = Course.find(params[:course_id])
    @enrollment = course.enrollments.build
  end

  def create
    course = Course.find(params[:enrollment][:course_id])
    @enrollment = current_user.enrollments.build(enrollment_params)

    if @enrollment.save
      flash.keep[:success] = "You have now enrolled course #{course.title}"
      render js: "window.location.replace('#{course_url(course)}');"
    else
      render :new
    end
  end

private

  def enrollment_params
    params.require(:enrollment).permit(:course_id, :paid, :honor_code)
  end
end
