class RenameQuestionsValueToPoints < ActiveRecord::Migration
  def change
    rename_column :questions, :value, :points
  end
end
