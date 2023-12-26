require 'rails_helper'

RSpec.describe Recipe, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:recipe_foods).dependent(:destroy) }
  end

  describe 'methods' do
    let(:user) { FactoryBot.create(:user) }
    let(:food) { FactoryBot.create(:food) }
    let(:recipe) { FactoryBot.create(:recipe, user:, public: true) }
    let(:recipe_food) { FactoryBot.create(:recipe_food, recipe:, food:) }

    before(:each) do
      user
      food
      recipe
      recipe_food
    end

    describe '#foods' do
      it 'should return all foods for a recipe' do
        expect(recipe.foods).to eq(recipe.recipe_foods.joins(:food).select('foods.*, recipe_foods.*'))
      end

      it 'should return the correct fields' do
        expect(recipe.foods.first.attributes.keys).to include('name', 'quantity', 'price', 'id')
      end
    end

    describe '#toggle_public' do
      it 'should toggle the public attribute' do
        expect(recipe.public).to eq(true)
        recipe.toggle_public
        expect(recipe.public).to eq(false)
      end
    end
  end
end
