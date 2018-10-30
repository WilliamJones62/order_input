class AddRepToFsOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :fs_orders, :rep, :string
  end
end
