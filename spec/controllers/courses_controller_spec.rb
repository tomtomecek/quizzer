require 'spec_helper'

describe CoursesController do
  describe "GET index" do
    it "sets the @courses" do
      course1 = Fabricate(:course)
      course2 = Fabricate(:course)
      get :index
      expect(assigns(:courses)).to match_array [course1, course2]
    end
  end

  describe "GET show" do
    it "sets the @course" do
      course = Fabricate(:course)
      get :show, id: course.slug
      expect(assigns(:course)).to eq course
    end
  end
end