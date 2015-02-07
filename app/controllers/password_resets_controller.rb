class PasswordResetsController < ApplicationController
  before_action :require_sign_out, only: [:new, :create]

  def new
  end

  def create
    admin = Admin.find_by(email: params[:email])
    if admin
      admin.generate_password_reset_token
      AdminMailer.send_reset_token(admin).deliver
    end
    redirect_to confirm_password_reset_url
  end

private

  def require_sign_out
    if current_admin || current_user
      flash[:info] = "This is not available."
      redirect_to root_url if current_user
      redirect_to admin_courses_url if current_admin
    end
  end
end
