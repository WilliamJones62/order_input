class AddDpToFsOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :fs_orders, :dp, :string
  end
end
