class LunchController < ApplicationController
  before_action :set_employees, only: [:random_lunch, :paid_lunch]

  def index; end

  def random_lunch; end

  def create_random_lunch
    selected_employees_id = random_lunch_params['employee_ids'].map(&:to_i)
    @selected_restaurants = selected_restaurants(selected_employees_id)
  end

  def paid_lunch; end

  # Step 1) select the restaurant where employee preference is met.
  # Step 2) Of the selected restaurant find those restaurant that meet the pice
  # crietria.
  def create_paid_lunch
    @selected_restaurants = {}
    @final_cost = {}

    selected_employees_id = paid_lunch_params['employee_ids'].map(&:to_i)
    selected_restaurant_ids = selected_restaurants(selected_employees_id).pluck(:id)

    selected_restaurant_ids.each do |restaurant|
      fetch_total_cost_for_restaurant(restaurant, paid_lunch_params['price'].to_i)
    end
  end

  private

  def fetch_total_cost_for_restaurant(restaurant, price)
    total_cost = 0
    menu = []
    preference_count = @employees.group(:preference).count
    per_item_cost = Menu.where(restaurant_id: restaurant)
                        .where(tag: @employees_preference)
                        .group(:tag).minimum(:price)
    per_item_cost.each do |k, v|
      total_cost = preference_count[k] * v + total_cost
      menu.append(Menu.where(restaurant_id: restaurant)
        .where(tag: k).where(price: v).first)
    end
    append_restaurant_to_list(total_cost, price, restaurant, menu)
  end

  def append_restaurant_to_list(total_cost, price, restaurant, menu)
    if total_cost <= price
      @selected_restaurants[restaurant] = menu
      @final_cost[restaurant] = total_cost
    end
  end

  def selected_restaurants(selected_employees_id)
    fetch_employees(selected_employees_id)
    all_restaurant_id = fetch_restaurant_for_employee_preference
    fetch_selected_restaurant(all_restaurant_id)
  end

  def fetch_employees(selected_employees_id)
    @employees = Employee.where(id: selected_employees_id)
    @employees_preference = @employees.distinct.pluck(:preference)
  end

  # fetch restaurant_id and count of distinct tag served by the restaurant
  # for the given employee preference.
  def fetch_restaurant_for_employee_preference
    Menu.where(tag: @employees_preference)
        .distinct.group(:restaurant_id).count(:tag)
  end

  # select all the those restaurant for which the count is greater than
  # all employee preference.
  def fetch_selected_restaurant(all_restaurant_id)
    selected_restaurant_ids = all_restaurant_id.select{|k, v| v >= @employees_preference.count}.keys
    Restaurant.where(id: selected_restaurant_ids)
  end

  def set_employees
    @employees = Employee.all
  end

  def paid_lunch_params
    params.permit(:price, employee_ids: [])
  end

  def random_lunch_params
    params.permit(employee_ids: [])
  end
end
