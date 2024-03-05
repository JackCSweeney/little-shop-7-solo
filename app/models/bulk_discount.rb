class BulkDiscount < ApplicationRecord

  validates :quantity_thresh, presence: true
  validates :percentage, presence: true, numericality: {less_than: 1.00, greater_than: 0.00}

  belongs_to :merchant

  def display_percentage
    (percentage * 100) 
  end

end