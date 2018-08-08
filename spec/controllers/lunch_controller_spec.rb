require 'rails_helper'

RSpec.describe LunchController, type: :controller do
  let!(:employee_1) { FactoryGirl.create(:employee, name: 'test', address: 'park', preference: 'vegan') }
  let!(:employee_2) { FactoryGirl.create(:employee, name: 'test', address: 'park', preference: 'meat') }
  let!(:restaurant_1) { FactoryGirl.create(:restaurant, name: 'r1', address: 'address') }
  let!(:restaurant_2) { FactoryGirl.create(:restaurant, name: 'r2', address: 'address') }
  let!(:menu_restaurant_r1) { FactoryGirl.create(:menu, name: 'menu', tag: 'vegan', price: 5, restaurant_id: restaurant_1.id) }
  let!(:menu_restaurant_r2) { FactoryGirl.create(:menu, name: 'menu', tag: 'vegetarian', price: 5, restaurant_id: restaurant_2.id) }

  context 'random_lunch' do
    it "is success" do
      get :random_lunch
      expect(response.status).to eq(200)
    end

    it "selects restaurant for employees preference" do
      post :create_random_lunch, params: { 'employee_ids' => [employee_1.id] }
      expect(assigns(:selected_restaurants)).to include(restaurant_1)
      expect(assigns(:employees)).to include(employee_1)
    end

    it "redirects when employees preference does not match" do
      post :create_random_lunch, params: { 'employee_ids' => [employee_2.id] }
      expect(response).to redirect_to(random_lunch_path)
    end
  end

  context 'paid_lunch' do
    it "is success" do
      get :paid_lunch
      expect(response.status).to eq(200)
    end

    it "edirects when employees preference does not match" do
      post :create_paid_lunch, params: {employee_ids: [employee_2.id], price: 100 }
      expect(response).to redirect_to(paid_lunch_path)
      expect(request.flash[:notice]).to eq("No restaurant meet the crietria.")
    end

    it "selects restaurant for employees preference and price" do
      post :create_paid_lunch, params: {employee_ids: [employee_1.id], price: 100 }
      expect(assigns(:menu).keys).to include(restaurant_1.id)
      expect(assigns(:menu)[restaurant_1.id]).to include(menu_restaurant_r1)
    end
  end
end
