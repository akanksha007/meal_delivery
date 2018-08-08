class LunchController < ApplicationController
  before_action :set_employees, only: [:random_lunch, :paid_lunch]

  def index; end

  def random_lunch; end

  def create_random_lunch
    selected_employees_id = random_lunch_params['employee_ids'].map(&:to_i)
    @employees = Employee.where(id: selected_employees_id)
    @selected_restaurants = FindRestaurantService.new(selected_employees_id)
                            .fetch_restaurants
    if @selected_restaurants.blank?
      redirect_to random_lunch_path, notice: 'No restaurant meet the crietria'
    end
  end

  def paid_lunch; end


  def create_paid_lunch
    employee_ids = paid_lunch_params['employee_ids'].map(&:to_i)
    restaurant_ids  = FindRestaurantService.new(employee_ids)
                       .fetch_restaurants
                       .pluck(:id)
    if restaurant_ids.present?
      @menu = FetchMenuService.new({
                restaurant_ids: restaurant_ids,
                employee_ids: employee_ids,
                price: paid_lunch_params[:price]
              }).fetch_menu_for_restaurants
    end
    puts "menu is #{@menu}"
    if restaurant_ids.blank? || @menu.blank?
      redirect_to paid_lunch_path, notice: 'No restaurant meet the crietria.'
    end
  end

  private

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
