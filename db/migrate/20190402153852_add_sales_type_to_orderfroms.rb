class AddSalesTypeToOrderfroms < ActiveRecord::Migration[5.1]
  def change
    add_column :orderfroms, :sales_type, :string
  end
end
