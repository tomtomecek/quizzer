class Admin::SessionsController < ApplicationController

  def create
    redirect_to admin_courses_url
  end
end