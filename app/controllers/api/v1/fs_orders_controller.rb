class Api::V1::FsOrdersController < ApplicationController

  def api
    @fs_orders = FsOrder.where.not(order_entered: true).where(status: "ACTIVE")
  end

end
