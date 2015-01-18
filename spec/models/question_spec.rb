require 'spec_helper'

describe Question do
  it { is_expected.to belong_to(:quiz) }
  it { is_expected.to have_many(:answers) }

  describe "#generated_answers(exam)" do
    it "returns an array of multiple generated answers from exam" do
      quiz      = Fabricate(:quiz)
      question  = Fabricate(:question, quiz: quiz)
      a1        = Fabricate(:answer, question: question)
      a2        = Fabricate(:answer, question: question)
      question2 = Fabricate(:question, quiz: quiz)
      a3        = Fabricate(:answer, question: question2)
      gaids = [a1, a2, a3].map(&:id).map(&:to_s)
      exam      = Fabricate(:exam, quiz: quiz, generated_answer_ids: gaids)
      expect(question.generated_answers(exam)).to match_array [a1, a2]
    end
  end
end