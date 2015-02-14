class PasswordResetsController < ApplicationController
  before_action :require_sign_out, only: [:new, :create, :edit, :update]

  def new
  end

  def create
    admin = Admin.find_by(email: params[:email])
    if admin
      admin.generate_password_reset_items
      AdminMailer.delay.send_reset_token(admin)
    end
    redirect_to confirm_password_reset_url
  end

  def edit
    @admin = Admin.find_by(password_reset_token: params[:token])
    if @admin && (@admin.password_reset_expires_at < Time.zone.now)
      redirect_to expired_token_url
    elsif @admin.nil?
      redirect_to root_url
    end
  end

  def update
    @admin = Admin.find_by(password_reset_token: params[:token])
    if @admin && @admin.update(admin_params)
      @admin.clear_token_and_expires_at!
      flash[:success] = "You can sign in with your new password now"
      redirect_to admin_sign_in_url
    elsif @admin.nil?
      flash[:danger] = "Please, retry reseting your password again."
      redirect_to root_url
    else
      render :edit
    end
  end

private

  def require_sign_out
    if current_admin || current_user
      flash[:info] = "This is not available."
      redirect_to root_url if current_user
      redirect_to admin_courses_url if current_admin
    end
  end

  def admin_params
    params.require(:admin).permit(:password)
  end
end
