require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe "Relationships" do
    it {should belong_to :item}
    it {should belong_to :invoice}
  end

  describe "Validations" do
    it {should validate_presence_of :quantity}
    it {should validate_presence_of :unit_price}
    it {should validate_presence_of :status}
  end

  describe 'Enums' do
    it 'enums tests' do
      should define_enum_for(:status).with_values(["pending", "packaged", "shipped"])
    end
  end

  before do
    @customer_1 = create(:customer)
    @customer_2 = create(:customer)
    @customer_3 = create(:customer)

    @invoice_1 = create(:invoice, customer_id: @customer_1.id)
    @invoice_2 = create(:invoice, customer_id: @customer_2.id)
    @invoice_3 = create(:invoice, customer_id: @customer_3.id)
    
    @merchant_1 = create(:merchant, name: "Amazon") 

    @item_1 = create(:item, unit_price: 1, merchant_id: @merchant_1.id)
    @item_2 = create(:item, unit_price: 1, merchant_id: @merchant_1.id)
    @item_3 = create(:item, unit_price: 1, merchant_id: @merchant_1.id)
   

    @invoice_item_1 = create(:invoice_item, item_id: @item_1.id, invoice_id: @invoice_1.id, quantity: 20, unit_price: 1300, status: 2)
    @invoice_item_2 = create(:invoice_item, item_id: @item_2.id, invoice_id: @invoice_2.id, quantity: 10, unit_price: 2534, status: 2)
    @invoice_item_3 = create(:invoice_item, item_id: @item_3.id, invoice_id: @invoice_3.id, quantity: 15, unit_price: 100, status: 2)

    @discount_1 = @merchant_1.bulk_discounts.create!(percentage: 0.10, quantity_thresh: 10, merchant_id: @merchant_1.id) 
    @discount_2 = @merchant_1.bulk_discounts.create!(percentage: 0.20, quantity_thresh: 15, merchant_id: @merchant_1.id) 
    @discount_3 = @merchant_1.bulk_discounts.create!(percentage: 0.30, quantity_thresh: 20, merchant_id: @merchant_1.id) 
  end

  describe "Instance Methods" do
    describe "#unit_price_to_dollars" do
      it "returns the unit price converted to dollars" do
        expect(@invoice_item_1.unit_price_to_dollars).to eq(13.00)
        expect(@invoice_item_2.unit_price_to_dollars).to eq(25.34)
      end
    end

    describe '#best_discount' do
      it 'returns the best discount available for the given invoice item' do
        expect(@invoice_item_1.best_discount).to eq(@discount_3)
        expect(@invoice_item_2.best_discount).to eq(@discount_1)
        expect(@invoice_item_3.best_discount).to eq(@discount_2)
      end
    end
  end
end
