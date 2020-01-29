class Ordhead < ApplicationRecord
  establish_connection "prod".to_sym
  self.table_name = "ordhead"
end
