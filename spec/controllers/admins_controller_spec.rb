require 'spec_helper'

describe AdminsController do

  describe "GET index" do
    it_behaves_like "require admin sign in" do
      let(:action) { get :index }
    end

    it_behaves_like "require instructor sign in" do
      let(:action) { get :index }
    end
  end

  describe "GET new" do
    it_behaves_like "require admin sign in" do
      let(:action) { get :new }
    end

    it_behaves_like "require instructor sign in" do
      let(:action) { get :new }
    end

    it "sets the @admin" do
      kevin = Fabricate(:instructor)
      set_current_admin(kevin)
      get :new
      expect(assigns(:admin)).to be_new_record
      expect(assigns(:admin)).to be_instance_of Admin
    end
  end

  describe "POST create" do
    it_behaves_like "require admin sign in" do
      let(:action) { post :create, admin: Fabricate.attributes_for(:admin) }
    end

    it_behaves_like "require instructor sign in" do
      let(:action) { post :create, admin: Fabricate.attributes_for(:admin) }
    end

    context "with valid data" do
      let(:kevin) { Fabricate(:instructor) }
      let(:mail) { ActionMailer::Base.deliveries.last }
      let(:admin) { Admin.last }
      before { set_current_admin(kevin) }

      it "redirects to admins management" do
        post :create, admin: Fabricate.attributes_for(:admin)
        expect(response).to redirect_to management_admins_path
      end

      it "creates a new admin" do
        expect {
          post :create, admin: Fabricate.attributes_for(:admin)
        }.to change { Admin.count }.by(1)
      end

      it "creates a new admin with activation token" do
        post :create, admin: Fabricate.attributes_for(:admin)
        expect(admin.activation_token).to_not be nil
      end

      it "does not activate the admin" do
        post :create, admin: Fabricate.attributes_for(:admin)
        expect(admin).to_not be_activated
      end

      it "sends out an email" do
        post :create, admin: Fabricate.attributes_for(:admin)
        expect(ActionMailer::Base.deliveries).not_to be_empty
      end

      it "sends out email to admins email" do
        post :create, admin: Fabricate.attributes_for(:admin)
        expect(mail.to).to eq [admin.email]
      end

      it "sends out verification back-link" do
        post :create, admin: Fabricate.attributes_for(:admin)
        expect(mail.body.encoded).to include activate_admin_path(admin.activation_token)
      end
    end

    context "with invalid data" do
      before do
        kevin = Fabricate(:instructor)
        set_current_admin(kevin)
      end

      it "renders the :new" do
        post :create, admin: { email: "no match", role: "whatever" }
        expect(response).to render_template :new
      end

      it "does not create an admin" do
        expect {
          post :create, admin: { email: "no match", role: "whatever" }
        }.to_not change { Admin.count }
      end

      it "sets the @admin" do
        post :create, admin: { email: "no match", role: "whatever" }
        expect(assigns(:admin)).to be_new_record
        expect(assigns(:admin)).to be_instance_of Admin
      end

      it "sets the flash danger" do
        expect(flash.now[:danger]).to be_present
      end

      it "does not set the email" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
end
