class Employee < ApplicationRecord
  def name
    "#{Firstname} #{Lastname}"
  end
end
