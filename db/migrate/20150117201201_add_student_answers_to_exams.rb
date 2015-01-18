class AddStudentAnswersToExams < ActiveRecord::Migration
  def change
    add_column :exams, :student_answer_ids, :string, array: true
    add_column :exams, :generated_answer_ids, :string, array: true
  end
end
