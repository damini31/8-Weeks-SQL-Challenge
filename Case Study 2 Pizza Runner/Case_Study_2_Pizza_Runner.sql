create database Pizza_Runner1;
use Pizza_Runner1;

ALTER DATABASE Pizza_Runner1 SET COMPATIBILITY_LEVEL = 130

CREATE TABLE runners (
  "runner_id" INTEGER,
  "registration_date" DATE
);
INSERT INTO runners
  ("runner_id", "registration_date")
VALUES
  (1, '2021-01-01'),
  (2, '2021-01-03'),
  (3, '2021-01-08'),
  (4, '2021-01-15');

CREATE TABLE customer_orders (
  "order_id" INTEGER,
  "customer_id" INTEGER,
  "pizza_id" INTEGER,
  "exclusions" VARCHAR(4),
  "extras" VARCHAR(4),
  "order_time" datetime
);

INSERT INTO customer_orders
  ("order_id", "customer_id", "pizza_id", "exclusions", "extras", "order_time")
VALUES
  ('1', '101', '1', '', '', '2020-01-01 18:05:02'),
  ('2', '101', '1', '', '', '2020-01-01 19:00:52'),
  ('3', '102', '1', '', '', '2020-01-02 23:51:23'),
  ('3', '102', '2', '', NULL, '2020-01-02 23:51:23'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '2', '4', '', '2020-01-04 13:23:46'),
  ('5', '104', '1', 'null', '1', '2020-01-08 21:00:29'),
  ('6', '101', '2', 'null', 'null', '2020-01-08 21:03:13'),
  ('7', '105', '2', 'null', '1', '2020-01-08 21:20:29'),
  ('8', '102', '1', 'null', 'null', '2020-01-09 23:54:33'),
  ('9', '103', '1', '4', '1, 5', '2020-01-10 11:22:59'),
  ('10', '104', '1', 'null', 'null', '2020-01-11 18:34:49'),
  ('10', '104', '1', '2, 6', '1, 4', '2020-01-11 18:34:49');


CREATE TABLE runner_orders (
  "order_id" INTEGER,
  "runner_id" INTEGER,
  "pickup_time" VARCHAR(19),
  "distance" VARCHAR(7),
  "duration" VARCHAR(10),
  "cancellation" VARCHAR(23)
);

INSERT INTO runner_orders
  ("order_id", "runner_id", "pickup_time", "distance", "duration", "cancellation")
VALUES
  ('1', '1', '2020-01-01 18:15:34', '20km', '32 minutes', ''),
  ('2', '1', '2020-01-01 19:10:54', '20km', '27 minutes', ''),
  ('3', '1', '2020-01-03 00:12:37', '13.4km', '20 mins', NULL),
  ('4', '2', '2020-01-04 13:53:03', '23.4', '40', NULL),
  ('5', '3', '2020-01-08 21:10:57', '10', '15', NULL),
  ('6', '3', 'null', 'null', 'null', 'Restaurant Cancellation'),
  ('7', '2', '2020-01-08 21:30:45', '25km', '25mins', 'null'),
  ('8', '2', '2020-01-10 00:15:02', '23.4 km', '15 minute', 'null'),
  ('9', '2', 'null', 'null', 'null', 'Customer Cancellation'),
  ('10', '1', '2020-01-11 18:50:20', '10km', '10minutes', 'null');


CREATE TABLE pizza_names (
  "pizza_id" INTEGER,
  "pizza_name" TEXT
);
INSERT INTO pizza_names
  ("pizza_id", "pizza_name")
VALUES
  (1, 'Meatlovers'),
  (2, 'Vegetarian');


CREATE TABLE pizza_recipes (
  "pizza_id" INTEGER,
  "toppings" TEXT
);
INSERT INTO pizza_recipes
  ("pizza_id", "toppings")
VALUES
  (1, '1, 2, 3, 4, 5, 6, 8, 10'),
  (2, '4, 6, 7, 9, 11, 12');



CREATE TABLE pizza_toppings (
  "topping_id" INTEGER,
  "topping_name" TEXT
);
INSERT INTO pizza_toppings
  ("topping_id", "topping_name")
VALUES
  (1, 'Bacon'),
  (2, 'BBQ Sauce'),
  (3, 'Beef'),
  (4, 'Cheese'),
  (5, 'Chicken'),
  (6, 'Mushrooms'),
  (7, 'Onions'),
  (8, 'Pepperoni'),
  (9, 'Peppers'),
  (10, 'Salami'),
  (11, 'Tomatoes'),
  (12, 'Tomato Sauce');

  select * from runners;
  select * from customer_orders;
  select * from runner_orders;
  select * from pizza_names;
  select * from pizza_recipes;
  select * from pizza_toppings;

  select * from customer_orders;

  update customer_orders
  set exclusions = NULL where exclusions =''

  update customer_orders
  set exclusions = NULL where exclusions ='null'
  
  update customer_orders
  set extras = NULL where extras =''

  update customer_orders
  set extras = NULL where extras ='null'

  select * from customer_orders
  /* Cleaning runner_orders table 
  Changing 'null' text values to NULL to be able to change the data type of pickup_time column from varchar to datetime
  Changing 'null' text values to NULL and replacing km to '' to be able to change the data type of distance column to float
  Changing 'null' text values to NULL and replacing mins/minute/minutes to '' to be able to change the data type of duration column to float
  Change 'null' text values and blank values to be able to NULL in the cancellation column
  */

  --Cleaned pickup_time column
  update runner_orders
  set pickup_time = NULL where pickup_time ='null'

  Alter table runner_orders
  alter column pickup_time datetime

  --Cleaned distance column

  update runner_orders
  set distance = NULL where distance ='null'

  update runner_orders
  set distance = RTRIM(replace(distance,'km',''))

  Alter table runner_orders
  alter column distance float

  select * from runner_orders

--Cleaned duration column


  update runner_orders
  set duration = NULL where duration ='null'

  update runner_orders
  set duration = case when CHARINDEX('minutes',duration) > 0 then RTRIM(replace(duration,'minutes',''))
					  when CHARINDEX('mins',duration) > 0 then RTRIM(replace(duration,'mins',''))
					  when CHARINDEX('minute',duration) > 0 then RTRIM(replace(duration,'minute',''))
					  else duration
				 end

  Alter table runner_orders
  alter column duration int

--Cleaned cancellation column

  update runner_orders
  set cancellation = NULL where cancellation =''

  
  update runner_orders
  set cancellation = NULL where cancellation ='null'


  /*A. Pizza Metrics
How many pizzas were ordered?
How many unique customer orders were made?
How many successful orders were delivered by each runner?
How many of each type of pizza was delivered?
How many Vegetarian and Meatlovers were ordered by each customer?
What was the maximum number of pizzas delivered in a single order?
For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
How many pizzas were delivered that had both exclusions and extras?
What was the total volume of pizzas ordered for each hour of the day?
What was the volume of orders for each day of the week?*/

select * from customer_orders
select * from pizza_toppings

--How many pizzas were ordered?
select count(pizza_id) as 'Total Pizzas ordered' from customer_orders

--How many unique customer orders were made?
select distinct(customer_id)

--How many successful orders were delivered by each runner?

select runner_id as 'runner' , count(order_id) as 'successful delivered orders'
from runner_orders
where cancellation is null
group by runner_id

--How many of each type of pizza was delivered?
select
co.pizza_id,
cast(pn.pizza_name as varchar(20)) as 'Pizza Name',
count(co.pizza_id) as 'No. of pizzas delivered'
--case when ro.cancellation is null then 'Delivered' else 'Not delivered' end as 'Delivery Status'
from
customer_orders co
LEFT JOIN
pizza_names pn on co.pizza_id = pn.pizza_id
LEFT JOIN runner_orders ro on co.order_id = ro.order_id
where ro.cancellation is null
group by co.pizza_id,cast(pn.pizza_name as varchar(20))

--How many Vegetarian and Meatlovers were ordered by each customer?
select
co.pizza_id,
cast(pn.pizza_name as varchar(20)) as 'Pizza Name',
count(co.pizza_id) as 'No. of pizzas ordered'
from
customer_orders co
LEFT JOIN
pizza_names pn on co.pizza_id = pn.pizza_id
group by co.pizza_id,cast(pn.pizza_name as varchar(20))

--What was the maximum number of pizzas delivered in a single order?

with  t1 as
(select
co.order_id,
count(co.pizza_id) as 'No_of_pizzas_delivered'
--case when ro.cancellation is null then 'Delivered' else 'Not delivered' end as 'Delivery Status'
from
customer_orders co
LEFT JOIN runner_orders ro on co.order_id = ro.order_id
where ro.cancellation is null
group by co.order_id)
select max(t1.No_of_pizzas_delivered) as 'Max_pizzas delivered' from t1

--For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

select 
co.customer_id,
count(co.order_id) as'total_pizzas_ordered',
sum(case when exclusions is null and extras is null then 1 else 0 end) as 'pizzas without changes',
sum(case when exclusions is not null or extras is not null then 1 else 0 end) as 'pizzas with changes'
from customer_orders co
LEFT JOIN
runner_orders ro on co.order_id = ro.order_id
where ro.cancellation is null
group by customer_id


--How many pizzas were delivered that had both exclusions and extras?

select * from customer_orders
select 
sum(case when exclusions is not null and extras is not null then 1 else 0 end) as 'pizzas with changes(E&E)'
from customer_orders co
LEFT JOIN
runner_orders ro on co.order_id = ro.order_id
where ro.cancellation is null

--What was the total volume of pizzas ordered for each hour of the day?

select Datepart(hh,order_time) as 'Hour',
count(pizza_id) as 'Pizza ordered'
from customer_orders
group by Datepart(hh,order_time)

--What was the volume of orders for each day of the week?

select Datepart(dw,order_time) as 'Day of the week',
count(pizza_id) as 'Pizza ordered'
from customer_orders
group by Datepart(dw,order_time)


/*B. Runner and Customer Experience
How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
Is there any relationship between the number of pizzas and how long the order takes to prepare?
What was the average distance travelled for each customer?
What was the difference between the longest and shortest delivery times for all orders?
What was the average speed for each runner for each delivery and do you notice any trend for these values?
What is the successful delivery percentage for each runner?*/

--How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

select
case when DateDiff(dd,'2021-01-01',registration_date) < 7 then 'Week - I'
     when DateDiff(dd,'2021-01-01',registration_date) between 7 and 13  then 'Week - II'
	 when DateDiff(dd,'2021-01-01',registration_date) between 14 and 20  then 'Week - III'
	 when DateDiff(dd,'2021-01-01',registration_date) between 21 and 27  then 'Week - IV'
	 else 'Week - IV +' end as 'Week_Num',
count(runner_id) as 'Total Sign ups'
from runners
group by 
case when DateDiff(dd,'2021-01-01',registration_date) < 7 then 'Week - I'
     when DateDiff(dd,'2021-01-01',registration_date) between 7 and 13  then 'Week - II'
	 when DateDiff(dd,'2021-01-01',registration_date) between 14 and 20  then 'Week - III'
	 when DateDiff(dd,'2021-01-01',registration_date) between 21 and 27  then 'Week - IV'
	 else 'Week - IV +' end

--What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

select 
distinct
ro.runner_id,
Avg(datediff(mi,order_time,pickup_time)) as 'Avg_minutes'
from 
customer_orders co
LEFT JOIN
runner_orders ro on co.order_id = ro.order_id
where ro.pickup_time is not NULL
group by 
ro.runner_id

--Is there any relationship between the number of pizzas and how long the order takes to prepare?
--Yes, more number of pizzas take more time to prepare, on an average (10 minutes) per pizza


select 
distinct
ro.order_id,
count(co.pizza_id) as 'pizzas ordered',
Avg(datediff(mi,order_time,pickup_time)) as 'Avg Time taken'
from 
customer_orders co
LEFT JOIN
runner_orders ro on co.order_id = ro.order_id
where ro.pickup_time is not NULL
group by 
ro.order_id,co.pizza_id

--What was the average distance travelled for each customer?

select 
co.customer_id,
count(co.order_id) as 'total orders',
sum(ro.distance) as 'total distance travelled (in km)',
Avg(ro.distance) as 'Average Distance travelled(in km)'
from customer_orders co
LEFT JOIN runner_orders ro on co.order_id = ro.order_id
where ro.cancellation is null
group by co.customer_id

--What was the difference between the longest and shortest delivery times for all orders?
select max(ro.duration) - min(ro.duration) as 'Difference (mx - min)(in minutes)'
from runner_orders ro

--What was the average speed for each runner for each delivery and do you notice any trend for these values?

select 
ro.runner_id,
Avg(Distance *1000) as 'Total_distance(m)',
Avg(Duration *60 ) as 'Total_time(s)',
cast(Avg(Distance *1000)/Avg(Duration *60 ) as decimal(5,2)) as 'speed(m/s)'
from runner_orders ro 
where ro.cancellation is null
group by ro.runner_id

--What is the successful delivery percentage for each runner?*/

select 
ro.runner_id,
count(order_id) as 'Total_orders_Assigned',
sum(Case when ro.cancellation is null then 1 else 0 end) as 'Delivered',
cast((sum(Case when ro.cancellation is null then 1 else 0 end) * 100 )/count(order_id) as float) as 'Successful Delivery %'
from runner_orders ro 
group by ro.runner_id


/*C. Ingredient Optimisation
What are the standard ingredients for each pizza?
What was the most commonly added extra?
What was the most common exclusion?
Generate an order item for each record in the customers_orders table in the format of one of the following:
Meat Lovers
Meat Lovers - Exclude Beef
Meat Lovers - Extra Bacon
Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"
What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?*/


--What are the standard ingredients for each pizza?
select pr.pizza_id,pn.pizza_name,pt.topping_name as 'Standard_ingredients'
from pizza_recipes pr
     cross apply string_split(cast(toppings as varchar(30)),',')
LEFT JOIN pizza_toppings pt on TRIM(value) = cast(pt.topping_id as varchar(30))
LEFT JOIN pizza_names pn on pr.pizza_id = pn.pizza_id

--What was the most commonly added extra?

select top 1 value as 'Topping',cast(pt.topping_name as varchar(30)) as 'Extras Name' ,count(*) as 'requests'
from customer_orders 
      cross apply string_split(extras,',')
LEFT JOIN pizza_toppings pt on TRIM(value) = cast(pt.topping_id as varchar(30))
where extras is not null
group by value,cast(pt.topping_name as varchar(30))
order by requests desc


--What was the most common exclusion?
select top 1 value as 'Topping',cast(pt.topping_name as varchar(30)) as 'Exclusion Name' ,count(*) as 'requests'
from customer_orders 
      cross apply string_split(exclusions,',')
LEFT JOIN pizza_toppings pt on TRIM(value) = cast(pt.topping_id as varchar(30))
where exclusions is not null
group by value,cast(pt.topping_name as varchar(30))
order by requests desc

/*Generate an order item for each record in the customers_orders table in the format of one of the following:
Meat Lovers
Meat Lovers - Exclude Beef
Meat Lovers - Extra Bacon
Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers*/

INSERT INTO customer_orders
  ("order_id", "customer_id", "pizza_id", "exclusions", "extras", "order_time")
VALUES
  (11, 105, 1, Null, Null, '2024-05-07 18:05:02'),
  (12, 106, 1, '3', Null, '2024-05-06 18:05:02'),
  (13, 107, 1, 'Null','1', '2024-05-05 18:05:02'),
  (14, 108, 1,'4,1', '6,9','2024-05-04 18:05:02');


/*Generate an alphabetically ordered comma separated ingredient list for each pizza order 
from the customer_orders table and add a 2x in front of any relevant ingredients*/

create function t (@exclusions varchar(20)) -- Splits exclusions as to rows
returns table
as
   return select ordinal,Trim(value) as 'value' from string_split(@exclusions,',',1)

create function final_recipe(@r varchar(100)) --- outputs final recipe with topping names
returns table
as
return
             with t1 as
             (select 
			 convert(int,trim(value)) as 'v',
			 cast(pt.topping_name as varchar(20)) as 'topping',
             concat(cast(count(*) as varchar(10)),'x',cast(pt.topping_name as varchar(20))) as 'f_r'
             from 
			 string_split(@r,',') a
             LEFT JOIN pizza_toppings pt on convert(int,trim(a.value)) = pt.topping_id
             group by convert(int,trim(value)),cast(pt.topping_name as varchar(20)))
			 select STRING_AGG(t1.f_r,',') as 'final' from t1

create function del (@v as int,@final as varchar(100))
returns @z table(i int)
as
begin
      Insert into @z
	  with t1 as
	  (select cast(Trim(value) as int) as 'j' from string_split(@final,',')
	  where cast(Trim(value) as int) <> @v)

	  return
END;---Removing exclusions from the recipe + extras


create function repl(@extras varchar(20),@exclusions varchar(20),@recipe varchar(100)) -- final recipe with extras and without exclusions
returns varchar(100)
as
BEGIN
   declare @c as int;
   declare @i as int;
   declare @a as varchar(10);
   declare @v as int;
   declare @final_r as varchar(100);

   set @c = (select count(*) from dbo.t(@exclusions));
   set @i = 1
   set @final_r = case when @extras is null then @recipe
                       else CONCAT(@recipe,',',@extras) end

   While @i <= @c
   BEGIN
	   set @v = (select value from dbo.t(@exclusions) where ordinal = @i);
	   set @final_r = (select STRING_AGG(i,',') from dbo.del(@v,@final_r))
	   set @i = @i + 1
   END
   set @final_r = case when charindex(',,',@final_r) > 0 then REPLACE(@final_r,',,',',') 
                       when charindex(', ,',@final_r) > 0 then REPLACE(@final_r,', ,',',')   
					   else @final_r end
   set @final_r = (select final from dbo.final_recipe(@final_r));
   return @final_r
END;

select 
co.customer_id,
co.order_id,
co.pizza_id,
--co.exclusions,
--co.extras,
pn.pizza_name,
--pr.toppings,
Concat(pn.pizza_name,':',dbo.repl(co.extras,co.exclusions,convert(varchar(50),pr.toppings))) as 'final recipe'
from customer_orders co
LEFT JOIN pizza_names pn on co.pizza_id = pn.pizza_id
LEFT JOIN pizza_recipes pr on co.pizza_id = pr.pizza_id

/*What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?*/
create function final_r(@r varchar(1024)) --- outputs final recipe with topping names
returns table
as
return
             
			 select 
			 --convert(int,trim(value)) as 'v',
			 cast(pt.topping_name as varchar(20)) as 'topping',
             cast(count(*) as int) as 'f_r'
             from 
			 string_split(@r,',') a
             LEFT JOIN pizza_toppings pt on convert(int,trim(a.value)) = pt.topping_id
             group by convert(int,trim(value)),cast(pt.topping_name as varchar(20))



create function repll(@extras varchar(20),@exclusions varchar(20),@recipe varchar(100)) -- final recipe with extras and without exclusions
returns varchar(100)
as
BEGIN
   declare @c as int;
   declare @i as int;
   declare @a as varchar(10);
   declare @v as int;
   declare @final_r as varchar(100);

   set @c = (select count(*) from dbo.t(@exclusions));
   set @i = 1
   set @final_r = case when @extras is null then @recipe
                       else CONCAT(@recipe,',',@extras) end

   While @i <= @c
   BEGIN
	   set @v = (select value from dbo.t(@exclusions) where ordinal = @i);
	   set @final_r = (select STRING_AGG(i,',') from dbo.del(@v,@final_r))
	   set @i = @i + 1
   END
   set @final_r = case when charindex(',,',@final_r) > 0 then REPLACE(@final_r,',,',',') 
                       when charindex(', ,',@final_r) > 0 then REPLACE(@final_r,', ,',',')   
					   else @final_r end
   --set @final_r = (select final from dbo.final_recipe(@final_r));
   return @final_r
END;


with t1 as
(select 
string_agg(dbo.repll(co.extras,co.exclusions,convert(varchar(50),pr.toppings)),',') as 'total_ing'
from runner_orders ro
LEFT JOIN
customer_orders co on ro.order_id = co.order_id
LEFT JOIN pizza_recipes pr on co.pizza_id = pr.pizza_id
where ro.cancellation is null)
select topping as 'Ingredients',f_r as 'Total Quantity' from dbo.final_r ((select t1.total_ing from t1))
order by f_r desc



/*D. Pricing and Ratings
If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - 
how much money has Pizza Runner made so far if there are no delivery fees?
What if there was an additional $1 charge for any pizza extras?
Add cheese is $1 extra
The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
customer_id
order_id
runner_id
rating
order_time
pickup_time
Time between order and pickup
Delivery duration
Average speed
Total number of pizzas
If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?*/

/*If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - 
how much money has Pizza Runner made so far if there are no delivery fees?*/

select
ro.runner_id,
--ro.order_id,
--co.order_id,
--co.pizza_id,
--pn.pizza_name,
--ro.distance,
--case when cast(pn.pizza_name as varchar(20)) = 'Meatlovers' then format(12,'C') else format(10,'C') end as 'pizza_price',
--format(ro.distance * 0.30,'C') as 'travel_amount',
--format(case when cast(pn.pizza_name as varchar(20)) = 'Meatlovers' then 12 else 10 end + ro.distance * 0.30,'C') as 'total_earned',
format(sum(case when cast(pn.pizza_name as varchar(20)) = 'Meatlovers' then 12 else 10 end),'C') as 'total_earned'
from runner_orders ro 
LEFT JOIN
customer_orders co on ro.order_id = co.order_id
LEFT JOIN
pizza_names pn on pn.[pizza_id] = co.pizza_id
where ro.cancellation is null
group by ro.runner_id



/*If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - 
how much money does Pizza Runner have left over after these deliveries?*/

select
ro.runner_id,
--ro.order_id,
--co.order_id,
--co.pizza_id,
--pn.pizza_name,
--ro.distance,
--case when cast(pn.pizza_name as varchar(20)) = 'Meatlovers' then format(12,'C') else format(10,'C') end as 'pizza_price',
--format(ro.distance * 0.30,'C') as 'travel_amount',
--format(case when cast(pn.pizza_name as varchar(20)) = 'Meatlovers' then 12 else 10 end + ro.distance * 0.30,'C') as 'total_earned',
format(sum(case when cast(pn.pizza_name as varchar(20)) = 'Meatlovers' then 12 else 10 end + ro.distance * 0.30),'C') as 'total_earned'
from runner_orders ro 
LEFT JOIN
customer_orders co on ro.order_id = co.order_id
LEFT JOIN
pizza_names pn on pn.[pizza_id] = co.pizza_id
where ro.cancellation is null
group by ro.runner_id

/*If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and
What if there was an additional $1 charge for any pizza extras?*/

create function rep_new (@extras varchar(10))
returns table
as
return 
     select value from string_split(@extras,',')

create function rep_final (@extras varchar(10))
returns int as
BEGIN 
     declare @c as int;
	 set @c = (select count(*) from dbo.rep_new(@extras));
	 return @c
END;

with t1 as 
(select
ro.runner_id,
--case when cast(pn.pizza_name as varchar(20)) = 'Meatlovers' then format(12,'C') else format(10,'C') end as 'pizza_price',
--format(ro.distance * 0.30,'C') as 'travel_amount',
--format(case when cast(pn.pizza_name as varchar(20)) = 'Meatlovers' then 12 else 10 end + ro.distance * 0.30,'C') as 'total_earned',
sum(case when co.extras is null then 0 * 1
     when len(trim(co.extras)) = 1 then 1 * 1
	 else dbo.rep_final(co.extras) * 1
	 end) as 'extras_Charges',
sum(case when cast(pn.pizza_name as varchar(20)) = 'Meatlovers' then 12 else 10 end) as 'total_earned'
from runner_orders ro 
LEFT JOIN
customer_orders co on ro.order_id = co.order_id
LEFT JOIN
pizza_names pn on pn.[pizza_id] = co.pizza_id
where ro.cancellation is null
group by ro.runner_id)
select 
t1.runner_id,
format(sum(cast(t1.total_earned as float)+ cast(t1.extras_charges as float)),'C') as 'Total_earned'
from t1
group by t1.runner_id


/*If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and 
Add cheese is $1 extra*/
create function rep_fin (@extras varchar(10))
returns int as
BEGIN 
     declare @c as int;
	 set @c = (select count(*) from dbo.rep_new(@extras) where value = 4);
	 return @c
END;


with t1 as 
(select
ro.runner_id,
--case when cast(pn.pizza_name as varchar(20)) = 'Meatlovers' then format(12,'C') else format(10,'C') end as 'pizza_price',
--format(ro.distance * 0.30,'C') as 'travel_amount',
--format(case when cast(pn.pizza_name as varchar(20)) = 'Meatlovers' then 12 else 10 end + ro.distance * 0.30,'C') as 'total_earned',
sum(dbo.rep_fin(co.extras) * 1) as 'Cheese_Charges',
sum(case when cast(pn.pizza_name as varchar(20)) = 'Meatlovers' then 12 else 10 end) as 'total_earned'
from runner_orders ro 
LEFT JOIN
customer_orders co on ro.order_id = co.order_id
LEFT JOIN
pizza_names pn on pn.[pizza_id] = co.pizza_id
where ro.cancellation is null
group by ro.runner_id)
select 
t1.runner_id,
format(sum(cast(t1.total_earned as float)+ cast(t1.Cheese_Charges as float)),'C') as 'Total_earned'
from t1
group by t1.runner_id


/*The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, 
how would you design an additional table for this new dataset - 
generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.*/

create table ratings
(
  CustID int,
  orderID int,
  Ratings int 
  );


Insert into ratings values
(101,1,3),
(101,2,5),
(102,3,4),
(103,4,5),
(104,5,3),
(105,7,5),
(102,8,5),
(104,10,4);

select * from ratings;

/*Using your newly generated table - can you join all of the information together to form a table 
which has the following information for successful deliveries?
customer_id
order_id
runner_id
rating
order_time
pickup_time
Time between order and pickup
Delivery duration
Average speed
Total number of pizzas */

select
co.customer_id,
co.order_id,
r.Ratings,
co.order_time,
ro.pickup_time,
Datediff(MM,co.order_time,ro.pickup_time) as 'Time B/w',
ro.duration as 'Duration (in minutes)',
cast(Avg(Distance *1000)/Avg(Duration *60 ) as decimal(5,2)) as 'Speed(m/s)',
count(*) as 'Total Pizzas'
from customer_orders co
LEFT JOIN runner_orders ro on co.order_id = ro.order_id
LEFT JOIN ratings r on co.customer_id = r.CustID and co.order_id = r.orderID
where ro.cancellation is null and co.order_id in (select order_id from runner_orders where ro.cancellation is null)
group by co.customer_id,
co.order_id,
r.Ratings,
co.order_time,
ro.pickup_time,
Datediff(MM,co.order_time,ro.pickup_time) ,
ro.duration