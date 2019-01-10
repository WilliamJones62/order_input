class CreateOecusbuys < ActiveRecord::Migration[5.1]
  def change
    create_table :oecusbuys do |t|
      t.string :cust_code
      t.string :part_code
      t.integer :item_no
      t.integer :hist_qty
      t.integer :ord_qty
      t.string :uom
      t.date :last_ord_date
      t.date :last_ship_date
      t.string :po_vend_code
      t.date :item_outdate
      t.date :duedate
      t.string :up_all_dates
      t.string :uom_conv

      t.timestamps
    end
  end
end
