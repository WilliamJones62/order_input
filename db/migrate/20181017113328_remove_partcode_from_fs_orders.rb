class RemovePartcodeFromFsOrders < ActiveRecord::Migration[5.1]
  def change
    remove_column :fs_orders, :partcode, :string
  end
end
