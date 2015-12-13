require 'rails_helper'

describe SecretsController do
  let(:user) { create(:user) }
  let(:secret) { create(:secret, author: user) }
  
  describe 'GET #index' do
    before { create_list(:secret, 6) }
    it 'returns 5 secrets from the database' do
      get :index
      expect(assigns(:secrets).size).to eq(5)
    end
  end


  describe 'GET #show' do
    before { secret }

    it 'sets the correct secret to display' do
      get :show, id: secret.id
      expect(assigns(:secret)).to eq(secret)
    end
  end


  context 'signed in user' do
    before { session[:user_id] = user.id }
    before { secret }

    describe 'POST #create' do
      it 'creates a new secret' do
        expect { post :create, secret: attributes_for(:secret) 
               }.to change(Secret, :count).by(1)
      end


      it 'redirects to the new secret\'s show page' do
        post :create, secret: attributes_for(:secret) 
        expect(response).to redirect_to secret_path(assigns(:secret))
      end


      it 'sets the flash' do
        post :create, secret: attributes_for(:secret) 
        expect(flash[:notice]).to include('successfully')
      end


      it 'sets the current user as the author' do
        post :create, secret: attributes_for(:secret)
        expect(assigns(:secret).author).to eq(user)
      end


      it 're-renders the new secret form if invalid data is submitted' do
        post :create, secret: attributes_for(:secret, title: '')
        expect(response).to render_template :new
      end
    end


    describe 'PATCH #update' do
      let(:updated_title) { 'foos_big_secret' }

      it 'updates the secret' do
        patch :update, id: secret.id, secret: attributes_for(:secret, title: updated_title)
        secret.reload
        expect(secret.title).to eq(updated_title)
      end


      it 'redirects to the secret\'s show page' do
        patch :update, id: secret.id, secret: attributes_for(:secret, title: updated_title)
        expect(response).to redirect_to secret_path(assigns(:secret))        
      end


      it 'sets the flash' do
        post :create, secret: attributes_for(:secret) 
        expect(flash[:notice]).to include('successfully')
      end      


      it 're-renders the edit secret form if invalid data is submitted' do
        patch :update, id: secret.id, secret: attributes_for(:secret, title: '')
        expect(response).to render_template :edit
      end


      it 'gives an error if a user tries to update another user\'s secret' do
        another_secret = create(:secret)
        expect { patch :update, id: another_secret.id, 
                                secret: attributes_for(:secret, title: updated_title) 
               }.to raise_error(ActiveRecord::RecordNotFound)                

      end
    end


    describe 'DELETE #destroy' do
      it 'removes the secret from the database' do
        expect{ delete :destroy, id: secret.id }.to change(Secret, :count).by(-1)
      end


      it 'gives an error if a user tries to delete another user\'s secret' do
        another_secret = create(:secret)
        expect { delete :destroy, id: another_secret.id
               }.to raise_error(ActiveRecord::RecordNotFound)                
      end
    end
  end


  describe 'visitor/signed out user is redirected to the logon form on' do
    it 'GET #new' do
      get :new
      expect(response).to redirect_to new_session_path
    end


    it 'GET #edit' do
      get :edit, id: secret.id
      expect(response).to redirect_to new_session_path
    end


    it 'POST #create' do
      post :create, secret: attributes_for(:secret)
      expect(response).to redirect_to new_session_path
    end


    it 'PATCH #update' do
      patch :update, id: secret.id, secret: attributes_for(:secret)
      expect(response).to redirect_to new_session_path
    end


    it 'DELETE #destroy' do
      delete :destroy, id: secret.id
      expect(response).to redirect_to new_session_path
    end
  end

end