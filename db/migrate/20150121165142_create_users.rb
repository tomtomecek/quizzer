class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :provider
      t.string :uid
      t.string :username
      t.string :email
      t.string :name
      t.string :avatar_url
      t.string :github_account_url

      t.timestamps
    end
  end
end
