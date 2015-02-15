class UpdateScore < ActiveRecord::Migration
  def change
    change_column_default :exams, :score, nil
  end
end
