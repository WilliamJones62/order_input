class CreateShiptos < ActiveRecord::Migration[5.1]
  def change
    create_table :shiptos do |t|
      t.string :shipto_code
      t.string :route_code

      t.timestamps
    end
  end
end
