class AddOrderNumToFsOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :fs_orders, :order_num, :string
  end
end
