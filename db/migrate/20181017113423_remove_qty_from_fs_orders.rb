class RemoveQtyFromFsOrders < ActiveRecord::Migration[5.1]
  def change
    remove_column :fs_orders, :qty, :integer
  end
end
