require 'rails_helper'

RSpec.describe 'Recipe index', type: :feature do
  # Recipes list:

  # Should display a list of recipes created by the logged-in user as in the wireframe.
  # Should lead to recipe details.

  describe 'Recipes list' do
    let(:user) { FactoryBot.create(:user) }
    let(:recipe) { FactoryBot.create(:recipe, user:) }

    before(:each) do
      user
      recipe
      visit '/users/sign_in'
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password
      click_button 'Log in'
      sleep(1)
      visit '/recipes'
    end

    it 'should display a list of recipes created by the logged-in user' do
      expect(page).to have_content(recipe.name)
    end

    it 'should lead to recipe details' do
      click_on recipe.name
      expect(page).to have_content(recipe.name)
    end

    it 'should allow to delete it' do
      click_on 'Remove'
      sleep(1)
      page.driver.browser.switch_to.alert.accept if page.driver.browser.switch_to.alert.text == 'Are you sure?'
      expect(page).to have_content('Recipe was successfully deleted.')
    end
  end
end
