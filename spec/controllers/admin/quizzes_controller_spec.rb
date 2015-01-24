require "spec_helper"

describe Admin::QuizzesController do
  before { set_current_admin }

  describe "GET new" do
    it_behaves_like "require admin sign in" do
      let(:action) { get :new, course_id: 1 }
    end

    it "sets the @quiz" do
      course = Fabricate(:course)
      get :new, course_id: course.slug
      expect(assigns(:quiz)).to be_new_record
      expect(assigns(:quiz)).to be_instance_of Quiz
    end

    it "sets the quiz under course" do
      course = Fabricate(:course)
      get :new, course_id: course.slug
      expect(assigns(:quiz).course).to eq(course)
    end
  end

  describe "POST create" do
    it_behaves_like "require admin sign in" do
      let(:action) { post :create, course_id: 1 }
    end

    context "with valid inputs" do
      let(:course) { Fabricate(:course) }
      before do
        post :create, course_id: course.slug,
                      quiz: {
                        title: "Week 1 - Ruby",
                        description: "Checking knowledge...",
                        published: "0"
                      }
      end

      it { is_expected.to redirect_to [:admin, course] }
      it { is_expected.to set_the_flash[:success] }

      it "creates the quiz" do
        expect(Quiz.count).to eq 1
      end

      it "creates the quiz under course" do
        expect(course.quizzes).to include(Quiz.first)
      end
    end

    context "with invalid inputs" do
      let(:course) { Fabricate(:course) }
      before do
        post :create, course_id: course.slug,
                      quiz: {
                        title: "",
                        description: "",
                        published: "0"
                      }
      end

      it { is_expected.to render_template :new }
      it { is_expected.to set_the_flash.now[:danger] }

      it "sets the @quiz" do
        expect(assigns(:quiz)).to be_new_record
        expect(assigns(:quiz)).to be_instance_of Quiz
      end

      it "sets the errors on @quiz" do
        expect(assigns(:quiz).errors.any?).to be true
      end
    end
  end
end
