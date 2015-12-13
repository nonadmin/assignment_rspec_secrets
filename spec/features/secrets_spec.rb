require 'rails_helper'

feature 'Secrets' do

  let(:user) { create(:user) }
  let!(:secret) { create(:secret, author: user) }

  context 'visitor/not signed in' do

    feature 'Listing (Index)' do
      scenario 'hides authors' do
        visit secrets_path
        expect(page).to have_content '**hidden**'
      end
    end

  end

  context 'signed in user' do

    before do
      sign_in(user)
    end

    feature 'Listing (Index)' do
      scenario 'shows authors' do
        visit secrets_path
        expect(page).not_to have_content '**hidden**'
        expect(page.find('tr', text: secret.title)).to have_content(user.name)
      end
    end


    feature 'Create' do
      scenario 'succeeds with valid content' do
        visit secrets_path
        click_link 'New Secret'
        fill_in 'secret_title', with: 'my secret'
        fill_in 'secret_body', with: 'im always angry'
        expect{click_button 'Create Secret'}.to change(Secret, :count).by(1)
        expect(page).to have_content 'successfully'
      end


      scenario 'fails with invalid content' do
        visit secrets_path
        click_link 'New Secret'
        fill_in 'secret_title', with: '!'
        expect{click_button 'Create Secret'}.not_to change(Secret, :count)
        expect(page).to have_content 'errors prohibited'
      end
    end


    feature 'Edit' do
      scenario 'link should only appear for secrets created by user' do
        create(:secret)
        visit secrets_path
        expect(page).to have_link('Edit', count: 1)
      end


      scenario 'succeeds with valid content' do
        visit secrets_path
        click_link 'Edit'
        fill_in 'secret_title', with: 'the hulks secret'
        fill_in 'secret_body', with: 'he is always angry'
        click_button 'Update Secret'
        secret.reload
        expect(secret.title).to eq('the hulks secret')
        expect(page).to have_content 'successfully'
      end


      scenario 'fails with invalid content' do
        original_title = secret.title
        visit secrets_path
        click_link 'Edit'
        fill_in 'secret_title', with: ''
        fill_in 'secret_body', with: '!'
        click_button 'Update Secret'
        secret.reload
        expect(secret.title).to eq(original_title)
        expect(page).to have_content 'errors prohibited'
      end      
    end


    feature 'Delete' do
      scenario 'link should only appear for secrets created by user' do
        create(:secret)
        visit secrets_path
        expect(page).to have_link('Destroy', count: 1)
      end


      scenario 'removes the users secret' do
        visit secrets_path
        expect{ click_link 'Destroy' }.to change(Secret, :count).by(-1)
      end
    end    

  end

end
