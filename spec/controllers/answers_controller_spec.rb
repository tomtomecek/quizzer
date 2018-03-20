require 'spec_helper'

describe AnswersController do
  before { set_current_admin }

  describe "XHR GET edit" do
    it_behaves_like "require admin sign in" do
      let(:action) { xhr :get, :edit, id: 1 }
    end

    it "sets the @answer" do
      answer = Fabricate(:answer)
      xhr :get, :edit, id: answer.id
      expect(assigns(:answer)).to eq answer
    end
  end

  describe "XHR PATCH update" do
    let(:question) do
      Fabricate(:question) do
        answers do
          [
            Fabricate(:correct),
            Fabricate(:incorrect, content: "screwed content"),
            Fabricate(:incorrect),
            Fabricate(:incorrect)
          ]
        end
      end
    end

    it_behaves_like "require admin sign in" do
      let(:action) { xhr :patch, :update, id: 1 }
    end

    context "with valid data" do
      let(:answer) { question.answers.find_by(content: "screwed content") }

      it "updates answers content" do
        xhr :patch, :update, id: answer.id, answer: { content: "fixed" }
        expect(answer.reload.content).to eq "fixed"
      end

      it "updates answers correctness" do
        xhr :patch, :update, id: answer.id, answer: { content: "x",
          correct: true }
        expect(answer.reload).to be_correct
      end
    end

    context "with invalid data" do
      let(:last_correct_answer) { question.answers.find_by(correct: true) }
      before do
        xhr :patch,
            :update,
            id: last_correct_answer.id,
            answer: { content: "x", correct: false }
      end

      it "does not update answer if its the last correct" do
        expect(last_correct_answer.reload).to be_correct
      end

      it "sets the flash danger" do
        expect(flash.now[:danger]).to match /At least 1 answer must be correct/
      end
    end
  end

  describe "XHR DELETE destroy" do
    it_behaves_like "require admin sign in" do
      let(:action) { xhr :delete, :destroy, id: 1 }
    end

    context "with invalid data" do
      it "does not delete the last correct answer" do
        question = Fabricate(:question) do
          answers { Fabricate.times(4, :incorrect) << Fabricate(:correct) }
        end
        last_correct_answer = question.answers.find_by(correct: true)
        expect { xhr :delete, :destroy, id: last_correct_answer.id }.
          to_not change { Answer.count }
      end

      it "does not delete the answer if there are already 4 answers" do
        question = Fabricate(:question) do
          answers { Fabricate.times(3, :incorrect) << Fabricate(:correct) }
        end
        answer = question.answers.find_by(correct: false)
        expect { xhr :delete, :destroy, id: answer.id }.
          to_not change { Answer.count }
      end
    end

    context "with valid data" do
      let(:question) do
        Fabricate(:question) do
          answers do
            Fabricate.times(3, :incorrect) + Fabricate.times(2 ,:correct)
          end
        end
      end

      it "deletes 2nd correct answer" do
        second_correct_answer = question.answers.where(correct: true).second
        expect { xhr :delete, :destroy, id: second_correct_answer.id }.
          to change { Answer.count }.by -1
      end

      it "deletes an answer" do
        any_incorrect_answer = question.answers.where(correct: false).sample
        expect { xhr :delete, :destroy, id: any_incorrect_answer.id }.
          to change { Answer.count }.by -1
      end
    end
  end
end
