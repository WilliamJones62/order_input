class AddCancelDateToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :fs_orders, :cancel_date, :date
  end
end
