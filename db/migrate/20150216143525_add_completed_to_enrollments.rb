class AddCompletedToEnrollments < ActiveRecord::Migration
  def change
    add_column :enrollments, :completed, :boolean, default: false
  end
end
