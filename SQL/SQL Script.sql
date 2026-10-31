use walmartdb;
-- for checking the tables
show tables;
-- for checking the columns
desc Walmart_Sales;

-- add primary key to table's column
alter table Walmart_Sales
add primary key(invoice_id);

-- Q1. Write a SQL query to display the top 3 categories ranked by total units sold.
with ranked_categories
as
(
select category, sum(quantity) as total_units,
rank() over(order by sum(quantity) desc) as rankk
from Walmart_Sales
group by category
)
select * from ranked_categories
where rankk <= 3;

-- Q2. Write a query to display the best category (by revenue) in each branch.
-- return the branch, city, category and revenue
with branch_category
as
(
select Branch, City, category,
round(sum(unit_price * quantity), 2) as revenue,
rank() over(partition by Branch order by sum(unit_price * quantity) desc) as rankk
from Walmart_Sales
group by Branch, City, category
)
select Branch, City, category, revenue
from branch_category
where rankk = 1
order by revenue desc;

-- Q3. Write a query to display the top 5 branches by total revenue.
-- return the branch, city, total orders, revenue and profit
select Branch, City,
count(invoice_id) as total_orders,
round(sum(unit_price * quantity), 2) as revenue,
round(sum(unit_price * quantity * profit_margin), 2) as profit
from Walmart_Sales
group by Branch, City
order by revenue desc
limit 5;

-- Q4. Write a query to find revenue, profit, profit margin and revenue share (%) of each category.
select category,
round(sum(unit_price * quantity), 2) as revenue,
round(sum(unit_price * quantity * profit_margin), 2) as profit,
round(sum(unit_price * quantity * profit_margin) / sum(unit_price * quantity) * 100, 2) as profit_margin_pct,
round(sum(unit_price * quantity) * 100 / sum(sum(unit_price * quantity)) over(), 2) as revenue_share_pct
from Walmart_Sales
group by category
order by revenue desc;

-- Q5. Write a query to compare payment methods.
-- return the payment method, total orders, total revenue and average order value
select payment_method,
count(invoice_id) as total_orders,
round(sum(unit_price * quantity), 2) as revenue,
round(avg(unit_price * quantity), 2) as avg_order_value
from Walmart_Sales
group by payment_method
order by revenue desc;

-- Q6. Write a query to identify the time slots during which the most orders are placed. based on 2-hour intervals.
select
case
	when hour(time) between 0 and 1 then '00:00-02:00'
	when hour(time) between 2 and 3 then '02:00-04:00'
	when hour(time) between 4 and 5 then '04:00-06:00'
	when hour(time) between 6 and 7 then '06:00-08:00'
	when hour(time) between 8 and 9 then '08:00-10:00'
	when hour(time) between 10 and 11 then '10:00-12:00'
	when hour(time) between 12 and 13 then '12:00-14:00'
	when hour(time) between 14 and 15 then '14:00-16:00'
	when hour(time) between 16 and 17 then '16:00-18:00'
	when hour(time) between 18 and 19 then '18:00-20:00'
	when hour(time) between 20 and 21 then '20:00-22:00'
	when hour(time) between 22 and 23 then '22:00-00:00'
end as time_slot,
count(invoice_id) as order_count,
round(sum(unit_price * quantity), 2) as revenue
from Walmart_Sales
group by time_slot
order by order_count desc;

-- Q7. Write a query to find the branches whose average rating is above the overall average rating
-- and which have at least 50 orders.
-- return the branch, city, order count and average rating
select Branch, City,
count(invoice_id) as total_orders,
round(avg(rating), 2) as avg_rating
from Walmart_Sales
group by Branch, City
having count(invoice_id) >= 50
   and avg(rating) > (select avg(rating) from Walmart_Sales)
order by avg_rating desc;

-- Q8. Write a query to find the top 3 cities by revenue in each year.
-- return the year, city and revenue
with yearly_city
as
(
select year(date) as yr, City,
round(sum(unit_price * quantity), 2) as revenue,
rank() over(partition by year(date) order by sum(unit_price * quantity) desc) as rankk
from Walmart_Sales
group by year(date), City
)
select yr, City, revenue
from yearly_city
where rankk <= 3
order by yr, revenue desc;

-- Q9. Write a query to calculate the month-over-month revenue growth (%).
-- return the year, month, revenue, previous month revenue and growth %
with monthly_revenue
as
(
select year(date) as yr, month(date) as mth,
round(sum(unit_price * quantity), 2) as revenue
from Walmart_Sales
group by year(date), month(date)
)
select yr, mth, revenue,
lag(revenue) over(order by yr, mth) as prev_month_revenue,
round((revenue - lag(revenue) over(order by yr, mth)) * 100
      / lag(revenue) over(order by yr, mth), 2) as growth_pct
from monthly_revenue
order by yr, mth;

-- Q10. Write a query to find which day of the week generates the most revenue.
-- return the day name, total orders, revenue and average order value
select dayname(date) as day_name,
count(invoice_id) as total_orders,
round(sum(unit_price * quantity), 2) as revenue,
round(avg(unit_price * quantity), 2) as avg_order_value
from Walmart_Sales
group by dayname(date), dayofweek(date)
order by revenue desc;
