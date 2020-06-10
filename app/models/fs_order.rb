class FsOrder < ApplicationRecord
  has_many :fs_order_parts, inverse_of: :fs_order, :dependent => :destroy
  accepts_nested_attributes_for :fs_order_parts, reject_if: proc { |attributes| attributes['partdesc'].blank? }
  validates :date_required, presence: true
  validate :part_must_be_present
  validate :order_under_minimum


  def self.to_csv
    CSV.generate(headers: true, col_sep: "|") do |csv|
      csv << attributes = %w{customer date_required partcode qty}
      all.each do |order|
        order.fs_order_parts.each do |part|
          csv << order.attributes.merge(part.attributes).values_at(*attributes)
        end
      end
    end
  end

  def self.to_txt
    $ignore_errors = true
    text = '|'
    orders = []
    time_stamp = Time.now.strftime('%Y%m%dT%H%M')
    all.each do |order|
      if order.status == 'ACTIVE'
        cust = order.customer + '|'
        text += cust
        i = 0
        parts = order.fs_order_parts.all
        len = parts.length
        parts.each do |part|
          seq = (i + 1) * 10
          if !order.po_number.blank?
            po_number = order.po_number
          else
            po_number = time_stamp
          end
          text += part.partcode + '|' + seq.to_s + '|' + part.qty.to_s + '|' + po_number + '|' + order.date_required.strftime('%Y%m%d') + "\r\n"
          i += 1
          if i < len
            text += cust
          end
        end
        orders.push(order)
      end
    end
    # need to remove first and last characters from text
    text_len = text.length - 1
    if text_len > 0
      data = text.slice(1, text_len)
      # time_stamp = Time.now.strftime('%Y%m%dT%H%M')
      # file_name = "/home/billj/Desktop/Windows-Share/orders" + time_stamp + ".txt"
      file_name = "/home/billj/Desktop/Windows-Share/orders.txt"
      open(file_name, 'a') do |f|
        f << data
      end
      # File.write(file_name, data)
      orders.each do |order|
        order.status = 'PROCESSED'
        order.save
      end
    end
    $ignore_errors = false
  end

  def part_must_be_present
    if !errors.any? && !$ignore_errors
      errors.add(:customer, "order must have at least 1 part") if fs_order_parts.reject(&:marked_for_destruction?).size < 1
    end
  end

  def order_under_minimum
    if !errors.any? && !$ignore_errors
      order_value = 0
      partcode = ' '
      fs_order_parts.each do |p|
        if p.partcode.present?
          part = Partmstr.find_by(part_code: p.partcode)
          if part
            partcode = p.partcode
          else
            p.partdesc.gsub!('~', ' ')
            if p.partdesc.present?
              part = Partmstr.find_by(part_desc: p.partdesc)
              if part
                partcode = part.part_code
              end
            end
          end
        else
          p.partdesc.gsub!('~', ' ')
          if p.partdesc.present?
            part = Partmstr.find_by(part_desc: p.partdesc)
            if part
              partcode = part.part_code
            end
          end
        end
        price = CurrentPrice.find_by(part_code: partcode)
        if price
          if price.part_uom == 'LB'
            order_value += price.part_price * p.qty * price.part_wt
          else
            order_value += price.part_price * p.qty
          end
        end
      end
      order_value.round(2)
      if !$value || $value != order_value
        $value = order_value
        if order_value < 300
          errors.add(:customer, "approximate order amount of $" + order_value.to_s + " is under the minimum. Press 'Input order' again to continue.")
        end
      end
    end
  end

end
