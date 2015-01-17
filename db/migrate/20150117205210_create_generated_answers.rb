class CreateGeneratedAnswers < ActiveRecord::Migration
  def change
    create_table :generated_answers do |t|
      t.integer :question_id
      t.integer :exam_id
      
      t.timestamp
    end
    add_index :generated_answers, :question_id
    add_index :generated_answers, :exam_id
  end
end
