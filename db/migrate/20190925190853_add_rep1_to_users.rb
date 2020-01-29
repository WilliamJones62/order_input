class AddRep1ToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :rep1, :string
  end
end
