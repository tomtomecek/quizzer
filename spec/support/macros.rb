def to_ids(*args)
  args.map { |a| a.id.to_s }
end

def set_current_user(user = nil)
  user = user || Fabricate(:user)
  session[:user_id] = user.id
end

def clear_current_user
  session[:user_id] = nil
end

def current_user
  User.find(session[:user_id])
end

def clear_current_admin
  session[:admin_id] = nil
end

def current_admin
  Admin.find(session[:admin_id])
end

def set_current_admin(admin = nil)
  admin = admin || Fabricate(:admin)
  session[:admin_id] = admin.id
end
