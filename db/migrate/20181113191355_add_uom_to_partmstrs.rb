class AddUomToPartmstrs < ActiveRecord::Migration[5.1]
  def change
    add_column :partmstrs, :uom, :string
  end
end
