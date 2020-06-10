class CreateLateorderscustomercos < ActiveRecord::Migration[5.1]
  def change
    create_table :lateorderscustomercos do |t|
      t.string :cust_code
      t.string :shipto_code
      t.string :route_code
      t.datetime :cutoff_time

      t.timestamps
    end
  end
end
