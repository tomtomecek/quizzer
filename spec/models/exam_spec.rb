require "spec_helper"

describe Exam do
  it { is_expected.to belong_to(:student).class_name("User") }
  it { is_expected.to belong_to(:quiz) }
  it { is_expected.to belong_to(:enrollment) }
  it { is_expected.to have_db_index(:quiz_id) }
  it { is_expected.to have_db_index(:student_id) }
  it { is_expected.to have_many(:generated_questions).dependent(:destroy) }
  it do
    is_expected.to have_many(:generated_answers).through(:generated_questions)
  end

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

  describe "#grade!" do
    let(:quiz) { Fabricate(:quiz, passing_percentage: 60) }
    let(:exam) { Fabricate(:exam, quiz: quiz) }
    let(:gq1) { Fabricate(:gen_question, exam: exam, points: 2) }
    let(:gq2) { Fabricate(:gen_question, exam: exam, points: 3) }
    before { allow_any_instance_of(Quiz).to receive(:total_score).and_return(5) }

    it "sets score to 0 if student has not answered anything" do
      Fabricate(:gen_correct, generated_question: gq1, student_marked: nil)
      Fabricate(:gen_correct, generated_question: gq1, student_marked: nil)
      Fabricate(:gen_incorrect, generated_question: gq2, student_marked: nil)
      Fabricate(:gen_correct, generated_question: gq2, student_marked: nil)
      exam.grade!
      expect(exam.reload.score).to eq(0)
    end

    it "sets score to sum of points for correctly answered 1 question" do
      Fabricate(:gen_correct, generated_question: gq1, student_marked: true)
      Fabricate(:gen_correct, generated_question: gq1, student_marked: true)
      Fabricate(:gen_incorrect, generated_question: gq2, student_marked: nil)
      Fabricate(:gen_correct, generated_question: gq2, student_marked: nil)
      exam.grade!
      expect(exam.reload.score).to eq(2)
    end

    it "sets score to sum of points for all correctly answered questions" do
      Fabricate(:gen_correct, generated_question: gq1, student_marked: true)
      Fabricate(:gen_correct, generated_question: gq1, student_marked: true)
      Fabricate(:gen_incorrect, generated_question: gq2, student_marked: nil)
      Fabricate(:gen_correct, generated_question: gq2, student_marked: true)
      exam.grade!
      expect(exam.reload.score).to eq(5)
    end

    it "sets status as completed" do
      exam.grade!
      expect(exam.reload.status).to eq("completed")
    end

    it "sets passed to true" do
      allow_any_instance_of(Exam).to receive(:calculated_score).and_return(5)
      exam.grade!
      expect(exam.reload.passed).to be true
    end

    it "sets passed to false" do
      allow_any_instance_of(Exam).to receive(:calculated_score).and_return(2)
      exam.grade!
      expect(exam.reload.passed).to be false
    end
  end

  describe "scope .passed" do
    it "returns [] if no exam has passed" do
      Fabricate(:exam, passed: false)
      expect(Exam.passed).to eq []
    end

    it "returns an exam for 1 exam passed" do
      exam = Fabricate(:exam, passed: true)
      expect(Exam.passed).to eq [exam]
    end

    it "returns an array of multiple exams" do
      exam1 = Fabricate(:exam, passed: true)
      exam2 = Fabricate(:exam, passed: true)
      Fabricate(:exam, passed: false)
      expect(Exam.passed).to eq [exam1, exam2]
    end
  end

  describe "scope .failed" do
    it "returns [] if no exam is completed" do
      Fabricate(:exam, passed: true)
      expect(Exam.failed).to eq []
    end

    it "returns an exam for 1 exam passed" do
      exam = Fabricate(:exam, passed: false)
      expect(Exam.failed).to eq [exam]
    end

    it "returns an array of multiple exams" do
      exam1 = Fabricate(:exam, passed: false)
      exam2 = Fabricate(:exam, passed: false)
      Fabricate(:exam, passed: true)
      expect(Exam.failed).to eq [exam1, exam2]
    end
  end

  describe "#completed?" do
    it "returns true when exam is completed" do
      exam = Fabricate(:exam, status: "completed")
      expect(exam.completed?).to be true
    end

    it "returns false when exam is not completed" do
      exam = Fabricate(:exam, status: "in progress")
      expect(exam.completed?).to be false
    end
  end
end
