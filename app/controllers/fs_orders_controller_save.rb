class FsOrdersController < ApplicationController
  before_action :authenticate_user5!, except: [:api]
  before_action :set_fs_order, only: [:show, :edit, :update, :destroy]
  before_action :set_user, except: [:api]
  before_action :set_descriptions, only: [:new, :edit, :create, :update]
  before_action :set_names, only: [:customer, :selected]
  before_action :set_shiptos, only: [:shipto]

  # GET /fs_orders
  def index
    if @user == 'ADMIN'
      @fs_orders = FsOrder.all
    else
      @fs_orders = FsOrder.where(rep: @user).where.not(order_entered: true).where(status: "ACTIVE").where(in_process: [nil, false])
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
    @fs_order.customer = session[:customer]
    @fs_order.shipto = session[:shipto]
    s = Shipto.find_by shipto_code: session[:shipto]
    r = Routecode.find_by route_code: s.route_code
    day_today = Date.today.strftime("%A")
    case day_today
    when 'Monday'
      if r.tuesday == '1'
        next_delivery = Time.current + 1.day
      elsif r.wednesday == '1'
        next_delivery = Time.current + 2.day
      elsif r.thursday == '1'
        next_delivery = Time.current + 3.day
      elsif r.friday == '1'
        next_delivery = Time.current + 4.day
      elsif r.saturday == '1'
        next_delivery = Time.current + 5.day
      elsif r.sunday == '1'
        next_delivery = Time.current + 6.day
      elsif r.monday == '1'
        next_delivery = Time.current + 7.day
      end
    when 'Tuesday'
      if r.wednesday == '1'
        next_delivery = Time.current + 1.day
      elsif r.thursday == '1'
        next_delivery = Time.current + 2.day
      elsif r.friday == '1'
        next_delivery = Time.current + 3.day
      elsif r.saturday == '1'
        next_delivery = Time.current + 4.day
      elsif r.sunday == '1'
        next_delivery = Time.current + 5.day
      elsif r.monday == '1'
        next_delivery = Time.current + 6.day
      elsif r.tuesday == '1'
        next_delivery = Time.current + 7.day
      end
    when 'Wednesday'
      if r.thursday == '1'
        next_delivery = Time.current + 1.day
      elsif r.friday == '1'
        next_delivery = Time.current + 2.day
      elsif r.saturday == '1'
        next_delivery = Time.current + 3.day
      elsif r.sunday == '1'
        next_delivery = Time.current + 4.day
      elsif r.monday == '1'
        next_delivery = Time.current + 5.day
      elsif r.tuesday == '1'
        next_delivery = Time.current + 6.day
      elsif r.wednesday == '1'
        next_delivery = Time.current + 7.day
      end
    when 'Thursday'
      if r.friday == '1'
        next_delivery = Time.current + 1.day
      elsif r.saturday == '1'
        next_delivery = Time.current + 2.day
      elsif r.sunday == '1'
        next_delivery = Time.current + 3.day
      elsif r.monday == '1'
        next_delivery = Time.current + 4.day
      elsif r.tuesday == '1'
        next_delivery = Time.current + 5.day
      elsif r.wednesday == '1'
        next_delivery = Time.current + 6.day
      elsif r.thursday == '1'
        next_delivery = Time.current + 7.day
      end
    when 'Friday'
      if r.saturday == '1'
        next_delivery = Time.current + 1.day
      elsif r.sunday == '1'
        next_delivery = Time.current + 2.day
      elsif r.monday == '1'
        next_delivery = Time.current + 3.day
      elsif r.tuesday == '1'
        next_delivery = Time.current + 4.day
      elsif r.wednesday == '1'
        next_delivery = Time.current + 5.day
      elsif r.thursday == '1'
        next_delivery = Time.current + 6.day
      elsif r.friday == '1'
        next_delivery = Time.current + 7.day
      end
    when 'Saturday'
      if r.sunday == '1'
        next_delivery = Time.current + 1.day
      elsif r.monday == '1'
        next_delivery = Time.current + 2.day
      elsif r.tuesday == '1'
        next_delivery = Time.current + 3.day
      elsif r.wednesday == '1'
        next_delivery = Time.current + 4.day
      elsif r.thursday == '1'
        next_delivery = Time.current + 5.day
      elsif r.friday == '1'
        next_delivery = Time.current + 6.day
      elsif r.saturday == '1'
        next_delivery = Time.current + 7.day
      end
    when 'Sunday'
      if r.monday == '1'
        next_delivery = Time.current + 1.day
      elsif r.tuesday == '1'
        next_delivery = Time.current + 2.day
      elsif r.wednesday == '1'
        next_delivery = Time.current + 3.day
      elsif r.thursday == '1'
        next_delivery = Time.current + 4.day
      elsif r.friday == '1'
        next_delivery = Time.current + 5.day
      elsif r.saturday == '1'
        next_delivery = Time.current + 6.day
      elsif r.sunday == '1'
        next_delivery = Time.current + 7.day
      end
    end
    @required_date = next_delivery.strftime('%Y-%m-%d')
    @next_schedueled_delivery = next_delivery.strftime('%Y-%m-%d')
    20.times { @fs_order.fs_order_parts.build }
  end

  # GET /fs_orders/1/edit
  def edit
    # need to include any parts that have been added to this order that were not previously sold
    @required_date = @fs_order.date_required.strftime('%Y-%m-%d')
    parts = @fs_order.fs_order_parts.all
    parts.each do |p|
      if p.partdesc && !@descs.include?(p.partdesc)
        # include any new parts in description list
        jsdesc = p.partdesc.gsub(' ', '~')
        @descs.push(p.partdesc)
        @jsdescs.push(jsdesc)
      end
    end
    if @fs_order.fs_order_parts.count > 19
      @fs_order.fs_order_parts.build
    else
      i = 20 - @fs_order.fs_order_parts.count
      i.times { @fs_order.fs_order_parts.build }
    end

  end

  # POST /fs_orders
  def create
    fp = fs_order_params
    fp[:rep] = @user
    e = Employee.find_by(Badge_: @user)
    fp[:rep_name] = e.Firstname + ' ' + e.Lastname
    fp[:status] = 'ACTIVE'
    fp[:order_entered] = false
    cut_off_record = Lateorderscustomerco.find_by shipto_code: session[:shipto]
    if cut_off_record
      fp[:cut_off] = cut_off_record.cutoff_time.strftime('%l:%M:%S %p')
    else
      fp[:cut_off] = "NO CUT OFF"
    end
    fp[:next_schedueled_delivery] = @next_schedueled_delivery
    @fs_order = FsOrder.new(fp)

    respond_to do |format|
      if @fs_order.save
        @fs_order.fs_order_parts.each do |p|
          if p.partdesc
            p.partdesc.gsub!('~', ' ')
          # need to store the part code for each descriptions
            part = Partmstr.find_by part_desc: p.partdesc, part_status: 'A'
            if part
              if !p.partcode.blank?
                # if the partcode field is populated then a new part has been entered
                p.new_part = true
              else
                p.new_part = false
              end
              p.partcode = part.part_code
              p.save
            end
          end
        end
        format.html { redirect_to fs_orders_url, notice: 'FS order was successfully created.' }
      else
        @fs_order.fs_order_parts.build
        @fs_order.fs_order_parts.each do |p|
          if p.partdesc && !@descs.include?(p.partdesc)
            # include any new parts in description list
            jsdesc = p.partdesc.gsub(' ', '~')
            @descs.push(p.partdesc)
            @jsdescs.push(jsdesc)
          end
        end
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /fs_orders/1
  def update
    if @fs_order.status != "ACTIVE" || @fs_order.in_process
      # The order is now being process or has been processed so can't be updated
      redirect_to fs_orders_url, notice: 'FS order not updated. Already processed.'
    else
      fp = fs_order_params
      respond_to do |format|
        if @fs_order.update(fp)
          @fs_order.fs_order_parts.each do |p|
            if p.partdesc
              p.partdesc.gsub!('~', ' ')
            # need to store the part code for each descriptions
              part = Partmstr.find_by part_desc: p.partdesc, part_status: 'A'
              if part
                if !p.partcode.blank?
                  # if the partcode field is populated then a new part has been entered
                  p.new_part = true
                else
                  p.new_part = false
                end
                p.partcode = part.part_code
                p.save
              end
            end
          end
          format.html { redirect_to fs_orders_url, notice: 'FS order was successfully updated.' }
        else
          @fs_order.fs_order_parts.build
          @fs_order.fs_order_parts.each do |p|
            if p.partdesc && !@descs.include?(p.partdesc)
              # include any new parts in description list
              jsdesc = p.partdesc.gsub(' ', '~')
              @descs.push(p.partdesc)
              @jsdescs.push(jsdesc)
            end
          end
          format.html { render :edit }
        end
      end
    end
  end

  # DELETE /fs_orders/1
  def destroy
    if @fs_order.status != "ACTIVE" || @fs_order.in_process
      # The order is now being process or has been processed so can't be updated
      redirect_to fs_orders_url, notice: 'FS order not cancelled. Already processed.'
    else
      @fs_order.status = 'CANCELLED'
      @fs_order.cancel_rep = @user
      @fs_order.cancel_date = Date.today
      @fs_order.save
      respond_to do |format|
        format.html { redirect_to fs_orders_path, notice: 'FS order was successfully cancelled.' }
      end
    end
  end

  def customer
  end

  def selected
    if params[:custname].blank?
      redirect_to fs_orders_customer_path, notice: 'No customer selected.'
    else
      bus_name = params[:custname].gsub(/[ ,]/, ' ' => '~', ',' => '`')
      i = @allnames.index(bus_name)
      if i.blank?
        # something has gone wrong, try again
        redirect_to fs_orders_customer_path, notice: 'No customer selected. Please try again.'
      else
        session[:customer] = @allcusts[i]
        default_shipto = ''
        shiptos = CustomerShipto.where(cust_code: session[:customer])
        if shiptos.length > 1
          # the user needs to pick a ship to
          redirect_to fs_orders_shipto_path
        else
          shipto = shiptos.first
          session[:shipto] = shipto.shipto_code
          redirect_to action: "new"
        end
      end
    end
  end

  def shipto
  end

  def chosen
    if params[:shipto].blank?
      redirect_to fs_orders_shipto_path, notice: 'No ship to selected.'
    else
      session[:shipto] = params[:shipto]
      redirect_to action: "new"
    end
  end

  def error
    # find all the orders for the last 2 days with status 'ENTERED'
    if @user == 'ADMIN'
      @fs_orders = FsOrder.where(order_entered: true).where("created_at >= ?", Date.today)
    else
      @fs_orders = FsOrder.where(rep: @user).where(order_entered: true).where("created_at >= ?", Date.today)
    end
    @errors = []
    @fs_orders.each do |o|
      h = Ordhead.find_by order_numb: o.order_num
      if !h
        # an order was entered but the wrong order number was put into rapid order table
        error = { order_numb: o.order_num, error: 'Wrong order number from E21 was put into rapid orders' }
        @errors.push(error)
      else
        if h.order_date != o.date_required
          error = { order_numb: o.order_num, error: 'E21 date ('+h.order_date.strftime("%e %b %Y")+') does not match rapid order date ('+o.date_required.strftime("%e %b %Y")+').' }
          @errors.push(error)
        end
        if h.cust_code != o.customer
          error = { order_numb: o.order_num, error: 'E21 customer ('+h.cust_code+') does not match rapid order customer ('+o.customer+').' }
          @errors.push(error)
        end
        if h.shipto_code != o.shipto
          error = { order_numb: o.order_num, error: 'E21 shipto ('+h.shipto_code+') does not match rapid order shipto ('+o.shipto+').' }
          @errors.push(error)
        end
        if (h.cust_po != o.po_number) && (!h.cust_po.blank? || !o.po_number.blank?)
          error = { order_numb: o.order_num, error: 'E21 PO ('+h.cust_po.to_s+') does not match rapid order PO ('+o.po_number.to_s+').' }
          @errors.push(error)
        end
        # find discrepancies in parts between E21 and rapid order
        items = Orditem.where(order_numb: o.order_num)
        parts = o.fs_order_parts.all
        e21_parts = []
        items.each do |i|
          e21_parts.push(i.part_code)
          parts.each do |p|
            if i.part_code == p.partcode
              if i.qty != p.qty
                error = { order_numb: o.order_num, error: 'Part ('+i.part_code+') E21 quantity ('+i.qty.to_s+') does not match rapid order quantity ('+p.qty.to_s+').' }
                @errors.push(error)
              end
            end
          end
        end
        roe_parts = []
        parts.each do |p|
          roe_parts.push(p.partcode)
        end
        e21_parts.each do |e|
          if !roe_parts.include?(e)
            # e21 has a part not in the ROE data
            error = { order_numb: o.order_num, error: 'E21 part ('+e+') is not in the rapid order.' }
            @errors.push(error)
          end
        end
        roe_parts.each do |r|
          if !e21_parts.include?(r)
            # ROE has a part not in the e21 data
            error = { order_numb: o.order_num, error: 'Rapid order part ('+r+') is not in the E21 order.' }
            @errors.push(error)
          end
        end
      end
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fs_order
      @fs_order = FsOrder.find(params[:id])
      session[:customer] = @fs_order.customer
    end

    def set_user
      @user = current_user5.email.upcase
    end

    def set_descriptions
      @alldescs = Rails.cache.read('alldescs')
      if !@alldescs
        # need to set up global list of part descriptions
        parts = Partmstr.all
        # parts = Partmstr.where(part_status: 'A')
        sort_array = []
        @alldescs = []
        @allcodes = []
        @alluoms = []
        food_parts = ["ALL", "DRY", "FRE", "FRZ", "MUS"]
        unwanted_uom = ["ST", "LB"]
        @allcodes.push(' ')
        @alluoms.push(' ')
        @alldescs.push(' ')
        parts.each do |p|
          if !p.part_code.blank? && !p.part_desc.start_with?("INACTIVE") && food_parts.include?(p.storage_type) && p.part_status == "A" && !unwanted_uom.include?(p.uom)
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
          @allcodes.push(code)
          @alluoms.push(uom)
          @alldescs.push(desc)
        end
        Rails.cache.write('alldescs', @alldescs)
        Rails.cache.write('alluoms', @alluoms)
        Rails.cache.write('allcodes', @allcodes)
      else
        @alluoms = Rails.cache.read('alluoms')
        @allcodes = Rails.cache.read('allcodes')
      end
      if !session[:old_customer] || session[:old_customer] != session[:customer] || session[:old_shipto] != session[:shipto]
        sort_array = []
        # get the parts for the customer if the ship to is the same, else get the parts for the ship to
        focus_items = FsFocusItem.where(customer: session[:shipto]).where('start_date <= ?', Date.today).where('end_date >= ?', Date.today).take(2)
        parts = Oecusbuy.where(cust_code: session[:shipto]).where(last_ship_date: 56.days.ago..Date.today)
        old_parts = Oecusbuy.where(cust_code: session[:shipto]).where(last_ship_date: 394.days.ago..334.days.ago)
        session[:old_customer] = session[:customer]
        session[:old_shipto] = session[:shipto]
        @descs = []
        @jsdescs = []
        @jsuoms = []
        @jsdescs.push('~')
        @descs.push(' ')
        @jsuoms.push('~')
        if focus_items.length > 0
          desc = 'X*** FOCUS ITEMS ***'
          combined = desc + 'AAAAAAAAA' + desc.length.to_s + 'AA'
          sort_array.push(combined)
        end
        focus_items.each do |f|
          if f.part_code
            part = Partmstr.find_by part_code: f.part_code, part_status: "A"
            if part
              desc = part.part_desc.gsub(' ', '~')
              desc.insert(0,'X')
              if part.part_code[0,1] == 'Z'
                # frozen codes should sort to the bottom of the list
                desc.insert(1,'Z')
              end
              combined = desc + part.part_code + desc.length.to_s + part.uom
              sort_array.push(combined)
            end
          end
        end
        if parts.length > 0
          desc = 'Y*** RECENTLY ORDERED ***'
          combined = desc + 'AAAAAAAAA' + desc.length.to_s + 'AA'
          sort_array.push(combined)
        end
        parts.each do |p|
          if p.part_code
            part = Partmstr.find_by part_code: p.part_code, part_status: "A"
            if part
              desc = part.part_desc.gsub(' ', '~')
              desc.insert(0,'Y')
              if part.part_code[0,1] == 'Z'
                # frozen codes should sort to the bottom of the list
                desc.insert(1,'Z')
              end
              combined = desc + p.part_code + desc.length.to_s + p.uom
              sort_array.push(combined)
            end
          end
        end
        if old_parts.length > 0
          desc = 'Z*** ORDERED THIS TIME LAST YEAR ***'
          combined = desc + 'AAAAAAAAA' + desc.length.to_s + 'AA'
          sort_array.push(combined)
        end
        old_parts.each do |p|
          if p.part_code
            part = Partmstr.find_by part_code: p.part_code, part_status: "A"
            if part
              desc = part.part_desc.gsub(' ', '~')
              desc.insert(0,'Z')
              if part.part_code[0,1] == 'Z'
                # frozen codes should sort to the bottom of the list
                desc.insert(1,'Z')
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
          if des[0,2] == 'ZZ' || des[0,2] == 'YZ' || des[0,2] == 'XZ'
            desc = des[2..-1]
          else
            desc = des[1..-1]
          end
          @jsdescs.push(desc.gsub(' ', '~'))
          desc.gsub!('~', ' ')
          if !@descs.include?(desc)
            @descs.push(desc)
          end
          @jsuoms.push(uom)
        end
        jsdescs = current_user5.email+'jsdescs'
        descs = current_user5.email+'descs'
        jsuoms = current_user5.email+'jsuoms'
        Rails.cache.write(jsdescs, @jsdescs)
        Rails.cache.write(descs, @descs)
        Rails.cache.write(jsuoms, @jsuoms)
      else
        jsdescs = current_user5.email+'jsdescs'
        descs = current_user5.email+'descs'
        jsuoms = current_user5.email+'jsuoms'
        @jsuoms = Rails.cache.read(jsuoms)
        @jsdescs = Rails.cache.read(jsdescs)
        @descs = Rails.cache.read(descs)
      end
    end

    def set_names
    # need to set up global list of customers
      allcusts = current_user5.email+'allcusts'
      @allcusts = Rails.cache.read(allcusts)
      if !@allcusts
        sort_array = []
        shiptos = []
        @allcusts = []
        @allnames = []
        @names = []
        if current_user5.rep1
          shiptos = CustomerShipto.where(acct_manager: current_user5.rep1)
          if current_user5.rep2
            shiptos2 = CustomerShipto.where(acct_manager: current_user5.rep2)
            shiptos += shiptos2
            if current_user5.rep3
              shiptos2 = CustomerShipto.where(acct_manager: current_user5.rep3)
              shiptos += shiptos2
            end
          end
        end
        shiptos.each do |s|
          # some customer have short names. Adding 10 makes sure the name length is double digits
          length = s.bus_name.length + 10
          combined = s.bus_name + s.cust_code + length.to_s
          if !sort_array.include?(combined)
            sort_array.push(combined)
          end
        end
        sort_array.sort!
        sort_array.each do |p|
          name_len = p[p.length-2,2]
          name_length = name_len.to_i - 10
          bus_name = p[0,name_length]
          offset = name_length
          cust_length = p.length - (name_length + 2)
          cust = p[offset,cust_length]
          @names.push(bus_name)
          @allcusts.push(cust.gsub(' ', '~'))
          @allnames.push(bus_name.gsub(/[ ,]/, ' ' => '~', ',' => '`'))
        end
        allcusts = current_user5.email+'allcusts'
        allnames = current_user5.email+'allnames'
        names = current_user5.email+'names'
        Rails.cache.write(names, @names)
        Rails.cache.write(allnames, @allnames)
        Rails.cache.write(allcusts, @allcusts)
      else
        allnames = current_user5.email+'allnames'
        names = current_user5.email+'names'
        @names = Rails.cache.read(names)
        @allnames = Rails.cache.read(allnames)
      end
    end

    def set_shiptos
      @shiptos = []
      default_shipto = ''
      shiptos = CustomerShipto.where(cust_code: session[:customer])
      shiptos.each do |s|
        if s.default_flag == '1'
          default_shipto = s.shipto_code
        else
          @shiptos.push(s.shipto_code)
        end
      end
      @shiptos.sort!
      if !default_shipto.blank?
        @shiptos.insert(0, default_shipto)
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fs_order_params
      params.require(:fs_order).permit(
        :customer, :shipto, :date_required, :rep, :status, :cancel_rep, :cancel_date, :po_number, :notes, :order_entered, :second_run, :rep_name, :cut_off, :next_schedueled_delivery,
        fs_order_parts_attributes: [
          :id,
          :partcode,
          :qty,
          :partdesc,
          :uom,
          :new_part
        ]
      )
    end
end
