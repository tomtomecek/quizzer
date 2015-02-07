class AddPasswordResetTokenToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :password_reset_token, :string
    add_column :admins, :password_reset_expires_at, :datetime
  end
end
