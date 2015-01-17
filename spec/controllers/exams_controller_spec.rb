require 'spec_helper'

describe ExamsController do
  describe "GET new" do
    it "sets the @exam" do
      ruby = Fabricate(:course)
      quiz = Fabricate(:quiz, course: ruby)
      get :new, quiz_id: quiz.id
      expect(assigns(:exam)).to be_new_record
      expect(assigns(:exam)).to be_kind_of(Exam)
    end
  end
end