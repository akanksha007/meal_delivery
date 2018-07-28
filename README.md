# Meal Delivery

To build internal team-lunch system to provide its employees with
the ability to schedule lunches with each other at restaurants around the office that
accommodate their dietary needs.

### Db structure.
Database used: MySql. <br>
Table Structure
1) employees - `id` `name` `preference` `address` `created_at` `updated_at`
2) restaurants - `id` `name` `address` `created_at` `updated_at`
3) menus - `id` `name` `tag` `price` `restaurant_id`(foreign_key wrt restaurants) `created_at` `updated_at`

`restaurants has_many menus`.


### Functionality

1) CRUD: employee <br>
all operation performed on `employees` table. <br>
URL : `BASE_URL/employees`

2) CRUD: restaurants <br>
all operation performed on `restaurants` table. <br>
URL: `BASE_URL/restaurants`.

3) Random Lunch: <br>
URL: `BASE_URL/random_lunch` <br>

  This assumes menu item is already created. <br>
  a) get request with all employees from the company. Currently pagination or optimisation techniques have not been used. <br>
  b) edit the employee preference - for any employee the preference and any other details can be edited. <br>
  c) select the employees <br>
  This will create a post request with employee_id as params.
  Steps to find the restaurant that meet the criteria.
  A query is fired to mysql<br>

    SELECT COUNT(DISTINCT `menus`.`tag`) AS count_id,
    `menus`.`restaurant_id` AS menus_restaurant_id FROM `menus` WHERE`menus`.`tag` IN (all_selected_employee_preference)
    GROUP BY `menus`.`restaurant_id`

  -> This will give all restaurants that will serve atleast 1 of the all_selected_employee_preference where count represent how many of the all_selected_employee_preference is met. <br>
  -> choose those preference for which the count >= all_selected_employee_preference.count

4) Paid Luch: <br>
  URL: BASE_URL/paid_lunch <br>
  - Select the restaurant the meets the criteria of preference. This is found similar to that of random lunch.<br>
  - Of the selected restaurant find the restaurant that meet the price crietria. <br>
    * iterate once for all selected_employee_preference <br>
    * given selected restaurant for the given prefernce find the min price item. <br>
    i.e. for preference `fish` find item_price that is min.
    * `total_cost = total_cost + item_price * employee_who_preferred_fish.count`
    * compare if total_cost is less than price if yes add restaurant and menu item to list.

### Assumptions & Improvements.

1) Currently no provision to add admin.
2) No login functionality.
3) Menu cannot be added.
4) Vaidation for paid and random_lunch not done. i.e. What if no restaurant meet the crietria.
5) Currently for paid_luch for each restaurnt only one combination of menu item is provided.
i.e. for a given restaurant and preference select the min price dish.
There can lot of combinations on dish. The quantity of dish can split.
eg. If 4 employee have `fish` as the preference. For a given restaurant 4 fish item can be split to 4 different menus based on price and henceforth.
6) No functionality to save the selected group for future reference.
7) Git commits not organised everything committed in one single go. Could have been broken into separate smaller commits as and when development progressed.
8) Create a seed file for populating the db. This is more like a future plan.
9) Deploy on heroku or AWS - More like a future plan.


### Optimizations
1) Pagination while displaying employees and restaurants.
2) Random lunch - currently all the restaurants that meets atleast one preference is selected and then filtered. This is costly operation. Would be ideal to select only those restaurants the meet the `preference` crietria.
3) Paid Lunch - For a large set of employee this is a costly operation to do it in request response cycle. Ideally would be better to delegate this to background considering implementation of `point 5 in Assumptions & improvements`. How can this be done is:
1) short polling- Client makes a request to the server to start a task ie(get various combination of restaurant and menu for selected employee), and a response is returned immediately. Then, the client makes another request to the server to see if the task is done. Based on the status of the task, the client will either wait a few seconds to check status again, or continue execution.
2) web sockets - a persistent connection between a client and server is established and both parties can use the connection to send data at any time.


To implement the functionality wrt to paid lunch with short polling, the client needs to:

1) Dispatch an action to change a variable in the state so that loading spinner is displayed.
2) Call an api endpoint to queue a background job.
Every few seconds, call another api endpoint to see if that background job is done.
3) If it’s done, dispatch action to change a variable in the state so that success message is shown.

Thus, in the backend, we need:

Two api endpoints (one for enqueuing job and one for getting job status).
A background job itself.
A way of storing the status of the job.
