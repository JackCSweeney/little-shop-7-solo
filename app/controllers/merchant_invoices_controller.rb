class MerchantInvoicesController < ApplicationController
  def index
    @invoices = Merchant.find(params[:merchant_id]).invoices
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @invoice = Invoice.find(params[:id])
  end
end