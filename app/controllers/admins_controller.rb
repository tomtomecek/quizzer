class AdminsController < AdminController
  before_action :require_instructor, only: [:index, :new, :create]

  def index
  end

  def new
    @admin = Admin.new
  end

  def create
    @admin = Admin.new(admin_params)
    if @admin.save
      @admin.generate_activation_token!
      AdminMailer.delay.send_activation_link(@admin)
      redirect_to management_admins_path
    else
      render :new
    end
  end

private

  def admin_params
    params.require(:admin).permit(:email, :role)
  end

  def require_instructor
    unless current_admin.instructor?
      flash[:danger] = "You are not Instructor"
      redirect_to admin_courses_url
    end
  end
end
