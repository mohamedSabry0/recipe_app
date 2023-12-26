require 'rails_helper'

RSpec.describe 'Inventories index', type: :feature do
  # Inventories list:

  # Should display a list of inventories created by the logged-in user as in the wireframe.
  # Should lead to inventory details.
  # If the user is the owner of the inventory, should allow to delete it.

  describe 'Inventories list' do
    let(:user) { FactoryBot.create(:user) }
    let(:inventory) { FactoryBot.create(:inventory, user:) }

    before(:each) do
      user
      inventory
      visit '/users/sign_in'
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password
      click_button 'Log in'
    end

    it 'should display a list of inventories created by the logged-in user' do
      expect(page).to have_content(inventory.name)
    end

    it 'should lead to inventory details' do
      sleep(1)
      click_link inventory.name
      expect(page).to have_content(inventory.name)
    end

    it 'should allow to delete it' do
      click_link 'Delete'
      sleep(1)
      page.driver.browser.switch_to.alert.accept if page.driver.browser.switch_to.alert.text == 'Are you sure?'
      expect(page).to have_content('Inventory was successfully deleted.')
    end
  end
end
