class CreatePartmstrs < ActiveRecord::Migration[5.1]
  def change
    create_table :partmstrs do |t|
      t.string :part_code
      t.string :part_desc
      t.string :part_grp

      t.timestamps
    end
  end
end
