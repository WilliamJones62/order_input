class AddFsOrderTestIdToFsOrderTestParts < ActiveRecord::Migration[5.1]
  def change
    add_column :fs_order_test_parts, :fs_order_test_id, :integer
  end
end
