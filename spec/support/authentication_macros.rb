module AuthenticationMacros
  def sign_in
    visit '/auth/github'
  end

  def sign_in_admin(admin = nil)
    page.set_rack_session(user_id: nil)
    admin ||= Fabricate(:admin,
                        email: "admin@tealeaf.com",
                        password: "secret")
    visit admin_sign_in_path
    expect(page).to have_content "Email"
    fill_in "Email", with: admin.email
    fill_in "Password", with: admin.password
    click_on "Sign in"
  end

  def set_current_user(user = nil)
    user ||= Fabricate(:user)
    session[:user_id] = user.id
  end

  def clear_current_user
    session.delete(:user_id)
  end

  def current_user
    @current_user ||= User.find(session[:user_id])
  end

  def clear_current_admin
    session.delete(:admin_id)
    cookies.delete(:admin_id)
    cookies.delete(:remember_token)
  end

  def current_admin
    @current_admin ||= Admin.find(session[:admin_id])
  end

  def set_current_admin(admin = nil, options = {})
    admin ||= Fabricate(:admin)
    if admin && options[:remember_me]
      admin.remember
      cookies.permanent.signed[:admin_id] = admin.id
      cookies.permanent[:remember_token] = admin.remember_token
    end
    session[:admin_id] = admin.id
  end

  def set_enrollment(user, course)
    Fabricate(:enrollment, student: user, course: course)
  end

  def clear_enrollments
    Enrollment.destroy_all
  end

  def set_permission(user, quiz)
    Fabricate(:permission, student: user, quiz: quiz)
  end

  def clear_permissions
    Permission.destroy_all
  end
end
