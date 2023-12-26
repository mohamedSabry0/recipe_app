require 'rails_helper'

RSpec.describe 'Public recipes', type: :feature do
  describe 'Public recipe list' do
    let(:user) { FactoryBot.create(:user) }
    let(:user2) { FactoryBot.create(:user) }
    let(:recipes) { FactoryBot.create_list(:recipe, 3, user:, public: true) }
    let(:recipes2) { FactoryBot.create_list(:recipe, 3, user: user2, public: false) }
    let(:recipes3) { FactoryBot.create_list(:recipe, 3, user: user2, public: true) }

    before(:each) do
      user
      user2
      recipes
      recipes2
      recipes3
      visit '/users/sign_in'
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password
      click_button 'Log in'
      sleep(1)
      visit '/public_recipes'
    end

    it 'should display a list of all public recipes ordered by newest' do
      recipes.reverse.each_with_index do |recipe, index|
        expect(page).to have_selector(".card:nth-child(#{index + 1 + recipes.size}) h3.card-title", text: recipe.name)
      end

      expect(page).not_to have_content(recipes2.first.name)

      recipes3.reverse.each_with_index do |recipe, index|
        expect(page).to have_selector(".card:nth-child(#{index + 1}) h3.card-title", text: recipe.name)
      end
    end

    it 'should lead to recipe details' do
      click_link recipes.last.name
      expect(page).to have_content(recipes.last.name)
    end

    it 'should allow to delete it' do
      page.all(:button, 'Remove')[0].click
      sleep(1)
      page.driver.browser.switch_to.alert.accept if page.driver.browser.switch_to.alert.text == 'Are you sure?'
      expect(page).to have_content('Recipe was successfully deleted.')
    end

    it 'should not allow to delete it if not the owner' do
      expect(page).to have_selector(:button, 'Remove', count: 3)
      expect(page).not_to have_selector(:button, 'Remove', text: recipes2.first.name)
    end
  end
end
