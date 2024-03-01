require 'rails_helper'

RSpec.describe 'Merchant Bulk Discounts New Page', type: :feature do
  describe 'As a Merchant' do
    before(:each) do
      @merch_1 = create(:merchant, name: "Amazon")
    end
    # User story solo #2: Merchant Bulk Discount Create
    it 'has a link to create a new bulk discount from the bulk discount index and when used, will add a new bulk discount to the merchants bulk discount index page if all data is input correctly' do
      # As a merchant, when I visit my bulk discounts index
      visit merchant_bulk_discounts_path(@merch_1)
      # Then I see a link to create a new discount
      expect(page).to have_link("Create New Bulk Discount", href: new_merchant_bulk_discount_path(@merch_1))
      # When I click this link
      click_link "Create New Bulk Discount"
      # Then I am taken to a new page where I see a form to add a new bulk discount
      expect(page).to have_field("quantity_thresh")
      expect(page).to have_field("percentage")
      # When I fill in the form with valid data
      fill_in("quantity_thresh", with: 15)
      fill_in("percentage", with: 0.35)
      click_on "Save"

      # Then I am redirected back to the bulk discount index
      # And I see my new bulk discount listed     
      expect(current_path).to eq(merchant_bulk_discounts_path(@merch_1))
      within "#bulk_discounts" do
        expect(page).to have_content("Discount ##{@merch_1.bulk_discounts[0].id}: Quantity - 15, Discount - 35.0%")
      end
    end

    # add sad path for percentage being 100% or higher as invalid
    it 'has a sad path flash message for empty fields' do
      visit new_merchant_bulk_discount_path(@merch_1)

      fill_in("quantity_thresh", with: 15)
      click_on "Save"
      
      within "#flash" do
        expect(page).to have_content("Error: Percentage can't be blank")
      end
      expect(page).to have_field("quantity_thresh")
      expect(page).to have_field("percentage")
    end
  end
end