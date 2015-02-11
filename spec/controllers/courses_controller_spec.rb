require "spec_helper"

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
    let(:course) { Fabricate(:course) }
    before { set_current_user }

    it_behaves_like "require sign in" do
      let(:action) { get :show, id: course.slug }
    end

    it "sets the @course" do
      get :show, id: course.slug
      expect(assigns(:course)).to eq course
    end

    it "sets the @enrollment" do
      Fabricate(:enrollment, student: current_user, course: course)
      get :show, id: course.slug
      expect(assigns(:enrollment).student).to eq current_user
    end
  end
end
