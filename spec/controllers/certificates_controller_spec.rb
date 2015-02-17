require 'spec_helper'

describe CertificatesController do
  let(:ruby) { Fabricate(:course) }
  before do
    set_current_user
    set_enrollment(current_user, ruby)
  end

  describe "POST create" do
    let(:enrollment) { Fabricate(:enrollment) }
    it_behaves_like "require sign in" do
      let(:action) { post :create, enrollment_id: 1 }
    end

    it_behaves_like "requires enrollment" do
      let(:action) { post :create, enrollment_id: enrollment.id }
    end

    context "with valid data" do
      let(:paid) { Fabricate(:enrollment, paid: true, student: current_user) }

      before { post :create, enrollment_id: paid.id }

      it { is_expected.to redirect_to Certificate.first }

      it "creates certificate" do
        expect(Certificate.count).to eq 1
      end

      it "creates certificate under enrollment" do
        expect(paid.certificate).to eq Certificate.first
      end

      it "creates certificate under student" do
        expect(current_user.certificates.first).to eq Certificate.first
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
    let(:cert) { Fabricate(:certificate, student: current_user) }
  end
end
