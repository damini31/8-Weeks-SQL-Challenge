# Case Study #2 - Pizza Runner

[Here's the link to the problem statement](https://8weeksqlchallenge.com/case-study-2/)

<img src="2.png" width="450">

<body>

<p>Danny wants to use the data to answer a few simple questions about his customers, especially about their visiting patterns, how much money they’ve spent and also which menu items are their favourite. Having this deeper connection with his customers will help him deliver a better and more personalised experience for his loyal customers.

He plans on using these insights to help him decide whether he should expand the existing customer loyalty program - additionally he needs help to generate some basic datasets so his team can easily inspect the data without needing to use SQL.

Danny has provided you with a sample of his overall customer data due to privacy issues - but he hopes that these examples are enough for you to write fully functioning SQL queries to help him answer his questions!

Danny has shared with you 3 key datasets for this case study:
<ul>
<li>sales</li>
<li>menu</li>
<li>members</li>
</ul>
You can inspect the entity relationship diagram</p>

<hr>

<p> 
<h3>1. What is the total amount each customer spent at the restaurant?</h3></br>
select 
</br>s.customer_id,
</br>sum(m.price) as 'Total Amount'
</br>from sales s
</br>LEFT JOIN menu m on s.product_id = m.product_id
</br>group by s.customer_id
</p>

<hr>

<p> 
<h3>2. How many days has each customer visited the restaurant?</h3>
</br>select 
</br>customer_id,
</br>count(distinct(order_date)) as 'Customer Visits'
</br>from sales
</br>group by customer_id
</p>

<hr>

<p> 
<h3>3. What was the first item from the menu purchased by each customer?</h3>
</br>with t1 as
</br>(select 
</br>s.*,
</br>m.product_name,
</br>ROW_NUMBER() over (partition by customer_id order by order_date asc) as 'order_num'
</br>from Sales s
</br>LEFT JOIN menu m on s.product_id = m.product_id)
</br>select 
</br>t1.customer_id,
</br>t1.order_date,
</br>t1.product_name 
</br>from t1
</br>where t1.order_num = 1;
</p>

<hr>

<p> 
<h3>4. What is the most purchased item on the menu and how many times was it purchased by all customers?</h3>
</br>select 
</br>s.product_id,
</br>m.product_name,
</br>count(*) as 'Purchases'
</br>from Sales s
</br>LEFT JOIN menu m on s.product_id = m.product_id
</br>group by s.product_id, m.product_name
</br>order by 'Purchases' desc
</p>

<hr>

<p> 
<h3>5. Which item was the most popular for each customer?</h3>
</br>with t1 as
</br>(select
</br>s.customer_id,
</br>s.product_id,
</br>m.product_name,
</br>count(*) as 'orders',
</br>RANK() over (partition by customer_id order by count(*) desc) as 'popular'
</br>from Sales s
</br>LEFT JOIN menu m on s.product_id = m.product_id
</br>group by s.customer_id,s.product_id,m.product_name)
</br>select t1.customer_id,t1.product_id,t1.product_name,t1.orders
</br>from t1 
</br>where t1.popular = 1;
</p>

<hr>

<p> 
<h3>6. Which item was purchased first by the customer after they became a member?</h3>
</br>with t1 as
</br>(select 
</br>s.customer_id,
</br>s.order_date,
</br>s.product_id,
</br>mem.join_date,
</br>ROW_NUMBER() over (partition by s.customer_id order by s.order_date asc) as 'order_num'
</br>from Sales s
</br>LEFT JOIN members mem on s.customer_id = mem.customer_id
</br>where s.order_date >= mem.join_date
</br>group by s.customer_id,
</br>s.order_date,
</br>s.product_id,
</br>mem.join_date)
</br>select t1.customer_id,t1.join_date,t1.order_date,t1.product_id,m.product_name as first_order
</br>from t1
</br>LEFT JOIN menu m on t1.product_id = m.product_id
</br>where t1.order_num = 1
</p>

<hr>

<p> 
<h3>7. Which item was purchased just before the customer became a member?</h3>
</br>with t1 as
</br>(select 
</br>s.customer_id,
</br>s.order_date,
</br>s.product_id,
</br>mem.join_date,
</br>RANK() over (partition by s.customer_id order by s.order_date desc) as 'order_num'
</br>from Sales s
</br>LEFT JOIN members mem on s.customer_id = mem.customer_id
</br>where s.order_date < mem.join_date
</br>group by s.customer_id,
</br>s.order_date,
</br>s.product_id,
</br>mem.join_date)
</br>select t1.customer_id,t1.join_date,t1.order_date,t1.product_id,m.product_name as first_order
</br>from t1
</br>LEFT JOIN menu m on t1.product_id = m.product_id
</br>where t1.order_num = 1
</p>

<hr>

<p> 
<h3>8. What is the total items and amount spent for each member before they became a member?</h3>
</br>select 
</br>s.customer_id,
</br>count(*) as 'total_items',
</br>sum(m.price) as 'total_amount'
</br>from Sales s
</br>LEFT JOIN members mem on s.customer_id = mem.customer_id
</br>LEFT JOIN menu m on s.product_id = m.product_id
</br>where s.order_date < mem.join_date
</br>group by s.customer_id
</p>

<hr>

<p> 
<h3>9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?</h3>
</br>select
</br>s.customer_id,
</br>sum(case
   </br>when m.product_name = 'sushi' then m.price * 2 * 10
   </br>else m.price * 10
</br>end) as 'total_points'
</br>from Sales s
</br>LEFT JOIN menu m on s.product_id = m.product_id
</br>group by s.customer_id
</p>

<hr>

<p> 
<h3>10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?</h3>
</br>select 
</br>s.customer_id,
</br>sum(case
   </br>when s.order_date between mem.join_date and dateadd(day,7,mem.join_date)  then m.price * 2 * 10
  </br> when (s.order_date < mem.join_date or s.order_date > dateadd(day,7,mem.join_date)) and m.product_name = 'sushi' then  m.price * 2 * 10
   </br>else m.price * 10
</br>end) as 'total_points'
</br>from Sales s
</br>LEFT JOIN members mem on s.customer_id = mem.customer_id
</br>LEFT JOIN menu m on s.product_id = m.product_id
</br>where month(order_date) = 1
</br>group by 
</br>s.customer_id
</p>

<hr>

<p> 
<h3>/*Bonus Questions
Join All The Things
The following questions are related creating basic data tables that Danny and his team can use to quickly derive insights without needing to join the underlying tables using SQL.*/
</h3>
</br>select
</br>s.customer_id,
</br>s.order_date,
</br>m.product_name,
</br>m.price,
</br>case
  </br> when s.order_date < mem.join_date then 'N'
   </br>when mem.join_date is null then 'N'
   </br>else 'Y'
</br>end as 'member'
</br>from sales s
</br>LEFT JOIN menu m on s.product_id = m.product_id
</br>LEFT JOIN members mem on mem.customer_id = s.customer_id
</br>order by customer_id,order_date,product_name
</p>

<hr>

<p> 
<h3>Rank All The Things
Danny also requires further information about the ranking of customer products, but he purposely does not need the ranking for non-member purchases so he expects null ranking values for the records when customers are not yet part of the loyalty program.
</h3>
</br>with t1 as
</br>(select
</br>s.customer_id,
</br>s.order_date,
</br>m.product_name,
</br>m.price,
</br>case
   </br>when s.order_date < mem.join_date then 'N'
   </br>when mem.join_date is null then 'N'
   </br>else 'Y'
</br>end as 'member'
</br>from sales s
</br>LEFT JOIN menu m on s.product_id = m.product_id
</br>LEFT JOIN members mem on mem.customer_id = s.customer_id)
</br>select 
</br>t1.*,
</br>case 
   </br>when t1.member = 'Y' then dense_Rank() over (partition by t1.customer_id order by t1.member desc,t1.order_date asc)
   </br>else null
</br>end as 'ranking'
</br>from t1
</br>order by t1.customer_id,t1.order_date,t1.product_name
</p>

<hr>
