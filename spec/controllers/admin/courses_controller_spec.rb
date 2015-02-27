require "spec_helper"

describe Admin::CoursesController do
  before { set_current_admin }

  describe "GET new" do
    let(:kevin) { Fabricate(:instructor, activated: true) }
    it_behaves_like "require admin sign in" do
      let(:action) { get :new }
    end

    it_behaves_like "require instructor sign in" do
      let(:action) { get :new }
    end

    it "sets the @course" do
      set_current_admin(kevin)
      get :new
      expect(assigns(:course)).to be_new_record
      expect(assigns(:course)).to be_instance_of Course
    end
  end

  describe "GET index" do
    it_behaves_like "require admin sign in" do
      let(:action) { get :index }
    end

    it "sets the @courses" do
      course1 = Fabricate(:course)
      course2 = Fabricate(:course)
      get :index
      expect(assigns(:courses)).to match_array [course1, course2]
    end
  end

  describe "GET show" do
    let(:course) { Fabricate(:course) }

    it_behaves_like "require admin sign in" do
      let(:action) { get :show, id: course.slug }
    end

    it "sets the @course" do
      get :show, id: course.slug
      expect(assigns(:course)).to eq course
    end
  end
end
