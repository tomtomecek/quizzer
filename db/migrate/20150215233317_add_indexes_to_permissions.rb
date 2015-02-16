class AddIndexesToPermissions < ActiveRecord::Migration
  def change
    add_index :permissions, :student_id
    add_index :permissions, :quiz_id
    add_index :permissions, :enrollment_id
  end
end
