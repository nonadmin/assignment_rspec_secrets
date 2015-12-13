require 'rails_helper'

describe Secret do
  let(:secret) { build(:secret) }

  it "should be valid with a author, title, and body" do
    expect(secret).to be_valid
  end


  it "should be invalid without a title" do
    secret.title = ""
    expect(secret).not_to be_valid
  end


  it "should be invalid without a body" do
    secret.body = ""
    expect(secret).not_to be_valid
  end

  
  it "should be invalid with a title that is too short" do
    secret.title = "a" * 3
    expect(secret).not_to be_valid
  end

  
  it "should be invalid with a title that is too long" do
    secret.title = "a" * 25
    expect(secret).not_to be_valid
  end

  
  it "should be invalid with a body that is too short" do
    secret.body = "a" * 3
    expect(secret).not_to be_valid
  end
  
  
  it "should be invalid with a body that is too long" do
    secret.body = "a" * 141
    expect(secret).not_to be_valid
  end


  describe 'Author associations' do
    before do
      secret.save!
    end
    it "linking a valid Author succeeds" do
      new_author = create(:user)
      secret.author = new_author
      expect(secret).to be_valid
    end
    it 'linking to a non-existent Author fails' do
      secret.author_id = 1337
      expect(secret).not_to be_valid
    end
  end


  describe '#last_five' do
    let(:secret_count){ 6 }

    before do
      create_list(:secret, secret_count)
    end

    it 'returns the last five secrets' do
      expect(Secret.last_five.size).to eq(5)
    end
  end

end