class AddRep2ToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :rep2, :string
  end
end
