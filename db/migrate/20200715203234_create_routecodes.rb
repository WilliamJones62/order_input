class CreateRoutecodes < ActiveRecord::Migration[5.1]
  def change
    create_table :routecodes do |t|
      t.string :route_code
      t.boolean :monday
      t.boolean :tuesday
      t.boolean :wednesday
      t.boolean :thursday
      t.boolean :friday
      t.boolean :saturday
      t.boolean :sunday

      t.timestamps
    end
  end
end
