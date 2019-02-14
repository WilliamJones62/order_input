class FsOrderPart < ApplicationRecord
  belongs_to :fs_order, :foreign_key => "fs_order_id"
  validates :qty, numericality: true
  validate :part_code_or_desc_must_be_present

  def self.to_csv
    attributes = %w{fs_order_id partcode qty}
    CSV.generate(headers: true, col_sep: "|") do |csv|
      csv << attributes
      all.each do |part|
        csv << part.attributes.values_at(*attributes)
      end
    end
  end

  def part_code_or_desc_must_be_present
    if !errors.any?
      if !partcode.present? && !partdesc.present?
        errors.add(:partdesc, "description or part code is required")
      end
    end
  end

end
