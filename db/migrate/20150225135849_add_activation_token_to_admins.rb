class AddActivationTokenToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :activation_token, :string
  end
end
