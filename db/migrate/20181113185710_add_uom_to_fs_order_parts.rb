class AddUomToFsOrderParts < ActiveRecord::Migration[5.1]
  def change
    add_column :fs_order_parts, :uom, :string
  end
end
