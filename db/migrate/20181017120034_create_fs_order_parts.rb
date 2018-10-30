class CreateFsOrderParts < ActiveRecord::Migration[5.1]
  def change
    create_table :fs_order_parts do |t|
      t.integer :fs_order_id
      t.string :partcode
      t.integer :qty

      t.timestamps
    end
  end
end
