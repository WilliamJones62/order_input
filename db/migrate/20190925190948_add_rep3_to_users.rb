class AddRep3ToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :rep3, :string
  end
end
