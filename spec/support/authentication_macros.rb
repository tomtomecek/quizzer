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
end
