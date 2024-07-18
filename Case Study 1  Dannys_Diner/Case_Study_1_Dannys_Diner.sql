/* --------------------
   Case Study Questions
   --------------------*/

-- 1. What is the total amount each customer spent at the restaurant?
-- 2. How many days has each customer visited the restaurant?
-- 3. What was the first item from the menu purchased by each customer?
-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
-- 5. Which item was the most popular for each customer?
-- 6. Which item was purchased first by the customer after they became a member?
-- 7. Which item was purchased just before the customer became a member?
-- 8. What is the total items and amount spent for each member before they became a member?
-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?


CREATE database dannys_diner;
use dannys_diner;

CREATE TABLE sales (
  "customer_id" VARCHAR(1),
  "order_date" DATE,
  "product_id" INTEGER
);

INSERT INTO sales
  ("customer_id", "order_date", "product_id")
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
 

CREATE TABLE menu (
  "product_id" INTEGER,
  "product_name" VARCHAR(5),
  "price" INTEGER
);

INSERT INTO menu
  ("product_id", "product_name", "price")
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  

CREATE TABLE members (
  "customer_id" VARCHAR(1),
  "join_date" DATE
);

INSERT INTO members
  ("customer_id", "join_date")
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');

0
-- 1. What is the total amount each customer spent at the restaurant?
select 
s.customer_id,
--m.product_id,
sum(m.price) as 'Total Amount'
from sales s
LEFT JOIN menu m on s.product_id = m.product_id
group by s.customer_id

-- 2. How many days has each customer visited the restaurant?
select 
customer_id,
count(distinct(order_date)) as 'Customer Visits'
from sales
group by customer_id


-- 3. What was the first item from the menu purchased by each customer?
with t1 as
(select 
s.*,
m.product_name,
ROW_NUMBER() over (partition by customer_id order by order_date asc) as 'order_num'
from Sales s
LEFT JOIN menu m on s.product_id = m.product_id)
select 
t1.customer_id,
t1.order_date,
t1.product_name 
from t1
where t1.order_num = 1;

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?

select 
s.product_id,
m.product_name,
count(*) as 'Purchases'
from Sales s
LEFT JOIN menu m on s.product_id = m.product_id
group by s.product_id, m.product_name
order by 'Purchases' desc


-- 5. Which item was the most popular for each customer?

with t1 as
(select
s.customer_id,
s.product_id,
m.product_name,
count(*) as 'orders',
RANK() over (partition by customer_id order by count(*) desc) as 'popular'
from Sales s
LEFT JOIN menu m on s.product_id = m.product_id
group by s.customer_id,s.product_id,m.product_name)
select t1.customer_id,t1.product_id,t1.product_name,t1.orders
from t1 
where t1.popular = 1;

-- 6. Which item was purchased first by the customer after they became a member?

with t1 as
(select 
s.customer_id,
s.order_date,
s.product_id,
mem.join_date,
ROW_NUMBER() over (partition by s.customer_id order by s.order_date asc) as 'order_num'
from Sales s
LEFT JOIN members mem on s.customer_id = mem.customer_id
where s.order_date >= mem.join_date
group by s.customer_id,
s.order_date,
s.product_id,
mem.join_date)
select t1.customer_id,t1.join_date,t1.order_date,t1.product_id,m.product_name as first_order
from t1
LEFT JOIN menu m on t1.product_id = m.product_id
where t1.order_num = 1


-- 7. Which item was purchased just before the customer became a member?

with t1 as
(select 
s.customer_id,
s.order_date,
s.product_id,
mem.join_date,
RANK() over (partition by s.customer_id order by s.order_date desc) as 'order_num'
from Sales s
LEFT JOIN members mem on s.customer_id = mem.customer_id
where s.order_date < mem.join_date
group by s.customer_id,
s.order_date,
s.product_id,
mem.join_date)
select t1.customer_id,t1.join_date,t1.order_date,t1.product_id,m.product_name as first_order
from t1
LEFT JOIN menu m on t1.product_id = m.product_id
where t1.order_num = 1

-- 8. What is the total items and amount spent for each member before they became a member?

select 
s.customer_id,
count(*) as 'total_items',
sum(m.price) as 'total_amount'
from Sales s
LEFT JOIN members mem on s.customer_id = mem.customer_id
LEFT JOIN menu m on s.product_id = m.product_id
where s.order_date < mem.join_date
group by s.customer_id

-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

select
s.customer_id,
sum(case
   when m.product_name = 'sushi' then m.price * 2 * 10
   else m.price * 10
end) as 'total_points'
from Sales s
LEFT JOIN menu m on s.product_id = m.product_id
group by s.customer_id


-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

select 
s.customer_id,
sum(case
   when s.order_date between mem.join_date and dateadd(day,7,mem.join_date)  then m.price * 2 * 10
   when (s.order_date < mem.join_date or s.order_date > dateadd(day,7,mem.join_date)) and m.product_name = 'sushi' then  m.price * 2 * 10
   else m.price * 10
end) as 'total_points'
from Sales s
LEFT JOIN members mem on s.customer_id = mem.customer_id
LEFT JOIN menu m on s.product_id = m.product_id
where month(order_date) = 1
group by 
s.customer_id



/*Bonus Questions
Join All The Things
The following questions are related creating basic data tables that Danny and his team can use to quickly derive insights without needing to join the underlying tables using SQL.*/

select
s.customer_id,
s.order_date,
m.product_name,
m.price,
case
   when s.order_date < mem.join_date then 'N'
   when mem.join_date is null then 'N'
   else 'Y'
end as 'member'
from sales s
LEFT JOIN menu m on s.product_id = m.product_id
LEFT JOIN members mem on mem.customer_id = s.customer_id
order by customer_id,order_date,product_name

/*Rank All The Things
Danny also requires further information about the ranking of customer products, but he purposely does not need the ranking for non-member purchases so he expects null ranking values for the records when customers are not yet part of the loyalty program.*/

with t1 as
(select
s.customer_id,
s.order_date,
m.product_name,
m.price,
case
   when s.order_date < mem.join_date then 'N'
   when mem.join_date is null then 'N'
   else 'Y'
end as 'member'
from sales s
LEFT JOIN menu m on s.product_id = m.product_id
LEFT JOIN members mem on mem.customer_id = s.customer_id)
select 
t1.*,
case 
   when t1.member = 'Y' then dense_Rank() over (partition by t1.customer_id order by t1.member desc,t1.order_date asc)
   else null
end as 'ranking'
from t1
order by t1.customer_id,t1.order_date,t1.product_name