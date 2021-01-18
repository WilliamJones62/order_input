class AddNextSchedueledDeliveryToFsOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :fs_orders, :next_schedueled_delivery, :date
  end
end
