module ApplicationHelper
  def github_sign_in_path
    Rails.env.production? ? "/auth/github" : "/auth/developer"
  end
end
