class CreateCustomerShiptos < ActiveRecord::Migration[5.1]
  def change
    create_table :customer_shiptos do |t|
      t.string :cust_code
      t.string :shipto_code
      t.boolean :default_flag
      t.string :acct_manager

      t.timestamps
    end
  end
end
