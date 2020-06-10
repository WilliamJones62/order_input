class Api::V1::FsOrdersController < ApplicationController

  def api
    @fs_orders = FsOrder.where(status: "ACTIVE").where(in_process: [nil, false])
  end

end
