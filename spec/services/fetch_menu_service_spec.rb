require 'rails_helper'

RSpec.describe FetchMenuService do
  let!(:employee_vegan) { FactoryGirl.create(:employee, name: 'test', address: 'park', preference: 'vegan') }
  let!(:employee_veg) { FactoryGirl.create(:employee, name: 'test', address: 'park', preference: 'vegetarian') }
  let!(:employee_meat) { FactoryGirl.create(:employee, name: 'test', address: 'park', preference: 'meat') }
  let!(:employee_fish) { FactoryGirl.create(:employee, name: 'test', address: 'park', preference: 'fish') }
  let!(:employee_chicken) { FactoryGirl.create(:employee, name: 'test', address: 'park', preference: 'chicken') }

  let!(:restaurant_1) { FactoryGirl.create(:restaurant, name: 'r1', address: 'address') }
  let!(:restaurant_2) { FactoryGirl.create(:restaurant, name: 'r2', address: 'address') }
  let!(:restaurant_3) { FactoryGirl.create(:restaurant, name: 'r3', address: 'address') }
  let!(:restaurant_4) { FactoryGirl.create(:restaurant, name: 'r4', address: 'address') }
  let!(:restaurant_5) { FactoryGirl.create(:restaurant, name: 'r5', address: 'address') }

  let!(:menu_vegan_r1) { FactoryGirl.create(:menu, name: 'menu', tag: 'vegan', price: 100, restaurant_id: restaurant_1.id) }
  let!(:menu_vegetarian_r1) { FactoryGirl.create(:menu, name: 'menu', tag: 'vegetarian', price: 100, restaurant_id: restaurant_1.id) }
  let!(:menu_meat_r1) { FactoryGirl.create(:menu, name: 'menu', tag: 'meat', price: 100, restaurant_id: restaurant_1.id) }
  let!(:menu_fish_r1) { FactoryGirl.create(:menu, name: 'menu', tag: 'fish', price: 100, restaurant_id: restaurant_1.id) }
  let!(:menu_chicken_r1) { FactoryGirl.create(:menu, name: 'menu', tag: 'chicken', price: 100, restaurant_id: restaurant_1.id) }

  let!(:menu_vegan_r2) { FactoryGirl.create(:menu, name: 'menu', tag: 'vegan', price: 200, restaurant_id: restaurant_2.id) }
  let!(:menu_vegetarian_r2) { FactoryGirl.create(:menu, name: 'menu', tag: 'vegetarian', price: 200, restaurant_id: restaurant_2.id) }
  let!(:menu_meat_r2) { FactoryGirl.create(:menu, name: 'menu', tag: 'meat', price: 200, restaurant_id: restaurant_2.id) }
  let!(:menu_fish_r2) { FactoryGirl.create(:menu, name: 'menu', tag: 'fish', price: 200, restaurant_id: restaurant_2.id) }

  let!(:menu_vegan_r3) { FactoryGirl.create(:menu, name: 'menu', tag: 'vegan', price: 300, restaurant_id: restaurant_3.id) }
  let!(:menu_vegetarian_r3) { FactoryGirl.create(:menu, name: 'menu', tag: 'vegetarian', price: 300, restaurant_id: restaurant_3.id) }
  let!(:menu_meat_r3) { FactoryGirl.create(:menu, name: 'menu', tag: 'meat', price: 300, restaurant_id: restaurant_3.id) }

  let!(:menu_vegan_r4) { FactoryGirl.create(:menu, name: 'menu', tag: 'vegan', price: 400, restaurant_id: restaurant_4.id) }
  let!(:menu_vegetarian_r4) { FactoryGirl.create(:menu, name: 'menu', tag: 'vegetarian', price: 400, restaurant_id: restaurant_4.id) }

  let!(:menu_vegan_r5) { FactoryGirl.create(:menu, name: 'menu', tag: 'vegan', price: 500, restaurant_id: restaurant_5.id) }

  describe 'fetch_menu_for_restaurants' do
    it "filters restaurants that match price criteria" do
      params  = { restaurant_ids: [restaurant_1.id, restaurant_2.id, restaurant_3.id, restaurant_4.id],
                  employee_ids: [employee_vegan.id, employee_veg.id],
                  price: '500'
                }
      subject1 = described_class.new(params)
      menu = subject1.fetch_menu_for_restaurants
      expect(menu.keys).to eq([restaurant_1.id, restaurant_2.id])
    end
    # Hence all the subsequent combinations of test cases can be written.
  end
end
