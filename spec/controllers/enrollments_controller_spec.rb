require 'spec_helper'

describe EnrollmentsController do
  before { set_current_user }

  describe "XHR GET new" do
    let!(:ruby) { Fabricate(:course) }
    it_behaves_like "require sign in" do
      let(:action) { xhr :get, :new, course_id: ruby.id }
    end

    it "sets the @enrollment" do
      xhr :get, :new, course_id: ruby.id
      expect(assigns(:enrollment)).to be_new_record
      expect(assigns(:enrollment)).to be_instance_of Enrollment
    end

    it "sets the @enrollment under course" do
      xhr :get, :new, course_id: ruby.id
      expect(assigns(:enrollment).course_id).to eq ruby.id
    end
  end

  describe "XHR POST create" do
    let(:ruby) { Fabricate(:course) }
    it_behaves_like "require sign in" do
      let(:action) { xhr :post, :create, enrollment: { course_id: 1 } }
    end

    context "with valid inputs" do
      before do
        xhr :post,
            :create,
            enrollment: {
              course_id: ruby.id,
              honor_code: "1",
              paid: "0"
            }
      end

      it "redirects to course show" do
        ajax_redirect = "window.location.replace('#{course_url(ruby)}');"
        expect(response.body).to include(ajax_redirect)
      end

      it "sets the flash success" do
        expect(flash.keep[:success]).to be_present
      end

      it "creates an enrollment" do
        expect(Enrollment.count).to eq 1
      end

      it "creates an enrollment under course" do
        expect(ruby.reload.enrollments).to include Enrollment.first
      end

      it "creates an enrollment under student" do
        expect(current_user.enrollments).to include Enrollment.first
      end
    end

    context "with invalid inputs" do
      before do
        xhr :post,
            :create,
            enrollment: {
              course_id: ruby.id,
              honor_code: "0",
              paid: "0"
            }
      end

      it "renders the :new template" do
        expect(response).to render_template :new
      end

      it "does not create an enrollment" do
        expect(Enrollment.count).to eq 0
      end

      it "sets the @enrollment" do
        expect(assigns(:enrollment)).to be_new_record
        expect(assigns(:enrollment)).to be_instance_of Enrollment
      end

      it "sets the errors" do
        expect(assigns(:enrollment).errors.any?).to be true
      end
    end
  end
end
