class AddCutOffToFsOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :fs_orders, :cut_off, :string
  end
end
