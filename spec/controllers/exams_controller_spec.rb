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

    it_behaves_like "require sign in" do
      let(:action) { patch :update, id: 1, quiz_id: quiz.slug }
    end

    it "updates generated answers with student answers" do
      exam = Fabricate(:exam, quiz: quiz)
      gq = exam.generated_questions.first
      ga1 = gq.generated_answers[0]
      ga2 = gq.generated_answers[1]
      ga3 = gq.generated_answers[2]
      ga4 = gq.generated_answers[3]
      patch :update, id: exam.id, quiz_id: quiz.slug, exam: {
        generated_questions_attributes: [
          {
            id: gq.id,
            generated_answers_attributes: [
              { id: ga1.id, student_marked: "1" },
              { id: ga2.id, student_marked: "1" },
              { id: ga3.id, student_marked: "1" },
              { id: ga4.id, student_marked: "1" }
            ]
          }
        ]
      }
      expect(ga1.student_marked?).to be true
      expect(ga2.student_marked?).to be true
      expect(ga3.student_marked?).to be true
      expect(ga4.student_marked?).to be true
    end
  end
end
