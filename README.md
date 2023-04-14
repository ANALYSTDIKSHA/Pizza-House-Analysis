PIZZA HOUSE ANALYSIS

In this Project, We have performed Exploratory Data Analysis(EDA) on the Pizza House Dataset.
In order to extract correct analysis out of the dataset, We have performed necessary Data cleaning on the Dataset.



Key datasets for this case study------

runners : The table shows the registration_date for each new runner
customer_orders : Customer pizza orders are captured in the customer_orders table with 1 row for each individual pizza that is part of the order. The pizza_id relates to the type of pizza which was ordered whilst the exclusions are the ingredient_id values which should be removed from the pizza and the extras are the ingredient_id values which need to be added to the pizza.
runner_orders : After each orders are received through the system - they are assigned to a runner - however not all orders are fully completed and can be cancelled by the restaurant or the customer. The pickup_time is the timestamp at which the runner arrives at the Pizza Runner headquarters to pick up the freshly cooked pizzas. The distance and duration fields are related to how far and long the runner had to travel to deliver the order to the respective customer.
pizza_names : Pizza Runner only has 2 pizzas available the Meat Lovers or Vegetarian!
pizza_recipes : Each pizza_id has a standard set of toppings which are used as part of the pizza recipe.
pizza_toppings : The table contains all of the topping_name values with their corresponding topping_id value
