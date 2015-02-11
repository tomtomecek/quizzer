class CreateEnrollments < ActiveRecord::Migration
  def change
    create_table :enrollments do |t|
      t.references :course
      t.integer :student_id
      t.boolean :paid

      t.timestamps
    end
  end
end
