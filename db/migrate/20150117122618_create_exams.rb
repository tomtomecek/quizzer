class CreateExams < ActiveRecord::Migration
  def change
    create_table :exams do |t|
      t.integer :quiz_id
      t.integer :student_id

      t.timestamps
    end
    add_index :exams, :quiz_id
    add_index :exams, :student_id
  end
end
