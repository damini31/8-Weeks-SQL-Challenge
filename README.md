# Case Study #1 - Danny's Diner
<img src="1.png" width="350">

<h3><a href : "[https://8weeksqlchallenge.com/case-study-1/]">Here's the challenge</a></h3>
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

<p style="border: 3px blue">-- 1. What is the total amount each customer spent at the restaurant?</br> 
select 
s.customer_id,
--m.product_id,
sum(m.price) as 'Total Amount'
from sales s
LEFT JOIN menu m on s.product_id = m.product_id
group by s.customer_id</p>
