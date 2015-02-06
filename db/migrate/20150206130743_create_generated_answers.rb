class CreateGeneratedAnswers < ActiveRecord::Migration
  def change
    create_table :generated_answers do |t|
      t.references :generated_question, index: true
      t.text :content
      t.boolean :correct
      t.boolean :student_marked
      t.timestamps
    end
  end
end
