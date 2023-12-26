require 'rails_helper'

RSpec.describe 'Recipe Show Page', type: :feature do
  # recipe main functionality
  # as a user I want to see a recipe's name, description, and cooking time, preparing time
  # as a user I want to see a recipe's ingredients and their quantities
  # as a user I want to see a recipe's total cost
  # as a user I want to be able to add ingredients to a recipe
  # as a user I want to be able to remove ingredients from a recipe
  # test for several ingrediants

  let(:user) { FactoryBot.create(:user) }
  let(:food) { FactoryBot.create(:food) }
  let(:recipe) { FactoryBot.create(:recipe, user:) }
  let(:recipe_food) { FactoryBot.create(:recipe_food, recipe:, food:) }
  let(:recipe2) { FactoryBot.create(:recipe, user:) }
  let(:foods) { FactoryBot.create_list(:food, 3) }
  3.times do |index|
    let(:"recipe_food#{index}") { FactoryBot.create(:recipe_food, recipe: recipe2, food: foods[index]) }
  end

  before(:each) do
    user
    food
    recipe
    recipe_food
    recipe2
    foods
    3.times do |index|
      :"recipe_food#{index}"
    end
    visit '/users/sign_in'
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    click_button 'Log in'
    sleep(1)
  end
  describe 'Recipe Show Page: single ingrediant:' do
    before(:each) do
      visit "/recipes/#{recipe.id}"
    end
    it 'should display a recipe\'s name, description, and instructions' do
      expect(page).to have_content(recipe.name)
      expect(page).to have_content(recipe.description)
      expect(page).to have_content(recipe.cooking_time)
      expect(page).to have_content(recipe.preparation_time)
    end

    it 'should display a recipe\'s ingredients and their quantities' do
      expect(page).to have_content(recipe_food.food.name)
      expect(page).to have_content(recipe_food.quantity)
    end

    it 'should display a recipe\'s total cost' do
      expect(page).to have_content(recipe.total_cost)
    end

    it 'should allow to add ingredients to a recipe' do
      click_link 'Add ingredient'
      fill_in 'recipe_food_quantity', with: 1
      select food.name, from: 'recipe_food_food_id'
      click_button 'Add ingredient'
      expect(page).to have_content(food.name)
    end

    it 'should allow to remove ingredients from a recipe' do
      click_link 'Remove'
      expect(page).not_to have_content(recipe_food.food.name)
    end
  end

  describe 'Recipe Show Page: multiple ingrediants' do
    before(:each) do
      visit "/recipes/#{recipe2.id}"
    end
    it 'should display a recipe\'s name, description, and instructions' do
      expect(page).to have_content(recipe2.name)
      expect(page).to have_content(recipe2.description)
      expect(page).to have_content(recipe2.cooking_time)
      expect(page).to have_content(recipe2.preparing_time)
    end

    it 'should display a recipe\'s ingredients and their quantities' do
      3.times do |index|
        expect(page).to have_content(:"recipe_food#{index}".food.name)
        expect(page).to have_content(:"recipe_food#{index}".quantity)
      end
    end

    it 'should display a recipe\'s total cost' do
      expect(page).to have_content(recipe2.total_cost)
    end

    it 'should allow to add ingredients to a recipe' do
      click_link 'Add ingredient'
      fill_in 'recipe_food_quantity', with: 1
      select food.name, from: 'recipe_food_food_id'
      click_button 'Add ingredient'
      expect(page).to have_content(food.name)
    end

    it 'should allow to remove ingredients from a recipe' do
      click_link 'Remove'
      expect(page).not_to have_content(recipe_food.food.name)
    end
  end
end
