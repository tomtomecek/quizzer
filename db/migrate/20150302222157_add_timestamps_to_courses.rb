class AddTimestampsToCourses < ActiveRecord::Migration
  def change
    add_timestamps :courses
  end
end
