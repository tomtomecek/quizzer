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
    let!(:quiz) { Fabricate(:quiz, published: true, course: ruby) }
    it_behaves_like "require sign in" do
      let(:action) { xhr :post, :create, enrollment: { course_id: 1 } }
    end

    context "Free enrollment" do
      context "with valid data" do
        before do
          expect(StripeWrapper::Charge).to_not receive(:create)
          xhr :post, :create, enrollment: {
            course_id: ruby.id,
            honor_code: "1",
            paid: "0"
          }
        end

        it "redirects to course show" do
          ajax_redirect = "window.location.replace('#{course_url(ruby)}');"
          expect(response.body).to include(ajax_redirect)
        end

        it { is_expected.to set_flash[:success] }

        it "creates an enrollment" do
          expect(Enrollment.count).to eq 1
        end

        it "creates paid enrollment" do
          expect(Enrollment.first).to_not be_paid
        end

        it "creates an enrollment under course" do
          expect(ruby.reload.enrollments).to include Enrollment.first
        end

        it "creates an enrollment under student" do
          expect(current_user.enrollments).to include Enrollment.first
        end

        it "doesn't charge the card" do
          expect(StripeWrapper::Charge).to_not receive(:create)
          xhr :post, :create, enrollment: {
            course_id: ruby.id,
            honor_code: "1",
            paid: "0"
          }
        end

        it "creates permission" do
          expect(Permission.count).to eq 1
        end

        it "creates permission under quiz" do
          expect(quiz.permissions).to include Permission.first
        end
      end

      context "with invalid inputs" do
        before do
          xhr :post, :create, enrollment: {
            course_id: ruby.id,
            honor_code: "0",
            paid: "0"
          }
        end

        it { is_expected.to render_template :new }
        it "does not create an enrollment" do
          expect(Enrollment.count).to eq 0
        end

        it "sets the @enrollment" do
          expect(assigns(:enrollment)).to be_new_record
          expect(assigns(:enrollment)).to be_instance_of Enrollment
        end

        it "doesn't charge the card" do
          expect(StripeWrapper::Charge).to_not receive(:create)
          xhr :post, :create, enrollment: {
            course_id: ruby.id,
            honor_code: "0",
            paid: "0"
          }
        end

        it "does not create a permission" do
          expect(Permission.count).to eq 0
        end
      end
    end

    context "Paid enrollment" do
      context "with valid enrollment and valid card" do
        let(:charge) { double('charge', successful?: true) }
        let(:mail) { ActionMailer::Base.deliveries.last }
        before do
          expect(StripeWrapper::Charge).to receive(:create).and_return(charge)
          xhr :post, :create, stripeToken: "123123", enrollment: {
            course_id: ruby.id,
            honor_code: "1",
            paid: "1"
          }
        end
        after { ActionMailer::Base.deliveries.clear }

        it "redirects to course show" do
          ajax_redirect = "window.location.replace('#{course_url(ruby)}');"
          expect(response.body).to include(ajax_redirect)
        end

        it { is_expected.to set_flash[:success] }
        it "creates enrollment" do
          expect(Enrollment.count).to eq 1
        end

        it "creates paid enrollment" do
          expect(Enrollment.first).to be_paid
        end

        it "sends out an email" do
          expect(ActionMailer::Base.deliveries).to_not be_empty
        end

        it "sends out email to student" do
          expect(mail.to).to eq [current_user.email]
        end

        it "sends out email with correct" do
          email = mail.body.encoded
          expect(email).to include current_user.username
          expect(email).to include "We confirm the payment - $19.99"
          expect(email).to include ruby.title
          expect(email).to include "Certification will be sent only upon successful completion of exams."
        end

        it "creates permission" do
          expect(Permission.count).to eq 1
        end

        it "creates permission under quiz" do
          expect(quiz.permissions).to include Permission.first
        end
      end

      context "with valid enrollment and declined card" do
        let(:charge) do
          double('charge',
                 successful?: false,
                 error_message: "Your card was declined")
        end
        before do
          expect(StripeWrapper::Charge).to receive(:create).and_return(charge)
          xhr :post, :create, stripeToken: "345345", enrollment: {
            course_id: ruby.id,
            honor_code: "1",
            paid: "1"
          }
        end

        it { is_expected.to render_template :new }

        it { is_expected.to set_flash.now[:danger] }

        it "does not create enrollment" do
          expect(Enrollment.count).to eq 0
        end

        it "does not send out an email" do
          expect(ActionMailer::Base.deliveries).to be_empty
        end

        it "does not create a permission" do
          expect(Permission.count).to eq 0
        end
      end

      context "with invalid enrollment" do
        it "does not create charge" do
          expect(StripeWrapper::Charge).to_not receive(:create)
          xhr :post, :create, stripeToken: "345345", enrollment: {
            course_id: ruby.id,
            honor_code: "0",
            paid: "1"
          }
        end

        it "renders the :new tempalte" do
          xhr :post, :create, stripeToken: "345345", enrollment: {
            course_id: ruby.id,
            honor_code: "0",
            paid: "1"
          }
          expect(response).to render_template :new
        end
      end
    end

    context "valid enrollment - invalid payment params" do
      it "renders the :new template for paid param hack" do
        expect(StripeWrapper::Charge).to_not receive(:create)
        xhr :post, :create, stripeToken: "123123", enrollment: {
          course_id: ruby.id,
          honor_code: "1",
          paid: "no match"
        }
        expect(response).to render_template :new
      end

      it "renders the :new template for stripe token missing" do
        expect(StripeWrapper::Charge).to_not receive(:create)
        xhr :post, :create, enrollment: {
          course_id: ruby.id,
          honor_code: "1",
          paid: "1"
        }
        expect(response).to render_template :new
      end

      it "sets the flash danger" do
        expect(StripeWrapper::Charge).to_not receive(:create)
        xhr :post, :create, enrollment: {
          course_id: ruby.id,
          honor_code: "1",
          paid: "1"
        }
        expect(flash[:danger]).to be_present
      end
    end
  end
end
