class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.integer :enrollment_id
      t.integer :quiz_id
      t.integer :student_id
      t.integer :attempt
      t.datetime :expires_at
      t.timestamps
    end
  end
end
