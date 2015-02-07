require 'spec_helper'

describe PasswordResetsController do
  describe "GET new" do
    before { sign_in_admin }
    it { is_expected.to redirec_to admin_courses_url }
    it { is_expected.to set_the_flash[:info] }
  end


  describe "POST create"
end
