class FsOrderPartsController < ApplicationController
  before_action :set_fs_order
  before_action :set_fs_order_part, except: [:new, :create]

  def new
    @fs_order_part = FsOrderPart.new
  end

  def edit
  end

  def create
    @fs_order_part = FsOrderPart.new(fs_order_part_params)
    @fs_order_part.save
    render action: 'show', status: :created, location:@fs_order
  end

  def update
    @fs_order_part.update(fs_order_part_params)
  end

  def destroy
    @fs_order_part.destroy
    redirect_to @fs_order
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fs_order
      @fs_order = FsOrder.find(params[:fs_order_id])
    end
    def set_fs_order_part
      @fs_order_part = FsOrderPart.find(params[:id])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def fs_order_part_params
      params.require(:fs_order_part).permit(:fs_order_id, :who, :outcome, :call_date)
    end
end
