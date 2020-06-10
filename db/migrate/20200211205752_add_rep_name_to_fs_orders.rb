class AddRepNameToFsOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :fs_orders, :rep_name, :string
  end
end
