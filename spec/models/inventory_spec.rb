require 'rails_helper'

RSpec.describe Inventory, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:inventory_foods).dependent(:destroy) }
  end

  describe 'methods' do
    let(:user) { FactoryBot.create(:user) }
    let(:food) { FactoryBot.create(:food) }
    let(:inventory) { FactoryBot.create(:inventory, user:) }
    let(:inventory_food) { FactoryBot.create(:inventory_food, inventory:, food:) }

    before(:each) do
      user
      food
      inventory
      inventory_food
    end

    describe '#foods' do
      it 'should return all foods for an inventory' do
        expect(inventory.foods).to eq(inventory.inventory_foods.joins(:food).select('foods.*, inventory_foods.*'))
      end

      it 'should return fields including the correct ones' do
        expect(inventory.foods.first.attributes.keys).to include('name', 'quantity', 'price', 'id')
      end
    end
  end
end
