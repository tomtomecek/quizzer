class AddAnswerIdToGeneratedAnswers < ActiveRecord::Migration
  def change
    add_reference :generated_answers, :answer, index: true
  end
end
