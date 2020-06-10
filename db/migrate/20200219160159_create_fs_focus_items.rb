class CreateFsFocusItems < ActiveRecord::Migration[5.1]
  def change
    create_table :fs_focus_items do |t|
      t.string :team
      t.string :rep
      t.string :customer
      t.string :part_code
      t.string :part_desc
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
