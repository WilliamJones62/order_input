class AddNotesToFsOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :fs_orders, :notes, :text
  end
end
