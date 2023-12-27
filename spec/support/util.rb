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
