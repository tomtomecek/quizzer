require "spec_helper"

describe Exam do
  it { is_expected.to belong_to(:student).class_name("User") }
  it { is_expected.to belong_to(:quiz) }
  it { is_expected.to have_db_index(:quiz_id) }
  it { is_expected.to have_db_index(:student_id) }
  it { is_expected.to have_many(:generated_questions).dependent(:destroy) }
  it { is_expected.to have_many(:generated_answers).through(:generated_questions) }

  describe "#create_questions_with_answers!" do
    let(:quiz) { Fabricate(:quiz) }
    let(:exam) { Fabricate.build(:exam, quiz: quiz) }
    before do
      exam.build_questions_with_answers!
      exam.save
    end

    it "builds generated questions" do
      expect(exam.generated_questions).to_not be_empty
    end

    it "builds generated answers to generated questions" do
      expect(exam.generated_answers).to_not be_empty
    end
  end

  describe "#student_score" do
    let(:exam) { Fabricate(:exam) }
    let(:gq1) { Fabricate(:gen_question, exam: exam, points: 2) }
    let(:gq2) { Fabricate(:gen_question, exam: exam, points: 3) }
    let(:a1) { Fabricate(:gen_correct, generated_question: gq1) }
    let(:a2) { Fabricate(:gen_correct, generated_question: gq1) }
    let(:a3) { Fabricate(:gen_incorrect, generated_question: gq2) }
    let(:a4) { Fabricate(:gen_correct, generated_question: gq2) }

    it "returns 0 if student has not answered anything" do
      a1.update_column(:student_marked, nil)
      a2.update_column(:student_marked, nil)
      a3.update_column(:student_marked, nil)
      a4.update_column(:student_marked, nil)
      expect(Exam.first.student_score).to eq(0)
    end

    it "returns sum of points for correctly answered 1 question" do
      a1.update_column(:student_marked, true)
      a2.update_column(:student_marked, true)
      a3.update_column(:student_marked, nil)
      a4.update_column(:student_marked, nil)
      expect(Exam.first.student_score).to eq(2)
    end

    it "returns sum of points for all correctly answered questions" do
      a1.update_column(:student_marked, true)
      a2.update_column(:student_marked, true)
      a3.update_column(:student_marked, nil)
      a4.update_column(:student_marked, true)
      expect(Exam.first.student_score).to eq(5)
    end
  end
end
