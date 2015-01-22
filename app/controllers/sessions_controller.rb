class SessionsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]
    user = User.find_by_provider_and_uid(auth) ||
           User.create_with_omniauth(auth)
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
