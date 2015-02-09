module AuthenticationMacros
  def sign_in(user = nil, options = {})
    provider = options[:provider] || "github"
    uid      = options[:uid]      || "12345"
    username = options[:username] || "alicewang"
    user || Fabricate(:user,
                      provider: provider,
                      uid: uid,
                      username: username)
    visit "/auth/github"
  end

  def sign_in_admin(admin = nil)
    admin = admin || Fabricate(:admin,
                               email: "admin@tealeaf.com",
                               password: "secret")
    visit admin_sign_in_path
    fill_in "Email", with: "admin@tealeaf.com"
    fill_in "Password", with: "secret"
    click_on "Sign in"
  end

  def set_current_user(user = nil)
    user = user || Fabricate(:user)
    session[:user_id] = user.id
  end

  def clear_current_user
    session.delete(:user_id)
  end

  def current_user
    User.find(session[:user_id])
  end

  def clear_current_admin
    session.delete(:admin_id)
    cookies.delete(:admin_id)
    cookies.delete(:remember_token)
  end

  def current_admin
    Admin.find(session[:admin_id])
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
end
