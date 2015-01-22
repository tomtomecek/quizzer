OmniAuth.config.test_mode = true
omniauth_hash = { 
  "provider" => "github",
  "uid" => "12345",
  "info" => {
    "name" => "Alice Wang",
    "email" => "alice@example.com",
    "nickname" => "alicewang",
    "image" => "https://avatars.githubusercontent.com/u/123456",
    "urls" => {
      "Github" => "https://github.com/alicewang"
    }
  }
}
OmniAuth.config.add_mock(:github, omniauth_hash)
