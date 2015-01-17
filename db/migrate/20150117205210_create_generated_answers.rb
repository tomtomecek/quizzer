class CreateGeneratedAnswers < ActiveRecord::Migration
  def change
    create_table :generated_answers do |t|
      t.integer :answer_id
      t.integer :exam_id
      
      t.timestamp
    end
    add_index :generated_answers, :answer_id
    add_index :generated_answers, :exam_id
  end
end
