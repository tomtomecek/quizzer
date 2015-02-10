class AddScoreToExams < ActiveRecord::Migration
  def change
    add_column :exams, :score, :integer, default: 0
    remove_column :exams, :student_answer_ids
    remove_column :exams, :generated_answer_ids
  end
end
