class CreateFsOrderTestParts < ActiveRecord::Migration[5.1]
  def change
    create_table :fs_order_test_parts do |t|
      t.integer :fs_order_id
      t.string :partcode
      t.integer :qty
      t.string :part_desc
      t.string :uom
      t.boolean :new_part

      t.timestamps
    end
  end
end
