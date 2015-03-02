require "spec_helper"

describe CoursesController do
  describe "GET index" do
    it "sets the @courses" do
      ruby = Fabricate(:course, published: true, created_at: 2.hours.ago)
      rails = Fabricate(:course, published: true, created_at: Time.now)
      get :index
      expect(assigns(:courses)).to eq [ruby, rails]
    end
  end

  describe "GET show" do
    let(:course) { Fabricate(:course) }
    before { set_current_user }

    it_behaves_like "require sign in" do
      let(:action) { get :show, id: course.slug }
    end

    it_behaves_like "requires enrollment" do
      let(:action) { get :show, id: course.slug }
    end

    it "sets the @course" do
      set_enrollment(current_user, course)
      get :show, id: course.slug
      expect(assigns(:course)).to eq course
    end

    it "sets the @enrollment" do
      set_enrollment(current_user, course)
      get :show, id: course.slug
      expect(assigns(:enrollment).student).to eq current_user
    end
  end
end
