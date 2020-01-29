class CreateOrditems < ActiveRecord::Migration[5.1]
  def change
    create_table :orditems do |t|
      t.string :order_numb
      t.string :rel_numb
      t.string :part_code
      t.string :part_desc
      t.string :uom
      t.integer :qty

      t.timestamps
    end
  end
end
