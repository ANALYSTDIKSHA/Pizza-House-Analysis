SELECT * FROM pizza_runner.runners;

# How many runners signed up and in which week? (i.e. week starts 2021-01-01)
select count(*) , extract(WEEK from registration_date) as each_week
from runners
group by each_week ;

# What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
with cte1 as(select *, extract(MINUTE from c.order_time) as o_min from customer_orders_temp as c),
cte2 as(select *, extract(MINUTE from r.pickup_time) as p_min from runner_orders_temp as r)
select runner_id, avg(p_min - o_min) as average_in_minutes
from cte1 join cte2 
on cte1.order_id = cte2.order_id
where cte2.cancellation is null
group by runner_id ;

# What was the average distance travelled for each customer?
select c.customer_id,avg(distance)
from customer_orders_temp as c
join runner_orders_temp as r
on c.order_id = r.order_id
group by c.customer_id ;

# Is there any relationship between the number of pizzas and how long the order takes to prepare?
select c.order_id, timestampdiff(MINUTE,c.order_time , r.pickup_time ) as time_diff_in_minutes , 
count(c.order_id) as number_of_pizzas
		#avg(timestampdiff(MINUTE,c.order_time , r.pickup_time )) as average_time_diff_in_minutes
from customer_orders_temp as c
join runner_orders_temp as r
on r.order_id=c.order_id
where r.cancellation is null
group by c.order_id,time_diff_in_minutes ;


# What was the difference between the longest and shortest delivery times for all orders?
select max(duration) - min(duration)
from runner_orders_temp ;

# what is average speed of each runner
with cte1 as(select *,(duration / 60) as 'duration_in_hrs' from runner_orders_temp) 
select runner_id, avg(distance/duration_in_hrs) as avg_speed from cte1
group by runner_id ;

# What was the average speed for each runner for each delivery and do you notice any trend for these values?
with cte1 as(select *,(duration / 60) as 'duration_in_hrs' from runner_orders_temp) 
select *, avg(distance/duration_in_hrs) as avg_speed from cte1
group by runner_id , order_id ;

# What is the successful delivery percentage for each runner?
select runner_id, (count(pickup_time) / count(order_id) * 100) as delivery_perc
from runner_orders_temp
group by runner_id ;



#with cte1 as(select *, MINUTE(c.order_time) as o_min from customer_orders_temp as c),
#cte2 as(select *, MINUTE(r.pickup_time) as p_min from runner_orders_temp as r)
#select * ,(p_min - o_min) as average_in_minutes
#from cte1 join cte2 
#on cte1.order_id= cte2.order_id
#where cte2.cancellation is null ;
#group by runner_id ;

#select r.runner_id, timestampdiff(MINUTE,c.order_time , r.pickup_time ) as time_diff_in_minutes,
#avg(timestampdiff(MINUTE,c.order_time , r.pickup_time )) as average_time_diff_in_minutes
#from customer_orders_temp as c
#join runner_orders_temp as r
#on r.order_id=c.order_id
#where r.cancellation is null
#group by r.runner_id ;


