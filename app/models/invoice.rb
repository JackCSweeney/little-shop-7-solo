class Invoice < ApplicationRecord
  validates :status, presence: true
  
  belongs_to :customer
  has_many :transactions, dependent: :destroy
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :bulk_discounts, through: :merchants

  enum status: ["in progress", "cancelled", "completed"]
  
  # class method for checking status of invoice
  def self.invoices_with_unshipped_items
    Invoice.select("invoices.*").joins(:invoice_items).where("invoice_items.status != 2")
  end

  def self.oldest_to_newest
    Invoice.order("invoices.created_at")
  end

  def self.invoices_with_unshipped_items_oldest_to_newest
    Invoice.invoices_with_unshipped_items.oldest_to_newest
  end

  def total_revenue_dollars
    invoice_items.sum("quantity * unit_price")/100.00
  end
  
  def total_revenue
    self.invoice_items.sum("unit_price * quantity")
  end

  def total_revenue_of_discounted_items
    x = bulk_discounts
    .where("invoice_items.quantity >= bulk_discounts.quantity_thresh")
    .select("MIN(invoice_items.unit_price - (invoice_items.unit_price * bulk_discounts.percentage)) * invoice_items.quantity AS discounted_price, invoice_items.item_id")
    .group("invoice_items.quantity, item_id")

    x.sum do |discounted_item_total|
      discounted_item_total.discounted_price
    end
  end

  def total_non_discount_merchant_invoice_revenue
    bulk_discounts
    .where("invoice_items.quantity < bulk_discounts.quantity_thresh")
    .sum("invoice_items.unit_price * invoice_items.quantity")
  end

  def total_discounted_merchant_revenue
    total_revenue_of_discounted_items + total_non_discount_merchant_invoice_revenue
  end


end
