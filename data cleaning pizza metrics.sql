## DATA CLEANING ##

# CUSTOMER_ORDERS TABLE 
SELECT * FROM pizza_runner.customer_orders;

DROP TABLE IF EXISTS customer_orders_temp ;

create TEMPORARY TABLE customer_orders_temp as
select order_id,customer_id,pizza_id ,order_time ,
case when exclusions REGEXP 'null' then NULL 
	when exclusions like '' then NULL 
	else exclusions
end as exclusions,
case when extras like 'null' then NULL 
	when extras like '' then NULL 
	else extras
end as extras
from customer_orders ;

select * from customer_orders_temp
order by customer_id ;



# RUNNER_ORDERS TABLE #
DROP TABLE IF EXISTS runner_orders_temp;

CREATE TEMPORARY TABLE runner_orders_temp AS

SELECT order_id,
       runner_id,
       CASE
           WHEN pickup_time LIKE 'null' THEN NULL
           ELSE pickup_time
       END AS pickup_time,
       CASE
           WHEN distance LIKE 'null' THEN NULL
           ELSE CAST(regexp_replace(distance, '[a-z]+', '') AS FLOAT)
       END AS distance,
       CASE
           WHEN duration LIKE 'null' THEN NULL
           ELSE CAST(regexp_replace(duration, '[a-z]+', '') AS FLOAT)
       END AS duration,
       CASE
           WHEN cancellation LIKE '' THEN NULL
           WHEN cancellation LIKE 'null' THEN NULL
           ELSE cancellation
       END AS cancellation
FROM runner_orders;

SELECT * FROM runner_orders_temp;



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