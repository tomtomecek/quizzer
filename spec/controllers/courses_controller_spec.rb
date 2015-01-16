require 'spec_helper'

describe CoursesController do
  describe "GET index" do
    it "sets @courses ivar" do
      course1 = Fabricate(:course)
      course2 = Fabricate(:course)
      get :index
      expect(assigns(:courses)).to match_array [course1, course2]
    end
  end
end