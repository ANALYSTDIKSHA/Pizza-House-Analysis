# DATA CLEANING ON PIZZA RECIPES TABLE
# select * from pizza_recipes ;

Drop table if exists pizza_recipes_temp ;

create TEMPORARY TABLE pizza_recipes_temp as 
select r.pizza_id , trim(j.topping) as topping
from pizza_recipes as r
join json_table(trim(replace(json_array(r.toppings), ',' , '","' )) , '$[*]' columns (topping varchar(50) path '$')) as j ;

select * from pizza_recipes_temp ;


# DATA CLEANING ON CUSTOMER_ORDERS_TEMP TABLE
#select * from customer_orders_temp ;

drop table if exists customer_orders_temp_cleaned ;

create TEMPORARY TABLE customer_orders_temp_cleaned as
select c.order_id,
		c.customer_id ,
        c.pizza_id,
        c.order_time,
        trim(j1.exclusion) as exclusion ,
        trim(j2.extra) as extra
from customer_orders_temp as c
join json_table(trim(replace(json_array(c.exclusions) , ',' , '","' )) , '$[*]' columns(exclusion varchar(50) path '$')) as j1 
join json_table(trim(replace(json_array(c.extras), ',' , '","' )) , '$[*]' columns(extra varchar(50) path '$') ) as j2 ;

select * from customer_orders_temp_cleaned ;

# combining ingredients for each pizza
drop table if exists standard_ingredients ;

CREATE
TEMPORARY TABLE standard_ingredients AS
SELECT pizza_id,
       pizza_name,
       group_concat(DISTINCT topping_name) as 'standard_ingredients'
FROM pizza_recipes_temp as a
INNER JOIN pizza_names USING (pizza_id)
INNER JOIN pizza_toppings on pizza_toppings.topping_id = a.topping
GROUP BY pizza_name,pizza_id
ORDER BY pizza_id;

SELECT *
FROM standard_ingredients;




# What are the standard ingredients for each pizza?
SELECT *
FROM standard_ingredients;

# What was the most commonly added extra?
select t.topping_name , count(extra) as total
from customer_orders_temp_cleaned as c
join pizza_toppings as t
on c.extra= t.topping_id
group by t.topping_name 
order by total desc limit 1  ;


# What was the least commonly added extra?
select t.topping_name , count(extra) as total
from customer_orders_temp_cleaned as c
join pizza_toppings as t
on c.extra= t.topping_id
group by t.topping_name 
order by total asc limit 1  ;


# What was the most common exclusion?
select t.topping_name , count(exclusion) as total
from customer_orders_temp_cleaned as c
join pizza_toppings as t
on c.exclusion= t.topping_id
group by t.topping_name 
order by total desc limit 1  ;


# If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes -
# how much money has Pizza Runner made so far if there are no delivery fees?
select sum(
	case when pizza_id = 1 then 12 
		when pizza_id =2 then 10
	end) as total_amount
from customer_orders_temp as c
join runner_orders_temp as r
on c.order_id= r.order_id
where r.cancellation is null ;