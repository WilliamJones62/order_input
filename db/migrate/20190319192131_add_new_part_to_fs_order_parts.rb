class AddNewPartToFsOrderParts < ActiveRecord::Migration[5.1]
  def change
    add_column :fs_order_parts, :new_part, :boolean
  end
end
