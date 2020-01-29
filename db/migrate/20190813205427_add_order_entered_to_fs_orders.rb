class AddOrderEnteredToFsOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :fs_orders, :order_entered, :boolean
  end
end
