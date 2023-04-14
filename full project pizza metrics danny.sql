select * from customer_orders ;


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


# DATA ANALYSIS
# total no. of pizzas ordered
select count(*)
from customer_orders ;

# total no. of pizzas ordered ech day using extract function
select *, count(*) , extract(DAY from order_time) as date 
from customer_orders
group by date ;

# total no. of pizzas ordered ech day
select *, count(*) , day(order_time) as date 
from customer_orders
group by date ;

# total no. of pizzas ordered each hour in a day
select order_id , count(*) , extract(HOUR from order_time) as hours ,day(order_time) as date 
from customer_orders
group by date,hours ;

# total no. of pizzas ordered by each customer
select *,count(*) as "total_pizzas"
from customer_orders
group by customer_id
order by total_pizzas desc ;

# How many unique customer orders were made?
select count(distinct order_id )
from customer_orders ;

# How many successful orders were delivered ?
SELECT * FROM pizza_runner.runner_orders_temp;
select count(*)
from runner_orders_temp
where cancellation is null  ;

# # How many successful orders were delivered by each runner ?
select * ,count(*)
from runner_orders_temp
where cancellation is null 
group by runner_id ;

# how many orders got cancelled for each runner ?
select runner_id,count(*)
from runner_orders_temp 
where cancellation is not null
group by runner_id ;

# average time each runner takes to deliver the order ?
select runner_id,avg(duration)
from runner_orders_temp
group by runner_id ;

# How many of each type of pizza was delivered?
select pizza_id,count(*)
from customer_orders 
group by pizza_id ;

# How many Vegetarian and Meatlovers were ordered by each customer?
select customer_id , pizza_id ,count(*)
from customer_orders
group by customer_id , pizza_id
order by customer_id ;

# How many pizzas delivered in a single order ?
select *,count(*)
from customer_orders
group by order_id ;

#What was the maximum number of pizzas delivered in a single order?
select *,count(*) as pizzas_each_order
from customer_orders
group by order_id 
order by pizzas_each_order desc limit 1;

# maximum no. of pizzas using cte
with cte1 as(select *,count(*) as pizzas_each_order
from customer_orders
group by order_id )
select max(pizzas_each_order) from cte1  ;

#  how many pizzas had at least 1 change ?
select count(*)
from customer_orders_temp
where exclusions is not null OR extras is not null ;

# For each customer, how many pizzas had at least 1 change ?
select customer_id , count(*) as number_of_pizzas
from customer_orders_temp
where exclusions is not null or extras is not null
group by customer_id ;

# For each customer, how many pizzas had at least 1 change and how many had no changes?
select customer_id,
case when exclusions is null and extras is null then count(*)
end as no_change ,
case when exclusions is not null or extras is not null then count(*)
end as new_change 
from customer_orders_temp
group by customer_id;

# For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
select customer_id,
case when exclusions is null and extras is null then count(*)
end as no_new_change,
case when exclusions is not null or extras is not null then count(*)
end as new_change  
from customer_orders_temp as c
inner join runner_orders_temp as r on c.order_id = r.order_id
where r.cancellation is null
group by customer_id;

# How many pizzas were delivered that had both exclusions and extras?
select count(*)
from customer_orders_temp as c
inner join runner_orders_temp as r on c.order_id = r.order_id
where exclusions is not null and extras is not null and r.cancellation is null ;

# What was the total quantity of pizzas ordered for each hour of each day?
select count(*) ,extract(HOUR from order_time) as each_hour ,extract(DAY from order_time) as each_day
from customer_orders_temp
group by each_day,each_hour ;

# What was the total quantity of pizzas ordered for each hour of the day?
select count(*) ,extract(HOUR from order_time) as each_hour 
from customer_orders_temp
group by each_hour ;

# What was the volume of orders for each date of the week?
select count(*) ,extract(DAY from order_time) as each_date
from customer_orders_temp
group by each_date ;

# What was the volume of orders for each day of the week?
select count(*) ,dayname(order_time) as each_date
from customer_orders_temp
group by each_date ;

# What was the volume of orders for each day of each week?
select count(*) ,dayname(order_time) as each_date ,extract(WEEK from order_time) as each_week
from customer_orders_temp
group by each_week, each_date ;




