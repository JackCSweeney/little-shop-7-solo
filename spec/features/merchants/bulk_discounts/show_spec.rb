require 'rails_helper'

RSpec.describe 'Merchant Bulk Discount Show Page', type: :feature do
  describe 'As a merchant' do
    before(:each) do
      @merch_1 = create(:merchant, name: "Amazon")

      @discount_1 = @merch_1.bulk_discounts.create!(percentage: 0.10, quantity_thresh: 10, merchant_id: @merch_1.id) 
      @discount_2 = @merch_1.bulk_discounts.create!(percentage: 0.20, quantity_thresh: 15, merchant_id: @merch_1.id) 
      @discount_3 = @merch_1.bulk_discounts.create!(percentage: 0.30, quantity_thresh: 20, merchant_id: @merch_1.id) 
    end

    # User Story Solo 4: Merchant Bulk Discount Show
    it 'shows ' do
      # As a merchant, when I visit my bulk discount show page
      visit merchant_bulk_discount_path(@merch_1, @discount_1)
      # Then I see the bulk discount's quantity threshold and percentage discount
      expect(page).to have_content("Discount ##{@discount_1.id}")
      expect(page).to have_content("Quantity Threshold - #{@discount_1.quantity_thresh}")
      expect(page).to have_content("Percentage - 10.0%")
    end
  end
end