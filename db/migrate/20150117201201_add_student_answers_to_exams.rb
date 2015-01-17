class AddStudentAnswersToExams < ActiveRecord::Migration
  def change
    add_column :exams, :student_answers, :string, array: true
  end
end
