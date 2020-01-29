class CreateOrdheads < ActiveRecord::Migration[5.1]
  def change
    create_table :ordheads do |t|
      t.string :order_numb
      t.string :rel_numb
      t.date :order_date
      t.string :cust_code
      t.string :cust_name
      t.string :cust_po
      t.string :shipto_code

      t.timestamps
    end
  end
end
