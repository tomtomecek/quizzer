class User < ActiveRecord::Base
  def self.create_with_omniauth(auth)
    create do |user|
      user.provider = auth[:provider]
      user.uid      = auth[:uid]
      user.username = auth[:info][:nickname]
      user.email    = auth[:info][:email]
      user.name     = auth[:info][:name]
      user.avatar_url = auth[:info][:image]
      user.github_account_url = auth[:info][:urls][:Github]
    end
  end

  def self.find_by_provider_and_uid(auth)
    find_by(provider: auth[:provider], uid: auth[:uid])
  end
end
