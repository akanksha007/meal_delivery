module LunchHelper
  def fetch_restaurant(restaurant_id)
    Restaurant.find(restaurant_id)
  end
end
