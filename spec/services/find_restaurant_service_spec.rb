require 'rails_helper'

RSpec.describe FindRestaurantService do
  let!(:employee_veg) { FactoryGirl.create(:employee, name: 'test', address: 'park', preference: 'vegetarian') }
  let!(:employee_vegan) { FactoryGirl.create(:employee, name: 'test', address: 'park', preference: 'vegan') }
  let!(:employee_meat) { FactoryGirl.create(:employee, name: 'test', address: 'park', preference: 'meat') }
  let!(:employee_fish) { FactoryGirl.create(:employee, name: 'test', address: 'park', preference: 'fish') }
  let!(:employee_chicken) { FactoryGirl.create(:employee, name: 'test', address: 'park', preference: 'chicken') }

  let!(:restaurant_1) { FactoryGirl.create(:restaurant, name: 'r1', address: 'address') }
  let!(:restaurant_2) { FactoryGirl.create(:restaurant, name: 'r2', address: 'address') }
  let!(:restaurant_3) { FactoryGirl.create(:restaurant, name: 'r3', address: 'address') }
  let!(:restaurant_4) { FactoryGirl.create(:restaurant, name: 'r4', address: 'address') }
  let!(:restaurant_5) { FactoryGirl.create(:restaurant, name: 'r5', address: 'address') }

  let!(:menu_vegan_r1) { FactoryGirl.create(:menu, name: 'menu', tag: 'vegan', price: 5, restaurant_id: restaurant_1.id) }
  let!(:menu_vegetarian_r1) { FactoryGirl.create(:menu, name: 'menu', tag: 'vegetarian', price: 5, restaurant_id: restaurant_1.id) }
  let!(:menu_meat_r1) { FactoryGirl.create(:menu, name: 'menu', tag: 'meat', price: 5, restaurant_id: restaurant_1.id) }
  let!(:menu_fish_r1) { FactoryGirl.create(:menu, name: 'menu', tag: 'fish', price: 5, restaurant_id: restaurant_1.id) }
  let!(:menu_chicken_r1) { FactoryGirl.create(:menu, name: 'menu', tag: 'chicken', price: 5, restaurant_id: restaurant_1.id) }

  let!(:menu_vegan_r2) { FactoryGirl.create(:menu, name: 'menu', tag: 'vegan', price: 5, restaurant_id: restaurant_2.id) }
  let!(:menu_vegetarian_r2) { FactoryGirl.create(:menu, name: 'menu', tag: 'vegetarian', price: 5, restaurant_id: restaurant_2.id) }
  let!(:menu_meat_r2) { FactoryGirl.create(:menu, name: 'menu', tag: 'meat', price: 5, restaurant_id: restaurant_2.id) }
  let!(:menu_fish_r2) { FactoryGirl.create(:menu, name: 'menu', tag: 'fish', price: 5, restaurant_id: restaurant_2.id) }

  let!(:menu_vegan_r3) { FactoryGirl.create(:menu, name: 'menu', tag: 'vegan', price: 5, restaurant_id: restaurant_3.id) }
  let!(:menu_vegetarian_r3) { FactoryGirl.create(:menu, name: 'menu', tag: 'vegetarian', price: 5, restaurant_id: restaurant_3.id) }
  let!(:menu_meat_r3) { FactoryGirl.create(:menu, name: 'menu', tag: 'meat', price: 5, restaurant_id: restaurant_3.id) }

  let!(:menu_vegan_r4) { FactoryGirl.create(:menu, name: 'menu', tag: 'vegan', price: 5, restaurant_id: restaurant_4.id) }
  let!(:menu_vegetarian_r4) { FactoryGirl.create(:menu, name: 'menu', tag: 'vegetarian', price: 5, restaurant_id: restaurant_4.id) }

  let!(:menu_vegan_r5) { FactoryGirl.create(:menu, name: 'menu', tag: 'vegan', price: 5, restaurant_id: restaurant_5.id) }

  describe 'fetch_restaurant' do

    it 'returns restaurant for all preference' do
      subject1 = described_class.new([employee_veg.id, employee_vegan.id, employee_meat.id, employee_fish.id, employee_chicken.id])
      restaurants = subject1.fetch_restaurants
      expect(restaurants).to eq([restaurant_1])
    end

    it 'return restaurants for 4 employee preference' do
      subject2 = described_class.new([employee_veg.id, employee_vegan.id, employee_meat.id, employee_fish.id])
      restaurants = subject2.fetch_restaurants
      expect(restaurants).to eq([restaurant_1, restaurant_2])
    end

    it 'return restaurant for 3 employee preference' do
      subject3 = described_class.new([employee_veg.id, employee_vegan.id, employee_meat])
      restaurants = subject3.fetch_restaurants
      expect(restaurants).to eq([restaurant_1, restaurant_2, restaurant_3])
    end

    it 'return restaurant for 2 employee preference' do
      subject4 = described_class.new([employee_veg.id, employee_vegan.id])
      restaurants = subject4.fetch_restaurants
      expect(restaurants).to eq([restaurant_1, restaurant_2, restaurant_3, restaurant_4])
    end

    it 'return restaurant for 1 employee preference' do
      subject5 = described_class.new([employee_vegan.id])
      restaurants = subject5.fetch_restaurants
      expect(restaurants).to eq([restaurant_1, restaurant_2, restaurant_3, restaurant_4, restaurant_5])
    end
  end
end
