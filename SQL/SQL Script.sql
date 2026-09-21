use zomato;
-- for checking the tables
show tables;
-- for checking the columns
desc customers;
desc rest;
desc orders;
desc rider;
desc delveries;
-- add primary key to table's columns
-- customers
alter table customers
add primary key(customer_id);
-- deliveries
alter table delveries
add primary key(delivery_id);
-- orders
alter table orders
add primary key(order_id);
-- rest
alter table rest
add primary key(restaurant_id);
-- rider
alter table rider
add primary key(rider_id);

-- add foregin key to table's columns
-- delveries
alter table delveries
add constraint fk_orders
foreign key (order_id)
references orders(order_id);
-- 
alter table delveries
add constraint fk_rider
foreign key (rider_id)
references rider(rider_id);

-- orders
alter table orders
add constraint fk_costomers
foreign key (customer_id)
references customers(customer_id);
--
alter table orders
add constraint fk_rest
foreign key (restaurant_id)
references rest(restaurant_id);

use zomato;
-- Q1.Write a SQL query to display the top 3 order_items from the zomato database ranked by their order count.
with ranked_items
as
(
select order_item,count(order_item), 
rank() over(order by count(order_item) desc) as rankk 
from orders
group by 1
)
select  * from ranked_items
where
rankk<=3;

-- Q2.Write a query to display top item from the top restaurant
WITH TOP
as
(
select r.restaurant_name,o.order_item,
count(o.order_item) as total_orders,
rank() over(partition by r.restaurant_name order by count(o.order_item ) desc) as eeee
from rest r join orders o on r.restaurant_id=o.restaurant_id
group by 1,2

)
select restaurant_name,order_item,total_orders
from top
order by 3 desc
limit 1;

-- Q3. a query to display which person delvered most orders of veg biryani
use zomato;
SELECT 
    r.rider_name,o.order_item,
    COUNT(o.order_item) AS total_items
FROM rider r
JOIN delveries d 
    ON r.rider_id = d.rider_id
JOIN orders o 
    ON d.order_id = o.order_id
WHERE o.order_item = 'Veg Biryani'
GROUP BY r.rider_name
ORDER BY total_items DESC
LIMIT 1;

-- Q4. Write a query to display toatl orders of " priya sharma "  in the restauent name Pista House.
use zomato;
SELECT 
    c.customer_name AS cname,
    r.restaurant_name AS rname,
    COUNT(o.order_item) AS total_orders
FROM customers c
JOIN orders o 
    ON c.customer_id = o.customer_id
JOIN rest r 
    ON o.restaurant_id = r.restaurant_id
WHERE c.customer_name= 'Priya Sharma'
  AND r.restaurant_name = 'Pista House'
GROUP BY c.customer_name, r.restaurant_name;

-- Q5.Write a query to identify the time slots during which the most orders are placed. based on 2-hour intervals.
use zomato;
select
case
	when extract(hour from order_time) between 0 and 1 then '00:00-02:00'
	when extract(hour from order_time) between 2 and 3 then '02:00-04:00'
	when extract(hour from order_time) between 4 and 5 then '04:00-06:00'
	when extract(hour from order_time) between 6 and 7 then '06:00-08:00'
	when extract(hour from order_time) between 8 and 9 then '08:00-10:00'
    when extract(hour from order_time) between 10 and 11 then '10:00-12:00'
    when extract(hour from order_time) between 12 and 13 then '12:00-14:00'
    when extract(hour from order_time) between 14 and 15 then '14:00-16:00'
    when extract(hour from order_time) between 16 and 17 then '16:00-18:00'
    when extract(hour from order_time) between 18 and 19 then '18:00-20:00'
    when extract(hour from order_time) between 20 and 21 then '20:00-22:00'
    when extract(hour from order_time) between 22 and 23 then '22:00-00:00'
end as  time_slot,
count(order_id) as order_count
from orders
group by time_slot
order by order_count desc
;

-- Q6.Write a query to find average order value per customer who has placed more than 750 orders.
-- return the customer_name,and customer_id
select c.customer_name,
avg(o.total_amount) as aov
from customers as c
	join orders as o
    on c.customer_id=o.customer_id
group by 1
having count(o.order_item)>750;
;

-- Q7. Write a query to dispaly list of customers who have spent more than 10K in toatal on food orders.
-- return customer_name,customer_id
select c.customer_name,c.customer_id,
round(sum(o.total_amount),2) as total_spent 
from customers as c
	join orders as o
    on c.customer_id=o.customer_id
group by 1,2
having sum(o.total_amount)>10000
order by 3 desc
;

-- Q8. Write a query to display to find the top 3 customers who spent height amount in each month.
-- return the customer_name
WITH monthly_spending AS (
    SELECT 
        EXTRACT(YEAR FROM o.order_date) AS year,
        EXTRACT(MONTH FROM o.order_date) AS month,
        c.customer_name,
        SUM(o.total_amount) AS total_spent,
        RANK() OVER (
            PARTITION BY EXTRACT(YEAR FROM o.order_date), EXTRACT(MONTH FROM o.order_date)
            ORDER BY SUM(o.total_amount) DESC) AS rankk
    FROM customers AS c
    JOIN orders AS o 
        ON c.customer_id = o.customer_id
    GROUP BY year, month, c.customer_name
)
SELECT year, month, customer_name, total_spent
FROM monthly_spending
WHERE rankk <= 3
ORDER BY year, month, total_spent DESC;

-- Q9.Write a query to display to find the ordres were placed but not delvivered.
-- return the rest name, city name and no.of not delivered orders
SELECT
    r.restaurant_name,
    r.city,
    COUNT(*) AS not_delivered_orders
FROM orders o
JOIN rest r
    ON o.restaurant_id = r.restaurant_id
JOIN delveries d
    ON o.order_id = d.order_id
WHERE d.delivery_status = 'Not Delivered'
GROUP BY r.restaurant_name, r.city;

-- Q10.Calculate the total revenue generated by each customer over all their orders.
-- return the customer name,id and CLV(customer lifetime value)
use zomato;
select 
c.customer_id,c.customer_name,
sum(o.total_amount) as CLV
from orders as o
	join customers as c
	on o.customer_id=c.customer_id
group by 1,2;