class BulkDiscountsController < ApplicationController

  def index
    @bulk_discounts = Merchant.find(params[:merchant_id]).bulk_discounts
  end

  def show
  end

end