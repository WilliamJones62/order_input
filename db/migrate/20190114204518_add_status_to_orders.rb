class AddStatusToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :fs_orders, :status, :string
  end
end
