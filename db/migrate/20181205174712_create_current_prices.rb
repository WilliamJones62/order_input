class CreateCurrentPrices < ActiveRecord::Migration[5.1]
  def change
    create_table :current_prices do |t|
      t.string :part_code
      t.float :part_wt
      t.string :part_uom
      t.float :part_price

      t.timestamps
    end
  end
end
