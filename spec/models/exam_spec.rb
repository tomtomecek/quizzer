require "spec_helper"

describe Exam do
  it { is_expected.to belong_to(:student).class_name("User") }
  it { is_expected.to belong_to(:quiz) }
  it { is_expected.to have_db_index(:quiz_id) }
  it { is_expected.to have_db_index(:student_id) }

  it "creates an exam with student answer ids empty array if no answer" do
    Fabricate(:exam)
    expect(Exam.first.student_answer_ids).to eq []
  end

  context "when built" do
    it "builds generated questions" do
      quiz = Fabricate(:quiz)
      exam = Exam.new(quiz: quiz)
      expect(exam.generated_questions).to_not be_empty
    end
  end

  describe "#student_score" do
    let(:quiz) do
      Fabricate(:quiz) do
        questions do
          [
            Fabricate.build(:question, points: 2),
            Fabricate.build(:question, points: 3)
          ]
        end
      end
    end
    let(:a1) { Fabricate(:correct, question: Question.first) }
    let(:a2) { Fabricate(:incorrect, question: Question.first) }
    let(:a3) { Fabricate(:correct, question: Question.last) }
    let(:a4) { Fabricate(:correct, question: Question.last) }
    let(:generated_answer_ids) { to_ids(a1, a2, a3, a4) }

    it "returns 0 if student has not answered anything" do
      Fabricate(:exam,
                quiz: quiz,
                generated_answer_ids: generated_answer_ids,
                student_answer_ids: [])
      expect(Exam.first.student_score).to eq(0)
    end

    it "returns sum of points for correctly answered 1 question" do
      student_answer_ids = to_ids(a1, a3)
      Fabricate(:exam,
                quiz: quiz,
                generated_answer_ids: generated_answer_ids,
                student_answer_ids: student_answer_ids)
      expect(Exam.first.student_score).to eq(2)
    end

    it "returns sum of points for all correctly answered questions" do
      student_answer_ids = to_ids(a1, a3, a4)
      Fabricate(:exam,
                quiz: quiz,
                generated_answer_ids: generated_answer_ids,
                student_answer_ids: student_answer_ids)
      expect(Exam.first.student_score).to eq(5)
    end
  end
end
