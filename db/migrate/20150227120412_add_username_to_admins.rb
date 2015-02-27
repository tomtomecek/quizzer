class AddUsernameToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :username, :string
    add_index :admins, :username, unique: true
  end
end
