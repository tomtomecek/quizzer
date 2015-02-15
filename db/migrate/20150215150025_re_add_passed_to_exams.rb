class ReAddPassedToExams < ActiveRecord::Migration
  def change
    add_column :exams, :passed, :boolean
  end
end
