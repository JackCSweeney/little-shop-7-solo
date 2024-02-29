require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
  describe 'validations' do
    it { should validate_presence_of :quantity_thresh }
    it { should validate_presence_of :percentage }
  end

  describe 'relationships' do
    it {should belong_to :merchant}
  end

  before (:each) do
    @merch_1 = create(:merchant, name: "Amazon")

    @discount_1 = @merch_1.bulk_discounts.create!(percentage: 0.10, quantity_thresh: 10, merchant_id: @merch_1.id) 
    @discount_2 = @merch_1.bulk_discounts.create!(percentage: 0.20, quantity_thresh: 15, merchant_id: @merch_1.id) 
    @discount_3 = @merch_1.bulk_discounts.create!(percentage: 0.30, quantity_thresh: 20, merchant_id: @merch_1.id) 
  end

  describe 'instance methods' do
    describe '#display_percentage' do
      it 'formats the decimal percentage to a percentage' do
        expect(@discount_1.display_percentage).to eq(10.0)
        expect(@discount_2.display_percentage).to eq(20.0)
        expect(@discount_3.display_percentage).to eq(30.0)
      end
    end
  end
end