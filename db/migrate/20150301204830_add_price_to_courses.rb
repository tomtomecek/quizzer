class AddPriceToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :price_cents, :integer
  end
end
