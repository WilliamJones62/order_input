class Shipto < ApplicationRecord
  establish_connection "prod".to_sym
  self.table_name = "shipto"
end
