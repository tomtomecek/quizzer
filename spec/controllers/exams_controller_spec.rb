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
      it "creates an exam" do
        quiz = Fabricate(:quiz)
        post :create, quiz_id: quiz.slug
        expect(Exam.count).to eq(1)
      end
      it "creates an exam under quiz"
    end
    context "with invalid data" do
      it "does not create an exam"
    end
  end
end