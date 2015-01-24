class AddPublishedToQuizzes < ActiveRecord::Migration
  def change
    add_column :quizzes, :published, :boolean, default: false
  end
end
