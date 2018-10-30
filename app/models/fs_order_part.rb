class FsOrderPart < ApplicationRecord
  belongs_to :fs_order, :foreign_key => "fs_order_id"
end
