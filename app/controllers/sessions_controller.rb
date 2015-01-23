class SessionsController < ApplicationController
  before_action :require_user, only: [:destroy]

  def create    
    user = User.from_omniauth(request.env["omniauth.auth"])
    session[:user_id] = user.id
    flash[:success] = "Signed in!"
    redirect_to root_url
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "Signed out!"
    redirect_to root_url
  end
end
