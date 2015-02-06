require "spec_helper"

describe Question do
  it { is_expected.to belong_to(:quiz) }
  it { is_expected.to have_many(:answers).dependent(:destroy) }
  it { is_expected.to validate_presence_of(:content) }
  it { is_expected.to validate_numericality_of(:points).only_integer }
  it do
    is_expected.to accept_nested_attributes_for(:answers).allow_destroy(true)
  end

  describe "requires at least 1 correct answer" do
    it "is valid if an answer is correct" do
      question = Fabricate.build(:question) do
        answers { incorrect(3) + correct }
      end
      expect(question).to be_valid
    end

    it "is invalid if there is no correct answer" do
      question = Fabricate.build(:question) do
        answers { incorrect(4) }
      end
      expect(question).to be_invalid
    end
  end

  describe "requires min 4 answers" do
    context "when valid" do
      it "is valid when 4+ answers" do
        question = Fabricate.build(:question) do
          answers { incorrect(4) + correct }
        end
        expect(question).to be_valid
      end
    end

    context "when invalid" do
      let(:question) do
        Fabricate.build(:question) do
          answers { Fabricate.times(3, :answer) }
        end
      end

      it { expect(question).to be_invalid }
      it "sets the errors on question" do
        question.valid?
        expect(question.errors.full_messages).
          to include "Answers - there must be at least 4 answers."
      end
    end
  end

  describe "#answers_for(exam)" do
    let!(:quiz) do
      Fabricate(:quiz) do
        questions do
          [
            Fabricate.build(:question) { answers { correct + incorrect(3) } },
            Fabricate.build(:question) { answers { correct + incorrect(3) } }
          ]
        end
      end
    end
    let(:question2)  { Question.last }
    let(:question1)  { Question.first }
    let(:answer1)    { question1.answers.first }
    let(:answer2)    { question1.answers.second }
    let(:answer3)    { question2.answers.last }

    context "generated_answer_ids" do
      it "returns an array of multiple generated answers from exam" do
        gaids = to_ids(answer1, answer2, answer3)
        exam = Fabricate(:exam, quiz: quiz, generated_answer_ids: gaids)
        expect(question1.answers_for(exam, :generated_answer_ids))
          .to match_array [answer1, answer2]
      end
    end

    context "student_answer_ids" do
      it "returns an empty array if no answers were picked" do
        exam = Fabricate(:exam, quiz: quiz)
        expect(question1.answers_for(exam, :student_answer_ids))
          .to match_array []
      end

      it "returns an array with 1 answer" do
        saids = to_ids(answer1, answer3)
        exam = Fabricate(:exam, quiz: quiz, student_answer_ids: saids)
        expect(question1.answers_for(exam, :student_answer_ids))
          .to match_array [answer1]
      end

      it "returns an array of multiple student answers from exam" do
        saids = to_ids(answer1, answer2, answer3)
        exam = Fabricate(:exam, quiz: quiz, student_answer_ids: saids)
        expect(question1.answers_for(exam, :student_answer_ids))
          .to match_array [answer1, answer2]
      end
    end
  end

  describe "#generate_answers" do
    it "generates 4 answers from mix" do
      question = Fabricate.build(:question) do
        answers { incorrect(5) + correct }
      end
      question.save
      expect(question.generate_answers.size).to eq(4)
    end

    it "generates 4 answers even if all correct" do
      question = Fabricate.build(:question) { answers { correct(4) } }
      question.save
      expect(question.generate_answers.size).to eq(4)
    end

    it "generates at least 1 correct answer" do
      question = Fabricate.build(:question) do
        answers { incorrect(5) + correct }
      end
      question.save
      expect(question.generate_answers.map(&:correct?).any?).to be true
    end

    it "generates random array" do
      question = Fabricate.build(:question) do
        answers { Fabricate.times(12, :answer) }
      end
      question.save
      answer_sets = []
      3.times { answer_sets << question.generate_answers }
      expect(answer_sets.uniq.count).not_to eq 1
    end

    it "generates array of uniq answers" do
      question = Fabricate.build(:question) do
        answers { incorrect(5) + correct }
      end
      question.save
      expect(question.generate_answers.uniq.size).to eq(4)
    end
  end

  describe "#yield_points?(exam)" do
    let(:quiz)     { Fabricate(:quiz) }
    let(:question) { Fabricate.build(:question, quiz: quiz) }
    let(:answer1)  { question.answers.find_by(correct: true) }
    let(:answer2)  { question.answers.find_by(correct: false) }
    let(:gaids)    { to_ids(answer1, answer2) }
    before { question.save }

    it "returns true if question was correctly answered" do
      saids = to_ids(answer1)
      exam = Fabricate(:exam,
                       quiz: quiz,
                       generated_answer_ids: gaids,
                       student_answer_ids: saids)
      expect(question.yield_points?(exam)).to be true
    end

    it "returns false if question was not correctly answered" do
      saids = to_ids(answer1, answer2)
      exam = Fabricate(:exam,
                       quiz: quiz,
                       generated_answer_ids: gaids,
                       student_answer_ids: saids)
      expect(question.yield_points?(exam)).to be false
    end
  end

  describe "#has_no_student_answer?(exam)" do
    let(:quiz) { Fabricate(:quiz) }

    it "returns true if there are no student answers" do
      exam = Fabricate(:exam, quiz: quiz, student_answer_ids: [])
      question = Question.first
      expect(question).to have_no_student_answer(exam)
    end

    it "returns false if there are student answers" do
      quiz
      question = Question.first
      answer = question.answers.first
      exam = Fabricate(:exam, quiz: quiz, student_answer_ids: to_ids(answer))
      expect(question).to_not have_no_student_answer(exam)
    end
  end
end

def incorrect(n = 1, options = {})
  if options == {}
    Fabricate.times(n, :incorrect)
  else
    Fabricate.times(n, :incorrect, content: options[:content])
  end
end

def correct(n = 1, options = {})
  if options == {}
    Fabricate.times(n, :correct)
  else
    Fabricate.times(n, :correct, content: options[:content])
  end
end
