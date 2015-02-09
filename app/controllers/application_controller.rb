class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :logged_in?, :current_user, :logged_in_admin?, :current_admin

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_user
    unless logged_in? || logged_in_admin?
      flash[:danger] = "You must be logged in to do that"
      redirect_to root_url
    end
  end

  def current_admin
    if (admin_id = session[:admin_id])
      @current_admin ||= Admin.find(admin_id)
    elsif (admin_id = cookies.signed[:admin_id])
      admin = Admin.find(admin_id)
      if admin && admin.authenticated?(cookes[:remember_token])
        session[:admin_id] = admin.id
        @current_admin = admin
      end
    end
  end

  def logged_in_admin?
    !!current_admin
  end

  def require_admin
    unless logged_in_admin?
      flash[:danger] = "Restricted area!"
      redirect_to root_url
    end
  end
end
