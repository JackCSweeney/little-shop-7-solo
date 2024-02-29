require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
  describe 'validations' do
    it { should validate_presence_of :quantity_thresh }
    it { should validate_presence_of :percentage }
  end

  describe 'relationships' do
    it {should belong_to :merchant}
  end

  describe 'instance methods' do
  end
end