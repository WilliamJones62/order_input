class CurrentPrice < ApplicationRecord
  establish_connection "e21prod".to_sym
  self.table_name = "dart_current_price"
end
