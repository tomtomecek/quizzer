class AddEnrollmentIdToExams < ActiveRecord::Migration
  def change
    add_reference :exams, :enrollment, index: true
  end
end
