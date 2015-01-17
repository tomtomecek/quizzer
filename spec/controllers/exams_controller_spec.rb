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
    context "with valid data" do
      it "redirects to :show @exam" do
        quiz = Fabricate(:quiz)
        question = Fabricate(:question, quiz: quiz)
        a1 = Fabricate(:answer, question: question)
        a2 = Fabricate(:answer, question: question)
        a3 = Fabricate(:answer, question: question)
        post :create, quiz_id: quiz.slug, student_answer_ids: [a1.id, a2.id, a3.id]
        expect(response).to redirect_to [quiz, Exam.first]
      end

      it "creates an exam" do
        quiz = Fabricate(:quiz)
        question = Fabricate(:question, quiz: quiz)
        a1 = Fabricate(:answer, question: question)
        a2 = Fabricate(:answer, question: question)
        a3 = Fabricate(:answer, question: question)
        post :create, quiz_id: quiz.slug, student_answer_ids: [a1.id, a2.id, a3.id]
        expect(Exam.count).to eq(1)
      end

      it "creates an exam under quiz" do
        quiz = Fabricate(:quiz)
        question = Fabricate(:question, quiz: quiz)
        a1 = Fabricate(:answer, question: question)
        a2 = Fabricate(:answer, question: question)
        a3 = Fabricate(:answer, question: question)
        post :create, quiz_id: quiz.slug, student_answer_ids: [a1.id, a2.id, a3.id]
        expect(quiz.exams.first).to eq(Exam.first)
      end

      it "creates student answers" do
        quiz = Fabricate(:quiz)
        question = Fabricate(:question, quiz: quiz)
        a1 = Fabricate(:answer, question: question)
        a2 = Fabricate(:answer, question: question)
        a3 = Fabricate(:answer, question: question)
        post :create, quiz_id: quiz.slug, student_answer_ids: [a1.id, a2.id, a3.id]
        expect(StudentAnswers.count).to eq(3)
      end

    end

    context "with invalid data" do
      it "does not create an exam"
    end
  end
end