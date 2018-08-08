class FetchMenuService

  attr_reader :restaurant_ids, :employee_ids, :price, :employees_preference,
    :preference_count

  def initialize(params)
    @restaurant_ids = params[:restaurant_ids]
    @employee_ids = params[:employee_ids]
    @price = params[:price].to_i
    @employees_preference = fetch_employees_preference
    @preference_count = fetch_employees_preference_count
  end

  def fetch_menu_for_restaurants
    selected_restaurants_menu = {}
    restaurant_ids.each do |restaurant|
      per_item_cost = fetch_per_item_cost(restaurant)
      total_cost = fetch_total_cost_for_restaurant(per_item_cost)
      if total_cost <= price
        selected_restaurants_menu[restaurant] = find_menu_for_restaurant(restaurant, per_item_cost)
      end
    end
    selected_restaurants_menu
  end

  private

  def fetch_total_cost_for_restaurant(per_item_cost)
    total_cost = 0
    per_item_cost.each do |k, v|
      total_cost = preference_count[k] * v + total_cost
    end
    total_cost
  end

  def find_menu_for_restaurant(restaurant_id, per_item_cost)
    menu = []
    per_item_cost.each do |k, v|
      menu.append(Menu.where(restaurant_id: restaurant_id)
        .where(tag: k).where(price: v).first)
    end
    menu
  end

  def fetch_per_item_cost(restaurant_id)
    Menu.where(restaurant_id: restaurant_id)
      .where(tag: employees_preference)
      .group(:tag).minimum(:price)
  end

  def fetch_employees_preference
    Employee.where(id: employee_ids).distinct.pluck(:preference)
  end

  def fetch_employees_preference_count
    Employee.where(id: employee_ids).group(:preference).count
  end
end
