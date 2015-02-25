class AdminsController < AdminController
  def index
  end

  def new
    @admin = Admin.new
  end

  def create
    @admin = Admin.new(admin_params)
  end

private

  def admin_params
    params.require(:admin).permit(:email, :role)
  end
end
