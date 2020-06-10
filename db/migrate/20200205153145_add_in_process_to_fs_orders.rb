class AddInProcessToFsOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :fs_orders, :in_process, :boolean
  end
end
