class FsOrder < ApplicationRecord
  has_many :fs_order_parts, inverse_of: :fs_order, :dependent => :destroy
  accepts_nested_attributes_for :fs_order_parts, reject_if: proc { |attributes| attributes['partdesc'].blank? }
  validates :date_required, presence: true
  validate :part_must_be_present
  validate :order_under_minimum

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
