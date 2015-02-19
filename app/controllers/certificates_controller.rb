class CertificatesController < ApplicationController
  before_action :require_user, only: [:create]
  before_action :require_enrollment, only: [:create]

  def create
    enrollment = Enrollment.find(params[:enrollment_id])
    if enrollment.paid?
      certificate = current_user.certificates.create(enrollment: enrollment)
      redirect_to certificate_url(certificate.licence_number)
    else
      flash[:danger] = "Free enrollments are not enligible for certificates."
      redirect_to root_url
    end
  end

  def show
    @certificate = Certificate.find_by(licence_number: params[:licence_number])

    respond_to do |format|
      format.html { render layout: 'layouts/application.pdf.haml' }
      format.pdf do
        render pdf:           'certificate_test',
               layout:        'layouts/application.pdf.haml',
               show_as_html:  params[:debug].present?,
               orientation:   'Landscape',
               page_size:     'Letter'
      end
    end
  end
end
