class Routecode < ApplicationRecord
  establish_connection "prod".to_sym
  self.table_name = "routecode"
end
