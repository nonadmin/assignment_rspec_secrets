require 'rails_helper'

describe User do
  let(:user){ build(:user) }

  it "is valid with a name, email, and password" do
    expect(user).to be_valid
  end


  it "is invalid without a name" do
    user.name = ""
    expect(user).not_to be_valid
  end


  it "is invalid without an email" do
    user.email = ""
    expect(user).not_to be_valid
  end


  it "is invalid with a name that is too short" do
    user.name = "a" * 2
    expect(user).not_to be_valid
  end


  it "is invalid with a name that is too long" do
    user.name = "a" * 21
    expect(user).not_to be_valid
  end 


  it "is invalid with a password that is too short" do
    user.password = "a" * 5
    expect(user).not_to be_valid
  end


  it "is invalid with a password that is too long" do
    user.password = "a" * 17
    expect(user).not_to be_valid
  end


  it "responds to the secrets association" do
    expect(user).to respond_to(:secrets)
  end
  

  describe "when saving multiple users" do
    before do
      user.save!
    end
    it "is invalid with a duplicate email" do
      new_user = build(:user, email: user.email)
      expect(new_user).not_to be_valid
    end
  end 

end