class CreateStudentAnswers < ActiveRecord::Migration
  def change
    create_table :student_answers do |t|
      t.integer :answer_id
      t.integer :exam_id      

      t.timestamps
    end
    add_index :student_answers, :answer_id
    add_index :student_answers, :exam_id
  end
end
