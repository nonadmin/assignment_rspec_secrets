FactoryGirl.define do

  factory :user, aliases: [:author] do
    sequence(:name) { |n| "Foo#{n}" }
    email { "#{name}@example.com".downcase }
    password { "foobar" }
  end
  

  factory :secret do
    title { "test title" }
    body { "test body" }
    author
  end

end 