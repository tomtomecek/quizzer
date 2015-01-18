require 'spec_helper'

describe ExamsController do
  describe "GET new" do
    it "sets the @quiz" do
      quiz = Fabricate(:quiz)
      get :new, quiz_id: quiz.slug
      expect(assigns(:quiz)).to eq(quiz)
    end

    it "sets the @exam" do
      quiz = Fabricate(:quiz)
      get :new, quiz_id: quiz.slug
      expect(assigns(:exam)).to be_new_record
      expect(assigns(:exam)).to be_kind_of(Exam)
    end
  end

  describe "POST create" do
    let(:quiz)     { Fabricate(:quiz) }
    let(:question) { Fabricate(:question, quiz: quiz) }
    let(:answer1)  { Fabricate(:answer, question: question) }
    let(:answer2)  { Fabricate(:answer, question: question) }
    let(:answer3)  { Fabricate(:answer, question: question) }
    let(:exam)     { Exam.first }
    before do
      post :create, 
        quiz_id: quiz.slug, 
        student_answer_ids: [answer1.id], 
        generated_answer_ids: [answer1.id, answer2.id, answer3.id]
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

    it "creates an exam with student_answer_ids" do
      student_answer_ids = [answer1].map(&:id).map(&:to_s)
      expect(exam.student_answer_ids).to match_array student_answer_ids
    end

    it "creates an exam with generated_answer_ids" do
      generated_answer_ids = [answer1, answer2, answer3].map(&:id).map(&:to_s)
      expect(exam.generated_answer_ids).to match_array generated_answer_ids
    end
  end

  describe "GET show" do
    it "sets the @quiz" do
      quiz = Fabricate(:quiz)
      exam = Fabricate(:exam, quiz: quiz)
      get :show, quiz_id: quiz.slug, id: exam.id
      expect(assigns(:quiz)).to eq(quiz)
    end

    it "sets the @exam" do
      quiz = Fabricate(:quiz)
      exam = Fabricate(:exam, quiz: quiz)
      get :show, quiz_id: quiz.slug, id: exam.id
      expect(assigns(:exam)).to eq(exam)
    end
  end

end