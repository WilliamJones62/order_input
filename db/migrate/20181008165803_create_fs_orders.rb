class CreateFsOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :fs_orders do |t|
      t.string :partcode
      t.integer :qty
      t.string :customer
      t.string :shipto
      t.date :date_required

      t.timestamps
    end
  end
end
