require 'spec_helper'

describe CertificatesController do

  describe "POST create" do
    let(:ruby) { Fabricate(:course) }
    let(:enrollment) { Fabricate(:enrollment) }
    before do
      set_current_user
      set_enrollment(current_user, ruby)
    end

    it_behaves_like "require sign in" do
      let(:action) { post :create, enrollment_id: 1 }
    end

    it_behaves_like "requires enrollment" do
      let(:action) { post :create, enrollment_id: enrollment.id }
    end

    context "with valid data" do
      let(:paid) { Fabricate(:enrollment, paid: true, student: current_user) }
      let(:cert) { Certificate.first }

      before { post :create, enrollment_id: paid.id }

      it { is_expected.to redirect_to certificate_url(cert.licence_number) }

      it "creates certificate" do
        expect(Certificate.count).to eq 1
      end

      it "creates certificate under enrollment" do
        expect(paid.certificate).to eq cert
      end

      it "creates certificate under student" do
        expect(current_user.certificates.first).to eq cert
      end
    end

    context "with invalid data" do
      let(:free) { Fabricate(:enrollment, paid: false, student: current_user) }
      before { post :create, enrollment_id: free.id }

      it { is_expected.to redirect_to :root }
      it { is_expected.to set_the_flash[:danger] }
      it "does not create certificate" do
        expect(Certificate.count).to eq 0
      end
    end
  end

  describe "GET show" do
    let(:alice) { Fabricate(:user) }
    let(:cert) { Fabricate(:certificate, student: alice) }

    it "sets the @certificate" do
      get :show, licence_number: cert.licence_number
      expect(assigns(:certificate)).to eq cert
    end

    it "allows pdf download" do
      get :show, licence_number: cert.licence_number, format: :pdf
      expect(response.headers['Content-Type']).to eq "application/pdf"
    end
  end
end
