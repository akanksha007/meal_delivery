class FindRestaurantService

  def initialize(employee_ids)
    @employee_ids = employee_ids
  end

  def fetch_restaurants
    fetch_employees
    all_restaurant_id = fetch_restaurant_for_employee_preference
    fetch_selected_restaurant(all_restaurant_id)
  end

  private

  def fetch_employees
    @employees = Employee.where(id: @employee_ids)
    @employees_preference = @employees.distinct.pluck(:preference)
  end

  def fetch_restaurant_for_employee_preference
    Menu.where(tag: @employees_preference)
        .distinct.group(:restaurant_id).count(:tag)
  end

  def fetch_selected_restaurant(all_restaurant_id)
    selected_restaurant_ids = all_restaurant_id.select{|k, v| v >= @employees_preference.count}.keys
    Restaurant.where(id: selected_restaurant_ids)
  end
end
