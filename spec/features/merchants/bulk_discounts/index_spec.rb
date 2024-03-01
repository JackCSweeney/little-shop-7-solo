require 'rails_helper'

RSpec.describe 'Merchant Bulk Discounts Index', type: :feature do
  describe 'As a merchant' do
    before(:each) do
      @merch_1 = create(:merchant, name: "Amazon")

      @discount_1 = @merch_1.bulk_discounts.create!(percentage: 0.10, quantity_thresh: 10, merchant_id: @merch_1.id) 
      @discount_2 = @merch_1.bulk_discounts.create!(percentage: 0.20, quantity_thresh: 15, merchant_id: @merch_1.id) 
      @discount_3 = @merch_1.bulk_discounts.create!(percentage: 0.30, quantity_thresh: 20, merchant_id: @merch_1.id) 
    end

    # User Story Solo 3: Merchant Bulk Discount Delete
    it 'has a button to delete each bulk discount from the merchant bulk discounts index page' do
      # As a merchant, when I visit my bulk discounts index
      visit merchant_bulk_discounts_path(@merch_1)
      # Then next to each bulk discount I see a button to delete it
      within "#bulk_discounts" do
        within "#discount_#{@discount_1.id}" do
          expect(page).to have_button("Delete Discount")
        end

        within "#discount_#{@discount_2.id}" do
          expect(page).to have_button("Delete Discount")
        end

        within "#discount_#{@discount_3.id}" do
          expect(page).to have_button("Delete Discount")
        end
        # When I click this button
        # Then I am redirected back to the bulk discounts index page
        within "#discount_#{@discount_1.id}" do
          click_on "Delete"
        end
      end
      # And I no longer see the discount listed      
      expect(page).not_to have_content("Discount ##{@discount_1.id}")
    end

  end
end