class AddSecondRunToFsOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :fs_orders, :second_run, :boolean
  end
end
