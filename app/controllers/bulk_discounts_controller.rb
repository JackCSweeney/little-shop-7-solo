class BulkDiscountsController < ApplicationController

  def index
    @merchant = Merchant.find(bulk_discount_params[:merchant_id])
    @bulk_discounts = @merchant.bulk_discounts
  end

  def show
    @bulk_discount = BulkDiscount.find(bulk_discount_params[:id])
  end

  def new
    @merchant = Merchant.find(bulk_discount_params[:merchant_id])
  end

  def create
    merchant = Merchant.find(bulk_discount_params[:merchant_id])
    bulk_discount = BulkDiscount.new(bulk_discount_params)
    if bulk_discount.save
      redirect_to merchant_bulk_discounts_path(merchant)
    else
      redirect_to new_merchant_bulk_discount_path(merchant)
      flash[:error] = "Error: #{error_message(bulk_discount.errors)}"
    end
  end

  def destroy
    BulkDiscount.find(bulk_discount_params[:id]).destroy
  end

  def edit
    @merchant = Merchant.find(bulk_discount_params[:merchant_id])
    @bulk_discount = BulkDiscount.find(bulk_discount_params[:id])
  end

  def update
    bulk_discount = BulkDiscount.find(bulk_discount_params[:id])
    bulk_discount.update(bulk_discount_params)
    if bulk_discount.save
      redirect_to merchant_bulk_discount_path(bulk_discount_params[:merchant_id], bulk_discount_params[:id])
    else
      redirect_to edit_merchant_bulk_discount_path(bulk_discount_params[:merchant_id], bulk_discount_params[:id])
      flash[:error] = "Error: #{error_message(bulk_discount.errors)}"
    end
  end

  private

  def bulk_discount_params
    params.permit(:quantity_thresh, :percentage, :merchant_id, :id)
  end

end