require 'spec_helper'

describe CertificatesController do

  describe "GET show" do
    let(:alice) { Fabricate(:user) }
    let(:cert) { Fabricate(:certificate, student: alice) }

    it "sets the @certificate" do
      get :show, licence_number: cert.licence_number
      expect(assigns(:certificate)).to eq cert
    end

    it "allows pdf download", :no_travis do
      get :show, licence_number: cert.licence_number, format: :pdf
      expect(response.headers['Content-Type']).to eq "application/pdf"
    end
  end
end
