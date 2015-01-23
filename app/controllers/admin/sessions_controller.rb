class Admin::SessionsController < ApplicationController
  before_action :require_admin, only: [:destroy]

  def create
    admin = Admin.find_by(email: params[:email])

    if admin && admin.authenticate(params[:password])
      session[:admin_id] = admin.id
      flash[:success] = "Login was successful!"
      redirect_to admin_courses_url
    else
      flash.now[:danger] = "Incorrect email or password. Please try again."
      render :new
    end
  end

  def destroy
    session[:admin_id] = nil
    flash[:success] = "Logged out successfully."
    redirect_to root_url
  end
end
