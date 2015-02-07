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
      expect(assigns(:exam)).to eq Exam.first
    end

    context "exam exists" do
      it "does not create another exam" do
        Fabricate(:exam, quiz: quiz, student: current_user)
        expect { get :new, quiz_id: quiz.slug }.to_not change { Exam.count }
      end
    end

    context "exam does not exist" do
      it "creates new exam" do
        expect { get :new, quiz_id: quiz.slug }.to change { Exam.count }.by 1
      end

      it "generates questions" do
        get :new, quiz_id: quiz.slug
        expect(assigns(:exam).generated_questions).to_not be_empty
      end

      it "generates answers" do
        get :new, quiz_id: quiz.slug
        expect(assigns(:exam).generated_answers).to_not be_empty
      end
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

  describe "PATCH update" do
    let(:quiz) { Fabricate(:quiz) }
    let(:exam) { Fabricate(:exam, quiz: quiz, student: current_user) }
    let(:question) { Question.first }
    let(:a1) { Answer.first }
    let(:a2) { Answer.second }
    let(:a3) { Answer.third }
    let(:a4) { Answer.fourth }
    let(:gq) do
      Fabricate(:generated_question, exam: exam, question: question)
    end
    let(:ga1) do
      Fabricate(:generated_answer, answer: a1, generated_question: gq)
    end
    let(:ga2) do
      Fabricate(:generated_answer, answer: a2, generated_question: gq)
    end
    let(:ga3) do
      Fabricate(:generated_answer, answer: a3, generated_question: gq)
    end
    let(:ga4) do
      Fabricate(:generated_answer, answer: a4, generated_question: gq)
    end

    it_behaves_like "require sign in" do
      let(:action) { patch :update, id: 1, quiz_id: quiz.slug }
    end

    context "with valid data" do
      before do
        patch :update,
          id: exam.id,
          quiz_id: quiz.slug,
          student_answer_ids: to_ids(ga1, ga2, ga3, ga4)
      end

      it { is_expected.to redirect_to [quiz, exam] }
      it { is_expected.to set_the_flash[:success] }

      it "updates generated answers with student answers" do
        expect(ga1.reload.student_marked?).to be true
        expect(ga2.reload.student_marked?).to be true
        expect(ga3.reload.student_marked?).to be true
        expect(ga4.reload.student_marked?).to be true
      end
    end

    context "with invalid data" do
      let(:invalid_answer) { Fabricate(:answer) }

      before do
        patch :update,
          id: exam.id,
          quiz_id: quiz.slug,
          student_answer_ids: to_ids(invalid_answer)
      end

      it { is_expected.to render_template :new }
      it { is_expected.to set_the_flash.now[:danger] }

      it "sets the @quiz" do
        expect(assigns(:quiz)).to eq(quiz)
      end

      it "sets the @exam" do
        expect(assigns(:exam)).to eq(exam)
      end

      it "does not update generated answers with student answers" do
        expect(ga1.reload.student_marked).to be nil
        expect(ga2.reload.student_marked).to be nil
        expect(ga3.reload.student_marked).to be nil
        expect(ga4.reload.student_marked).to be nil
      end

    end
  end
end
