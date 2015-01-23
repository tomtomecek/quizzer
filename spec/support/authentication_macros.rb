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
end
