class AddAcctManagerToFsOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :fs_orders, :acct_manager, :string
  end
end
