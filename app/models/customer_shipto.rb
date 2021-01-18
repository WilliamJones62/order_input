class CustomerShipto < ApplicationRecord
  establish_connection "prod".to_sym
  self.table_name = "vw_cust_shipto_active"
end
