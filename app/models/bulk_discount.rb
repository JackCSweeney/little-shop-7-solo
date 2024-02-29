class BulkDiscount < ApplicationRecord

  validates :quantity_thresh, presence: true
  validates :percentage, presence: true

  belongs_to :merchant

  def display_percentage
    (percentage * 100.0) 
  end

end