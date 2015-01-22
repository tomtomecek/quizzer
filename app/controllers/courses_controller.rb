class CoursesController < ApplicationController
  before_action :require_user, only: [:show]

  def index
    @courses = Course.all
  end

  def show
    @course = Course.find_by(slug: params[:id])
  end
end