require 'spec_helper'

describe Question do
  it { is_expected.to belong_to(:quiz) }
  it { is_expected.to have_many(:answers) }

  describe "#answers_for(exam)" do
    let(:quiz)      { Fabricate(:quiz) }
    let(:question1) { Fabricate(:question, quiz: quiz) }
    let(:question2) { Fabricate(:question, quiz: quiz) }
    let(:answer1)   { Fabricate(:answer, question: question1) }
    let(:answer2)   { Fabricate(:answer, question: question1) }
    let(:answer3)   { Fabricate(:answer, question: question2) }

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
    it "generates 4 answers total" do
      question = Fabricate(:question)
      Fabricate.times(9, :answer, question: question, correct: false)
      correct_answer = Fabricate(:answer, question: question, correct: true)
      expect(question.generate_answers.size).to eq(4)
    end

    it "generates at least 1 correct answer" do
      question = Fabricate(:question)
      Fabricate.times(9, :answer, question: question, correct: false)
      correct_answer = Fabricate(:answer, question: question, correct: true)
      expect(question.generate_answers).to include(correct_answer)
    end

    it "generates random array" do
      question = Fabricate(:question)
      Fabricate.times(9, :answer, question: question, correct: false)
      Fabricate.times(3, :answer, question: question, correct: true)
      answer_sets = []
      3.times { answer_sets << question.generate_answers }
      expect(answer_sets.uniq.count).not_to eq 1
    end
  end

  describe "#yield_points?(exam)" do
    let(:quiz)     { Fabricate(:quiz) }
    let(:question) { Fabricate(:question, quiz: quiz) }
    let(:answer1)  { Fabricate(:answer, question: question, correct: true) }
    let(:answer2)  { Fabricate(:answer, question: question, correct: false) }
    let(:gaids)    { to_ids(answer1, answer2) }

    it "returns true if question was correctly answered" do      
      saids = to_ids(answer1)
      exam = Fabricate(:exam, quiz: quiz, generated_answer_ids: gaids, student_answer_ids: saids)
      expect(question.yield_points?(exam)).to be true
    end

    it "returns false if question was not correctly answered" do      
      saids = to_ids(answer1, answer2)
      exam = Fabricate(:exam, quiz: quiz, generated_answer_ids: gaids, student_answer_ids: saids)
      expect(question.yield_points?(exam)).to be false
    end
  end
end