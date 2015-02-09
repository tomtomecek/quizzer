class Admin::SessionsController < ApplicationController
  before_action :require_admin, only: [:destroy]

  def new
    redirect_to admin_courses_url if logged_in_admin?
  end

  def create
    admin = Admin.find_by(email: params[:email])

    if admin && admin.authenticate(params[:password])
      session[:admin_id] = admin.id
      remember admin if remember_me_checked?
      flash[:success] = "Login was successful!"
      redirect_to admin_courses_url
    else
      flash.now[:danger] = "Incorrect email or password. Please try again."
      render :new
    end
  end

  def destroy
    current_admin.forget!
    cookies.delete(:admin_id)
    cookies.delete(:remember_token)
    session.delete(:admin_id)

    flash[:success] = "Logged out successfully."
    redirect_to root_url
  end

private

  def remember(admin)
    admin.remember
    cookies.permanent.signed[:admin_id] = admin.id
    cookies.permanent[:remember_token] = admin.remember_token
  end

  def remember_me_checked?
    params[:remember_me] == '1'
  end
end
