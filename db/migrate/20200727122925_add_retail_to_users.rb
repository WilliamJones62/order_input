class AddRetailToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :retail, :boolean
  end
end
