class AddPartdescToFsOrderTestParts < ActiveRecord::Migration[5.1]
  def change
    add_column :fs_order_test_parts, :partdesc, :string
  end
end
