class AddPassRateToQuizzes < ActiveRecord::Migration
  def change
    add_column :quizzes, :passing_percentage, :integer
  end
end
