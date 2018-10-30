class FsOrdersController < ApplicationController
  before_action :set_fs_order, only: [:show, :edit, :update, :destroy]
  before_action :set_descriptions, only: [:new, :edit]

  # GET /fs_orders
  def index
    @user = current_user.email.upcase
    if @user == 'ADMIN'
      @fs_orders = FsOrder.all
    else
      @fs_orders = FsOrder.where(rep: @user)
    end
  end

  # GET /fs_orders/1
  def show
    @user = current_user.email.upcase
  end

  # GET /fs_orders/new
  def new
    @fs_order = FsOrder.new
    6.times { @fs_order.fs_order_parts.build }
  end

  # GET /fs_orders/1/edit
  def edit
    @fs_order.fs_order_parts.build
  end

  # POST /fs_orders
  def create
    @user = current_user.email.upcase
    fp = fs_order_params
    fp[:rep] = @user

    @fs_order = FsOrder.new(fp)

    respond_to do |format|
      if @fs_order.save
        format.html { redirect_to @fs_order, notice: 'Fs order was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /fs_orders/1
  def update
    respond_to do |format|
      if @fs_order.update(fs_order_params)
        format.html { redirect_to @fs_order, notice: 'Fs order was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /fs_orders/1
  def destroy
    @fs_order.destroy
    respond_to do |format|
      format.html { redirect_to fs_orders_url, notice: 'Fs order was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fs_order
      @fs_order = FsOrder.find(params[:id])
    end

    def set_descriptions
      if !$descs
        descs = Partmstr.all
        temp_descs = []
        descs.each do |d|
          if d.part_desc && !temp_descs.include?(d.part_desc)
            temp_descs.push(d.part_desc)
          end
        end
        $descs = temp_descs.sort
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fs_order_params
      params.require(:fs_order).permit(:partcode, :qty, :customer, :shipto, :date_required, :rep)
      params.require(:fs_order).permit(
        :customer, :shipto, :date_required,
        fs_order_parts_attributes: [
          :id,
          :partcode,
          :qty
        ]
      )
    end
end
