class AddPoNumberToFsOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :fs_orders, :po_number, :string
  end
end
