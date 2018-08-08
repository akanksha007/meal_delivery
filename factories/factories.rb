FactoryGirl.define do
  factory :employee do
    name "test"
    address "test"
    preference "vegan"
  end

  factory :restaurant do
    name 'restaurant'
    address 'restaurant address'
  end

  factory :menu do
    name 'menu'
    price 100
    tag nil
    restaurant
  end
end
