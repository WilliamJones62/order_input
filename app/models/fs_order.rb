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
          text += part.partcode + '|' + seq.to_s + '|' + part.qty.to_s + '|' + time_stamp + '|' + order.date_required.strftime('%Y%m%d') + "\r\n"
          i += 1
          if i < len
            text += cust
          end
        end
        orders.push(order)
      end
    end
    # need to remove first and last characters from text
    text_len = text.length - 2
    if text_len > 0
      data = text.slice(1, text_len)
      # time_stamp = Time.now.strftime('%Y%m%dT%H%M')
      # file_name = "/home/billj/Desktop/Windows-Share/orders_" + time_stamp + ".txt"
      file_name = "/home/billj/Desktop/Windows-Share/loadfile.txt"
      File.write(file_name, data)
      # orders.each do |order|
      #   order.status = 'PROCESSED'
      #   order.save
      # end
    end
  end

  def part_must_be_present
    if !errors.any?
      errors.add(:customer, "order must have at least 1 part") if fs_order_parts.reject(&:marked_for_destruction?).size < 1
    end
  end

  def order_under_minimum
    if !errors.any?
      if !$first_warning
        order_value = 0
        fs_order_parts.each do |p|
          part = Partmstr.find_by(part_desc: p.partdesc)
          price = CurrentPrice.find_by(part_code: part.part_code)
          if price.part_uom = 'LB'
            order_value += price.part_price * p.qty * price.part_wt
          else
            order_value += price.part_price * p.qty
          end
        end
        if order_value < 300
          errors.add(:customer, "order under minimum, $" + order_value.to_s + ". Press 'Input order' again to continue.")
          $first_warning = true
        end
      else
        $first_warning = false
      end
    end
  end

end
