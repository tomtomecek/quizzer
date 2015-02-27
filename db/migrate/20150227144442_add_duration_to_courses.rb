class AddDurationToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :duration, :string
    add_reference :courses, :admin, index: true
    add_column :courses, :min_quiz_count, :integer
    add_column :courses, :image_path, :string
  end
end
