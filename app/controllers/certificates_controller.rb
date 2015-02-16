class CertificatesController < ApplicationController
  before_action :require_user
  before_action :require_enrollment, only: [:create]

  def create
    enrollment = Enrollment.find(params[:enrollment_id])
    if enrollment.paid?
      certificate = current_user.certificates.create(enrollment: enrollment)
      redirect_to certificate
    else
      flash[:danger] = "Free enrollments are not enligible for certificates."
      redirect_to root_url
    end
  end

  def show
  end
end
