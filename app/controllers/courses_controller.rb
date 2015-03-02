class CoursesController < ApplicationController
  before_action :require_user, only: [:show]
  before_action :require_enrollment, only: [:show]

  def index
    @courses = Course.published
  end

  def show
    @course = Course.find_by(slug: params[:id])
    @enrollment = current_user.enrollments.find_by(course: @course)
  end
end
