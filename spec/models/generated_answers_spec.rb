require 'spec_helper'

describe GeneratedAnswer do
  it { is_expected.to belong_to(:generated_question) }
  it { is_expected.to belong_to(:answer) }
  it { is_expected.to have_db_index(:answer_id) }
  it { is_expected.to have_db_index(:generated_question_id) }

  describe "#correctly_answered?" do
    it "returns true if student succeeded" do
      answer = Fabricate(:gen_correct, student_marked: true)
      expect(answer).to be_correctly_answered
    end

    it "returns false if student failed" do
      answer = Fabricate(:gen_incorrect, student_marked: true)
      expect(answer).to_not be_correctly_answered
    end
  end
end
