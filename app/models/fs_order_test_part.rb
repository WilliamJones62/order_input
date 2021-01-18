class FsOrderTestPart < ApplicationRecord
  establish_connection "development".to_sym
  belongs_to :fs_order_test, :foreign_key => "fs_order_test_id"
end
