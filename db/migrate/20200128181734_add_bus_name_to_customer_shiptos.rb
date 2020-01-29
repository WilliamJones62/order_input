class AddBusNameToCustomerShiptos < ActiveRecord::Migration[5.1]
  def change
    add_column :customer_shiptos, :bus_name, :string
  end
end
