class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer :quiz_id
      t.text :content
      t.integer :value
      
      t.timestamp
    end
    add_index :questions, :quiz_id
  end
end
