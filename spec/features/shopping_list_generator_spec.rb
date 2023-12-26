require 'rails_helper'

RSpec.describe 'Shopping list generator', type: :feature do
  let(:user) { FactoryBot.create(:user) }
  let(:recipe) { FactoryBot.create(:recipe, user:) }
  let(:foods) { FactoryBot.create_list(:food, 4) }
  let(:recipe_food1) { FactoryBot.create(:recipe_food, recipe:, food: foods[0]) }
  let(:recipe_food2) { FactoryBot.create(:recipe_food, recipe:, food: foods[1]) }
  let(:recipe_food3) { FactoryBot.create(:recipe_food, recipe:, food: foods[2]) }
  let(:recipe_food4) { FactoryBot.create(:recipe_food, recipe:, food: foods[3]) }
  let(:inventory) { FactoryBot.create(:inventory, user:) }
  let(:inventory_food1) do
    FactoryBot.create(:inventory_food, inventory:, food: foods[0],
                                       quantity: recipe_food1.quantity)
  end
  let(:inventory_food2) do
    FactoryBot.create(:inventory_food, inventory:, food: foods[1],
                                       quantity: recipe_food2.quantity - 1)
  end
  let(:inventory_food3) do
    FactoryBot.create(:inventory_food, inventory:, food: foods[2],
                                       quantity: recipe_food3.quantity + 1)
  end

  before(:each) do
    user
    foods

    recipe
    recipe_food1
    recipe_food2
    recipe_food3
    recipe_food4

    inventory
    inventory_food1
    inventory_food2
    inventory_food3

    login_user(user)
  end

  def login_user(user)
    visit '/users/sign_in'
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    click_button 'Log in'
    wait_for_page_load
  end

  def wait_for_page_load
    expect(page).to have_content('Signed in successfully.')
  end

  describe 'Shopping list generator' do
    before(:each) do
      visit "/recipes/#{recipe.id}"
      click_on 'Create Shopping List'
      click_on 'Choose this inventory'
    end

    it 'should display a shopping list for a recipe' do
      expect(page).to have_content(recipe.name)
    end

    it 'Should display the name of the selected inventory' do
      expect(page).to have_content(inventory.name)
    end

    it 'should display totaly missing ingredients, their quantities, and their cost' do
      expect(page).to have_content(recipe_food4.food.name)
      expect(page).to have_content(recipe_food4.quantity)
      expect(page).to have_content(recipe_food4.food.price * recipe_food4.quantity)
    end

    it 'should display partially missing ingredients, their quantities, and their cost' do
      expect(page).to have_content(recipe_food2.food.name)
      expect(page).to have_content(recipe_food2.quantity - inventory_food2.quantity)
      expect(page).to have_content(recipe_food2.food.price * (recipe_food2.quantity - inventory_food2.quantity))
    end

    it 'should not display ingredients that are already in the inventory' do
      expect(page).not_to have_content(recipe_food1.food.name)
    end

    it 'should not display ingredients that are in the inventory but in a larger quantity than the recipe requires' do
      expect(page).not_to have_content(recipe_food3.food.name)
    end

    it 'should not display ingredients that are in the inventory in the exact quantity that the recipe requires' do
      expect(page).not_to have_content(recipe_food1.food.name)
    end

    it 'should contain total cost for all required ingrediants' do
      expect(page).to have_content(
        (recipe_food4.food.price * recipe_food4.quantity) +
        (recipe_food2.food.price * 1)
      )
    end
  end
end
