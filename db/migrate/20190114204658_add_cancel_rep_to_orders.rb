class AddCancelRepToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :fs_orders, :cancel_rep, :string
  end
end
