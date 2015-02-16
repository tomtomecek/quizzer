class CreateCertificates < ActiveRecord::Migration
  def change
    create_table :certificates do |t|
      t.integer :student_id
      t.integer :enrollment_id
      t.string :licence_number
      t.datetime :expires_at
      t.boolean :distinction

      t.timestamps
    end
  end
end
