class AddDurationToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :duration, :string
    add_reference :courses, :instructor, index: true
    add_column :courses, :min_quiz_count, :integer
    add_column :courses, :image_path, :string
    add_column :courses, :published, :boolean, default: false
  end
end
