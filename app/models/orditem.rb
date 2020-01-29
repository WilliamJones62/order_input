class Orditem < ApplicationRecord
  establish_connection "prod".to_sym
  self.table_name = "orditem"
end
