class Api::V1::FsOrdersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def api
    @fs_orders = FsOrder.where(status: "ACTIVE").where(in_process: [nil, false])
  end

  def parts
    @fs_parts = Rails.cache.read('fsparts')
    if !@fs_parts
      parts = Partmstr.all
      food_parts = ["ALL", "DRY", "FRE", "FRZ", "MUS"]
      unwanted_uom = ["ST", "LB"]
      @fs_parts = []
      parts.each do |p|
        if !p.part_code.blank? && !p.part_desc.start_with?("INACTIVE") && food_parts.include?(p.storage_type) && p.part_status == "A" && !unwanted_uom.include?(p.uom) && @fs_parts.length < 11
          # this is a valid part
          @fs_parts.push(p)
        end
      end
      Rails.cache.write('fsparts', @fs_parts)
    end
  end

  # POST /fs_orders
  def create
    @fs_order = FsOrderTest.create!(fs_order_params)
  end

  private
    def fs_order_params
      params.require(:fs_order).permit(
        :customer, :shipto, :date_required, :rep, :status, :cancel_rep, :cancel_date, :po_number, :notes, :order_entered, :second_run, :rep_name, :cut_off, :next_schedueled_delivery,
        fs_order_test_parts_attributes: [
          :id,
          :fs_order_id,
          :fs_order_test_id,
          :partcode,
          :qty,
          :partdesc,
          :uom,
          :new_part
        ]
      )
    end

end
