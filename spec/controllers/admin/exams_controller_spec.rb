require 'spec_helper'

describe Admin::ExamsController do
  before { set_current_admin }

  describe "GET index" do
    it_behaves_like "require admin sign in" do
      let(:action) { get :index }
    end

    it "sets the @exams" do
      exam1 = Fabricate(:exam)
      exam2 = Fabricate(:exam)
      get :index
      expect(assigns(:exams)).to match_array [exam1, exam2]
    end
  end

  describe "GET show" do
    it_behaves_like "require admin sign in" do
      let(:action) { get :show, id: 1 }
    end

    it "renders exams show normal template" do
      exam = Fabricate(:exam)
      get :show, id: exam.id
      expect(response).to render_template "exams/show"
    end

    it "sets the @exam" do
      exam = Fabricate(:exam)
      get :show, id: exam.id
      expect(assigns(:exam)).to eq exam
    end
  end
end
