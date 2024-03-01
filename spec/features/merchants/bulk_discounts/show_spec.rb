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

    # User Story Solo 5: Merchant Bulk Discount Edit
    it 'shows a link to edit a bulk discount from the show page and when clicked, takes you to an edit page where all the previous information is populated, when subitted, takes you back to the show page and shows the newly edited attributes' do
      # As a merchant, when I visit my bulk discount show page
      visit merchant_bulk_discount_path(@merch_1, @discount_1)
      # Then I see a link to edit the bulk discount
      expect(page).to have_link("Edit Discount", href: edit_merchant_bulk_discount_path(@discount_1))
      # When I click this link
      click_link("Edit Discount")
      # Then I am taken to a new page with a form to edit the discount
      expect(current_path).to eq(edit_merchant_bulk_discount_path(@discount_1))
      # And I see that the discounts current attributes are pre-poluated in the form
      expect(page).to have_content(@discount_1.quantity_thresh)
      expect(page).to have_content(@discount_1.percentage)
      expect(page).to have_field("quantity_thresh")
      expect(page).to have_field("percentage")
      # When I change any/all of the information and click submit
      fill_in("percentage", with: 0.80)
      click_on "submit"
      # Then I am redirected to the bulk discount's show page
      expect(current_path).to eq(merchant_bulk_discount_path(@merch_1, @discount_1))
      # And I see that the discount's attributes have been updated
      expect(page).to have_content("Percentage - 80%")
    end
  end
end