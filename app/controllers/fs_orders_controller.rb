class FsOrdersController < ApplicationController
  before_action :set_fs_order, only: [:show, :edit, :update, :destroy]
  before_action :set_user, only: [:create, :index, :show, :edit, :update, :destroy]
  before_action :set_descriptions, only: [:new, :edit, :customer]

  # GET /fs_orders
  def index
    if @user == 'ADMIN'
      @fs_orders = FsOrder.all
    else
      @fs_orders = FsOrder.where(rep: @user).where(status: 'ACTIVE')
    end
    respond_to do |format|
      format.html
      format.csv { send_data @fs_orders.to_txt, :filename => 'orders.txt' }

    end
  end

  # GET /fs_orders/1
  def show
  end

  # GET /fs_orders/new
  def new
    @fs_order = FsOrder.new
    @fs_order.customer = $customer
    6.times { @fs_order.fs_order_parts.build }
  end

  # GET /fs_orders/1/edit
  def edit
    # need to include any parts that have been added to this order that were not previously sold
    parts = @fs_order.fs_order_parts.all
    parts.each do |p|
      if p.partdesc && !$descs.include?(p.partdesc)
        # include any new parts in description list
        jsdesc = p.partdesc.gsub(' ', '~')
        $descs.push(p.partdesc)
        $jsdescs.push(jsdesc)
      end
    end
    @fs_order.fs_order_parts.build
  end

  # POST /fs_orders
  def create
    fp = fs_order_params
    fp[:rep] = @user
    fp[:status] = 'ACTIVE'

    @fs_order = FsOrder.new(fp)

    respond_to do |format|
      if @fs_order.save
        @fs_order.fs_order_parts.each do |p|
          if p.partdesc
            p.partdesc.gsub!('~', ' ')
          # need to store the part code for each descriptions
            part = Partmstr.find_by(part_desc: p.partdesc)
            if part
              p.partcode = part.part_code
              p.save
            end
          end
        end
        format.html { redirect_to fs_orders_url, notice: 'FS order was successfully created.' }
      else
        @fs_order.fs_order_parts.build
        @fs_order.fs_order_parts.each do |p|
          if p.partdesc && !$descs.include?(p.partdesc)
            # include any new parts in description list
            jsdesc = p.partdesc.gsub(' ', '~')
            $descs.push(p.partdesc)
            $jsdescs.push(jsdesc)
          end
        end
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /fs_orders/1
  def update
    fp = fs_order_params
    respond_to do |format|
      if @fs_order.update(fp)
        @fs_order.fs_order_parts.each do |p|
          if p.partdesc
          # need to store the part code for each descriptions
            part = Partmstr.find_by(part_desc: p.partdesc)
            if part
              p.partcode = part.part_code
              p.save
            end
          end
        end
        format.html { redirect_to fs_orders_url, notice: 'FS order was successfully updated.' }
      else
        @fs_order.fs_order_parts.build
        @fs_order.fs_order_parts.each do |p|
          if p.partdesc && !$descs.include?(p.partdesc)
            # include any new parts in description list
            jsdesc = p.partdesc.gsub(' ', '~')
            $descs.push(p.partdesc)
            $jsdescs.push(jsdesc)
          end
        end
        format.html { render :edit }
      end
    end
  end

  # DELETE /fs_orders/1
  def destroy
    @fs_order.status = 'CANCELLED'
    @fs_order.cancel_rep = @user
    @fs_order.cancel_date = Date.today
    @fs_order.save
    respond_to do |format|
      format.html { redirect_to fs_orders_url, notice: 'FS order was successfully cancelled.' }
    end
  end

  def customer
    cust = Orderfrom.where(cust_group: 'FS').where(cust_status: 'A')
    $names = []
    cust.each do |c|
      $names.push(c.bus_name)
    end
  end

  def selected
    bus_name = params[:custname].gsub(' ', '~')
    i = $allnames.index(bus_name)
    $customer = $allcusts[i]
    redirect_to action: "new"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fs_order
      @fs_order = FsOrder.find(params[:id])
      $customer = @fs_order.customer
    end

    def set_user
      @user = current_user.email.upcase
    end

    def set_descriptions
      if !$alldescs
        # need to set up global list of part descriptions
        parts = Partmstr.all
        sort_array = []
        $alldescs = []
        $allcodes = []
        $alluoms = []
        $allcodes.push(' ')
        $alluoms.push(' ')
        $alldescs.push(' ')
        parts.each do |p|
          if p.part_code
            desc = p.part_desc.gsub(' ', '~')
            if p.part_code[0,1] == 'Z'
              # frozen codes should sort to the bottom of the list
              desc.insert(0,'Z')
            end
            combined = desc + p.part_code + desc.length.to_s + p.uom
            sort_array.push(combined)
          end
        end
        sorted_array = sort_array.sort
        sorted_array.each do |p|
          uom = p[p.length-2,2]
          desc_len = p[p.length-4,2]
          desc_length = desc_len.to_i
          des = p[0,desc_length]
          offset = desc_length
          code_length = p.length - (desc_length + 4)
          code = p[offset,code_length]
          if des[0,1] == 'Z'
            desc = des[1..-1]
          else
            desc = des
          end
          $allcodes.push(code)
          $alluoms.push(uom)
          $alldescs.push(desc)
        end
      end
      if !$allcusts
        # need to set up global list of customers
        customers = Orderfrom.where(cust_group: 'FS').where(cust_status: 'A')
        $allcusts = []
        $allnames = []
        $allcusts.push(' ')
        $allnames.push(' ')
        customers.each do |c|
          if !c.cust_code.blank? && !c.bus_name.blank?
            cust = c.cust_code.gsub(' ', '~')
            $allcusts.push(cust)
            name = c.bus_name.gsub(' ', '~')
            $allnames.push(name)
          end
        end
      end
      if !$old_customer || $old_customer != $customer
        sort_array = []
        parts = Oecusbuy.where(cust_code: $customer).where(last_ord_date: 18.months.ago..Date.today)
        $old_customer = $customer
        $descs = []
        $jsdescs = []
        $jsuoms = []
        $jsdescs.push('~')
        $descs.push(' ')
        $jsuoms.push('~')
        parts.each do |p|
          if p.part_code
            part = Partmstr.find_by(part_code: p.part_code)
            if part
              desc = part.part_desc.gsub(' ', '~')
              if part.part_code[0,1] == 'Z'
                # frozen codes should sort to the bottom of the list
                desc.insert(0,'Z')
              end
              combined = desc + p.part_code + desc.length.to_s + p.uom
              sort_array.push(combined)
            end
          end
        end
        sorted_array = sort_array.sort
        sorted_array.each do |p|
          uom = p[p.length-2,2]
          desc_len = p[p.length-4,2]
          desc_length = desc_len.to_i
          des = p[0,desc_length]
          offset = desc_length
          code_length = p.length - (desc_length + 4)
          code = p[offset,code_length]
          if des[0,1] == 'Z'
            desc = des[1..-1]
          else
            desc = des
          end
          $jsdescs.push(desc)
          desc.gsub!('~', ' ')
          $descs.push(desc)
          $jsuoms.push(uom)
        end
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fs_order_params
      params.require(:fs_order).permit(
        :customer, :shipto, :date_required, :rep, :status, :cancel_rep, :cancel_date,
        fs_order_parts_attributes: [
          :id,
          :partcode,
          :qty,
          :partdesc,
          :uom
        ]
      )
    end
end
