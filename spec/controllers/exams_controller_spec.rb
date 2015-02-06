require "spec_helper"

describe ExamsController do
  before { set_current_user }

  describe "GET new" do
    let(:quiz) { Fabricate(:quiz) }

    it_behaves_like "require sign in" do
      let(:action) { get :new, quiz_id: quiz.slug }
    end

    it "sets the @quiz" do
      get :new, quiz_id: quiz.slug
      expect(assigns(:quiz)).to eq(quiz)
    end

    it "sets the @exam" do
      get :new, quiz_id: quiz.slug
      expect(assigns(:exam)).to be_new_record
      expect(assigns(:exam)).to be_kind_of(Exam)
    end
  end

  describe "POST create" do
    let(:quiz)     { Fabricate(:quiz) }
    let(:question) { Fabricate.build(:question, quiz: quiz) }
    let(:answer1)  { Fabricate(:answer, question: question) }
    let(:answer2)  { Fabricate(:answer, question: question) }
    let(:answer3)  { Fabricate(:answer, question: question) }
    let(:exam)     { Exam.first }

    context "when authenticated" do
      before do
        post :create,
             quiz_id: quiz.slug,
             student_answer_ids: to_ids(answer1),
             generated_answer_ids: to_ids(answer1, answer2, answer3)
      end

      it "redirects to :show @exam" do
        expect(response).to redirect_to [quiz, exam]
      end

      it "creates an exam" do
        expect(Exam.count).to eq(1)
      end

      it "creates an exam under quiz" do
        expect(quiz.exams.first).to eq(exam)
      end

      it "creates an exam under the student" do
        expect(Exam.first.student).to eq current_user
      end

      it "creates an exam with student_answer_ids" do
        student_answer_ids = to_ids(answer1)
        expect(exam.student_answer_ids).to match_array student_answer_ids
      end

      it "creates an exam with generated_answer_ids" do
        generated_answer_ids = to_ids(answer1, answer2, answer3)
        expect(exam.generated_answer_ids).to match_array generated_answer_ids
      end
    end

    it_behaves_like "require sign in" do
      let(:action) { post :create, quiz_id: quiz.slug }
    end
  end

  describe "GET show" do
    let(:quiz) { Fabricate(:quiz) }
    let(:exam) { Fabricate(:exam, quiz: quiz) }

    it_behaves_like "require sign in" do
      let(:action) { get :show, quiz_id: quiz.slug, id: exam.id }
    end

    it "sets the @quiz" do
      get :show, quiz_id: quiz.slug, id: exam.id
      expect(assigns(:quiz)).to eq(quiz)
    end

    it "sets the @exam" do
      get :show, quiz_id: quiz.slug, id: exam.id
      expect(assigns(:exam)).to eq(exam)
    end
  end
end
