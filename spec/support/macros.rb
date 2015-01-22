def to_ids(*args)
  args.map { |a| a.id.to_s }
end

def set_current_user(user = nil)
  user = user || Fabricate(:user)
  session[:user_id] = user.id
end