class FsOrder < ApplicationRecord
  has_many :fs_order_parts, inverse_of: :fs_order, :dependent => :destroy
  accepts_nested_attributes_for :fs_order_parts, reject_if: proc { |attributes| attributes['partcode'].blank? }
end
