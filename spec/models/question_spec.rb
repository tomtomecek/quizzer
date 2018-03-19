require "spec_helper"

describe Question do
  it { is_expected.to belong_to(:quiz) }
  it { is_expected.to have_many(:answers).dependent(:delete_all) }
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

  describe "#generate_answers" do
    it "generates 4 answers from mix" do
      question = Fabricate(:question) do
        answers { incorrect(5) + correct }
      end
      expect(question.generate_answers.size).to eq(4)
    end

    it "generates 4 answers even if all correct" do
      question = Fabricate(:question) { answers { correct(4) } }
      expect(question.generate_answers.size).to eq(4)
    end

    it "generates at least 1 correct answer" do
      question = Fabricate(:question) do
        answers { incorrect(5) + correct }
      end
      expect(question.generate_answers.map(&:correct?).any?).to be true
    end

    it "generates random array" do
      question = Fabricate(:question) do
        answers { Fabricate.times(12, :answer) }
      end
      answer_sets = []
      3.times { answer_sets << question.generate_answers }
      expect(answer_sets.uniq.count).not_to eq 1
    end

    it "generates array of uniq answers" do
      question = Fabricate(:question) do
        answers { incorrect(5) + correct }
      end
      expect(question.generate_answers.uniq.size).to eq(4)
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
end
