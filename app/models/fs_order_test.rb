class FsOrderTest < ApplicationRecord
  establish_connection "development".to_sym
  has_many :fs_order_test_parts, inverse_of: :fs_order_test, :dependent => :destroy
  accepts_nested_attributes_for :fs_order_test_parts, reject_if: proc { |attributes| attributes['partdesc'].blank? }
end
