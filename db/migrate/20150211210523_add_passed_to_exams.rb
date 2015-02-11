class AddPassedToExams < ActiveRecord::Migration
  def change
    add_column :exams, :passed, :boolean
  end
end
