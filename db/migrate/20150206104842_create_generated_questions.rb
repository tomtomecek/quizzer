class CreateGeneratedQuestions < ActiveRecord::Migration
  def change
    create_table :generated_questions do |t|
      t.references :question, index: true
      t.references :exam    , index: true
      t.text       :content
      t.integer    :points
      t.timestamps
    end
  end
end
