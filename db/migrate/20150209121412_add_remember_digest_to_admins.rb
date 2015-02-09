class AddRememberDigestToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :remember_digest, :string
  end
end
