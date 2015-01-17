class CreateQuizzes < ActiveRecord::Migration
  def change
    create_table :quizzes do |t|
      t.integer :course_id
      t.string :title
      t.text :description
      
      t.timestamps
    end
    add_index :quizzes, :course_id
  end
end
