class RemoveColumnFromExams < ActiveRecord::Migration
  def change
    remove_column :exams, :passed
  end
end
