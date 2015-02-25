require 'spec_helper'

describe AdminsController do

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

    context "with valid data" do
      it "redirects to admins index" do

      end
    end

    context "with invalid data" do

    end
  end
end
