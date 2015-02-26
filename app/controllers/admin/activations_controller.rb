class Admin::ActivationsController < ApplicationController
  before_action :require_token

  def new; end

  def create
    if @admin.update(password: params[:password])
      @admin.update_columns(activated: true, activation_token: nil)
      session[:admin_id] = @admin.id
      flash[:success] = "Welcome to Tealeaf! You are new admin."
      redirect_to admin_courses_url
    else
      flash.now[:danger] = "Invalid Password.\
 It must have at least 6 characters."
      render :new
    end
  end

private

  def require_token
    @admin = Admin.find_by(activation_token: params[:activation_token])
    redirect_to admin_sign_in_url unless @admin.present?
  end
end
