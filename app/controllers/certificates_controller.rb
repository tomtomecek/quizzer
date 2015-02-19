class CertificatesController < ApplicationController

  def show
    @certificate = Certificate.find_by(licence_number: params[:licence_number])
    respond_to do |format|
      format.html
      format.pdf do
        render pdf:    @certificate.file_name,
               layout: 'layouts/application.pdf.haml'
      end
    end
  end
end
