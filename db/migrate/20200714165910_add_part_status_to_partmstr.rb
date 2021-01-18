class AddPartStatusToPartmstr < ActiveRecord::Migration[5.1]
  def change
    add_column :partmstrs, :part_status, :string
  end
end
