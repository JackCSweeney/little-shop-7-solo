class BulkDiscount < ApplicationRecord

  validates :quantity_thresh, presence: true
  validates :percentage, presence: true

  belongs_to :merchant

end