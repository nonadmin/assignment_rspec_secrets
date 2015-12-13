require 'rails_helper'

describe UsersController do
  let(:user) { create(:user) }

  it 'GET #new renders the new user form' do
    get :new
    expect(response).to render_template :new 
  end

  
  describe 'POST #create' do
    it 'redirects to the new user' do
      post :create, user: attributes_for(:user)
      expect(response).to redirect_to user_path(assigns(:user))
    end


    it 're-renders the new user form if submission is invalid' do
      post :create, user: attributes_for(:user, name: '')
      expect(response).to render_template :new
    end
  end

  context 'signed in user' do
    before :each do
      session[:user_id] = user.id
    end


    describe 'DELETE #destroy' do
      it 'allows the user to delete their own account' do
        expect{ delete :destroy, id: user.id }.to change(User, :count).by(-1)
      end
    

      it 'does not allow the user to delete other users accounts' do
        other_user = create(:user)
        expect{ delete :destroy, id: other_user.id }.not_to change(User, :count)
      end
    end


    describe 'PATCH #update' do
      let(:updated_name) { "the_new_foo" }

      it 'finds the specified user' do
        put :update, id: user.id, user: attributes_for(:user, name: updated_name)
        expect(assigns(:user)).to eq(user)
      end


      it 'redirects to the updated user' do
        put :update, id: user.id, user: attributes_for(:user, name: updated_name)
        expect(response).to redirect_to user_path(assigns(:user))
      end


      it 'actually updates the user' do
        put :update, id: user.id, user: attributes_for(:user, name: updated_name)
        user.reload
        expect(user.name).to eq(updated_name)
      end


      it 'does not allow the user to update another user\'s attributes' do
        other_user = create(:user)
        put :update, id: other_user.id, user: attributes_for(:user, name: updated_name)
        other_user.reload
        expect(other_user.name).not_to eq(updated_name)
        expect(response).to redirect_to root_path
      end
    end
  end
end