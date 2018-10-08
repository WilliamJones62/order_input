class FsOrdersController < ApplicationController
  before_action :set_fs_order, only: [:show, :edit, :update, :destroy]

  # GET /fs_orders
  # GET /fs_orders.json
  def index
    @fs_orders = FsOrder.all
  end

  # GET /fs_orders/1
  # GET /fs_orders/1.json
  def show
  end

  # GET /fs_orders/new
  def new
    @fs_order = FsOrder.new
  end

  # GET /fs_orders/1/edit
  def edit
  end

  # POST /fs_orders
  # POST /fs_orders.json
  def create
    @fs_order = FsOrder.new(fs_order_params)

    respond_to do |format|
      if @fs_order.save
        format.html { redirect_to @fs_order, notice: 'Fs order was successfully created.' }
        format.json { render :show, status: :created, location: @fs_order }
      else
        format.html { render :new }
        format.json { render json: @fs_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fs_orders/1
  # PATCH/PUT /fs_orders/1.json
  def update
    respond_to do |format|
      if @fs_order.update(fs_order_params)
        format.html { redirect_to @fs_order, notice: 'Fs order was successfully updated.' }
        format.json { render :show, status: :ok, location: @fs_order }
      else
        format.html { render :edit }
        format.json { render json: @fs_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fs_orders/1
  # DELETE /fs_orders/1.json
  def destroy
    @fs_order.destroy
    respond_to do |format|
      format.html { redirect_to fs_orders_url, notice: 'Fs order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fs_order
      @fs_order = FsOrder.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fs_order_params
      params.require(:fs_order).permit(:partcode, :qty, :customer, :shipto, :date_required)
    end
end
