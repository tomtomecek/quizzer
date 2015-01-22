class Admin::SessionsController < ApplicationController
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
end
