class PasswordResetsController < ApplicationController
  def create
    redirect_to confirm_password_reset_url
  end
end
