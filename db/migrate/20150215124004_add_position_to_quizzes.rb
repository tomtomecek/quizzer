class AddPositionToQuizzes < ActiveRecord::Migration
  def change
    add_column :quizzes, :position, :integer
  end
end
