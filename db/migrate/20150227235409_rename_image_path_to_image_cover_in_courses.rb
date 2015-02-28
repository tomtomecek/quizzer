class RenameImagePathToImageCoverInCourses < ActiveRecord::Migration
  def change
    rename_column :courses, :image_path, :image_cover
  end
end
