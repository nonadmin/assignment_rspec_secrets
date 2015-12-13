require 'rails_helper'

feature 'Sign Up' do

  before do
    visit users_path
    click_link 'New User'
  end

  scenario 'succeeds with valid information' do 
    fill_in 'user_name', with: 'foobar'
    fill_in 'user_email', with: 'foobar@example.com'
    fill_in 'user_password', with: 'foobar'
    fill_in 'user_password_confirmation', with: 'foobar'
    expect{ click_button 'Create User' }.to change(User, :count).by(1)
    expect(page).to have_content 'Welcome'
    expect(page).to have_content 'successfully'
  end


  scenario 'fails with invalid information' do
    fill_in 'user_name', with: ''
    expect{ click_button 'Create User' }.not_to change(User, :count)
    expect(page).to have_content 'errors'
    expect(page).to have_content 'blank' 
  end

end


feature 'Sign In' do
  
  let(:user) { create(:user) }
  
  scenario 'succeeds with valid information' do
    sign_in(user)
    expect(page).to have_content 'Welcome'
    expect(page).to have_link 'Logout'
  end


  scenario 'fails with invalid information' do
    user.email = "nobody@example.com"
    sign_in(user)
    expect(current_path).to eq(session_path)
    expect(page).to have_button 'Log in'
  end
  

  feature 'Sign Out' do
    scenario 'signs out the user' do
      sign_in(user)
      sign_out
      expect(page).to have_link "Login"
    end
  end

end