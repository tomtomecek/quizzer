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

  describe "POST create" do
    let(:kevin) { Fabricate(:instructor, activated: true) }
    it_behaves_like "require admin sign in" do
      let(:action) { post :create, course: Fabricate.attributes_for(:course) }
    end

    it_behaves_like "require instructor sign in" do
      let(:action) { post :create, course: Fabricate.attributes_for(:course) }
    end

    context "with valid data" do
      before do
        set_current_admin(kevin)
        post :create, course: Fabricate.attributes_for(:course, instructor: kevin)
      end
      it { is_expected.to redirect_to admin_courses_url }
      it { is_expected.to set_flash[:success] }
      it "creates a course" do
        expect(Course.count).to eq 1
      end

      it "creats a course under admin" do
        expect(kevin.courses.count).to eq 1
      end
    end

    context "with invalid data" do
      before do
        set_current_admin(kevin)
        post :create,
             course: {
               instructor_id: kevin.id,
               title: "",
               description: "",
               min_quiz_count: "",
               price_dollars: 0
             }
      end

      it { is_expected.to render_template :new }
      it { is_expected.to set_flash.now[:danger] }
      it "sets the @course" do
        expect(assigns(:course)).to be_new_record
        expect(assigns(:course)).to be_instance_of Course
      end

      it "does not create a course" do
        expect(Course.count).to eq 0
      end
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

  describe "GET edit" do
    let(:kevin) { Fabricate(:instructor, activated: true) }
    let(:ruby) { Fabricate(:course) }
    it_behaves_like "require admin sign in" do
      let(:action) { get :edit, id: ruby.slug }
    end

    it_behaves_like "require instructor sign in" do
      let(:action) { get :edit, id: ruby.slug }
    end

    it "sets the @course" do
      set_current_admin(kevin)
      get :edit, id: ruby.slug
      expect(assigns(:course)).to eq ruby
    end
  end
end
