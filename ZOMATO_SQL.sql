DROP TABLE IF EXISTS deliveries;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS restaurants;
DROP TABLE IF EXISTS riders;


CREATE TABLE restaurants (
    restaurant_id SERIAL PRIMARY KEY,
    restaurant_name VARCHAR(100) NOT NULL,
    city VARCHAR(50),
    opening_hours VARCHAR(50)
);

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    reg_date DATE
);

CREATE TABLE riders (
    rider_id SERIAL PRIMARY KEY,
    rider_name VARCHAR(100) NOT NULL,
    sign_up DATE
);

CREATE TABLE Orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT,
    restaurant_id INT,
    order_item VARCHAR(255),
    order_date DATE NOT NULL,
    order_time TIME NOT NULL,
    order_status VARCHAR(20) DEFAULT 'Pending',
    total_amount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id)
);

CREATE TABLE deliveries (
    delivery_id SERIAL PRIMARY KEY,
    order_id INT,
    delivery_status VARCHAR(20) DEFAULT 'Pending',
    delivery_time TIME,
    rider_id INT,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (rider_id) REFERENCES riders(rider_id)
);

SELECT * FROM customers;
SELECT * FROM deliveries;
SELECT * FROM orders;
SELECT * FROM restaurants;
SELECT * FROM riders;






-- Write a query to find the top 5_most frequently ordered dishes by customer called "Arjun Mehta" in the last 1 year.



WITH rankedish
(
select customers.customer_name,
orders.order_item
from orders 
join 
customers 
on orders.customer_id = customers.customer_id
)

SELECT
    customer_name,
    dishes,
    total_orders
FROM
    RankedOrders

select * from orders
where customer_id = 1
and order_item = 'Burger'
group by order_id


-- Popular Time Slots
-- Question: Identify the time slots during which the most orders are placed.

select count(order_id) ,
EXTRACT(HOUR FROM order_time) AS order_hour
from orders
GROUP BY( EXTRACT(HOUR FROM order_time))
ORDER BY  order_hour


-- Order Value Analysis
-- Question: Find the average order value per customer who has placed more than 750 orders.
-- Return customer_name, and aov(average order value)

SELECT customer_id , 
COUNT(order_id) AS total
FROM 
orders
GROUP BY customer_id 
ORDER BY total

SELECT
	customers.customer_name,
	AVG(orders.total_amount) as aov
FROM orders 
	JOIN customers 
	ON customers.customer_id = orders.customer_id
GROUP BY customers.customer_name
HAVING  COUNT(order_id) > 750;


-- Question: List the customers who have spent more than 100K in total on food orders.
-- return customer_name, and customer_id!

SELECT
	customers.customer_id,
	customers.customer_name,
	sum(orders.total_amount) 
FROM orders 
	JOIN customers 
	ON customers.customer_id = orders.customer_id
GROUP BY customers.customer_name , customers.customer_id
HAVING  sum(orders.total_amount) > 200000;

-- Question: Write a query to find orders that were placed but not delivered. 
-- Return each restuarant name, city and number of not delivered orders 

SELECT DISTINCT order_status FROM orders;

SELECT DISTINCT delivery_status FROM deliveries;  --"Delivered" "Not Delivered" "Order"

SELECT
restaurants.restaurant_name,
restaurants.city,
COUNT(deliveries.delivery_status) AS C
FROM orders
JOIN 
deliveries
ON orders.order_id = deliveries.order_id
JOIN restaurants 
on restaurants.restaurant_id  = orders.restaurant_id
WHERE deliveries.delivery_status = 'Not Delivered'
GROUP BY restaurants.restaurant_name,restaurants.city
ORDER BY C DESC;




-- Most Popular Dish by City: 
-- Identify the most popular dish in each city based on the number of orders.
SELECT * FROM
(
SELECT
DISTINCT orders.order_item,
restaurants.city,
COUNT(order_id) as total_orders,
RANK() 
OVER(PARTITION BY restaurants.city ORDER BY COUNT(order_id) DESC) as rank

FROM orders
RIGHT JOIN 
restaurants

ON restaurants.restaurant_id  = orders.restaurant_id
GROUP BY restaurants.city, orders.order_item
)

WHERE rank =1 

SELECT DISTINCT city FROM restaurants


-- Find customers who haven’t placed an order in 2024 but did in 2023.
-- find cx who has done orders in 2023
-- find cx who has not done orders in 2024
-- compare 1 and 2

SELECT * FROM
(
SELECT customers.customer_name,
EXTRACT(YEAR FROM orders.order_date) AS order_year 
FROM customers
JOIN orders
ON customers.customer_id =  orders.customer_id
WHERE EXTRACT(YEAR FROM orders.order_date) = 2023
GROUP BY 
customers.customer_name,
orders.order_id,
EXTRACT(YEAR FROM orders.order_date) 
)
AS t
WHERE t.customer_name 
NOT IN 
(SELECT customers.customer_name
FROM customers
JOIN orders
ON customers.customer_id =  orders.customer_id
WHERE EXTRACT(YEAR FROM orders.order_date) = 2024)


-- Rank restaurants by their total revenue from the last year, including their name, 
-- total revenue, and rank within their city.

SELECT restaurants.restaurant_name,
restaurants.city,
SUM(orders.total_amount),
RANK() 
OVER(PARTITION BY restaurants.city ORDER BY SUM(orders.total_amount) DESC) as rank
FROM restaurants
join orders
on restaurants.restaurant_id = orders.restaurant_id
where extract(year from orders.order_date) = 2023
group by restaurants.restaurant_name,
restaurants.city

select distinct restaurant_name from restaurants
select * from orders



-- Determine each rider's average delivery time.

select * from deliveries

SELECT riders.rider_id, 
AVG(deliveries.delivery_time - orders.order_time)
from deliveries
join riders
on riders.rider_id = deliveries.rider_id 
join orders
on orders.order_id = deliveries.order_id
group by riders.rider_id
order by riders.rider_id asc



-- Calculate and compare the order cancellation rate for each restaurant between the 
-- current year and the previous year.
SELECT DISTINCT order_status FROM orders

WITH FY_2023 AS(
SELECT 
restaurants.restaurant_name,
((SELECT COUNT(orders.order_id) FROM orders
WHERE orders.order_status = 'Not Fulfilled'
AND 
EXTRACT(YEAR FROM orders.order_date) = 2023)*1.0/COUNT(orders.order_id)) AS CR_2023
FROM orders
JOIN restaurants
ON orders.restaurant_id = restaurants.restaurant_id
WHERE EXTRACT(YEAR FROM orders.order_date) = 2023
GROUP BY restaurants.restaurant_name
),

FY_2024 AS(
SELECT 
restaurants.restaurant_name,
((SELECT COUNT(orders.order_id) FROM orders
WHERE orders.order_status = 'Not Fulfilled' AND
EXTRACT(YEAR FROM orders.order_date) = 2024
)*1.0 /COUNT(orders.order_id))AS CR_2024
FROM orders
JOIN restaurants
ON orders.restaurant_id = restaurants.restaurant_id
WHERE EXTRACT(YEAR FROM orders.order_date) = 2024
GROUP BY restaurants.restaurant_name
)


SELECT FY_2023.restaurant_name,
FY_2023.CR_2023,
FY_2024.CR_2024
FROM FY_2023
JOIN FY_2024
ON FY_2023.restaurant_name = FY_2024.restaurant_name
;


-- Rider Monthly Earnings: 
-- Calculate each rider's total monthly earnings, assuming they earn 8% of the order amount.

SELECT deliveries.rider_id ,EXTRACT(MONTH FROM orders.order_date) AS  MONTH,
SUM(orders.total_amount *0.08) AS riders_earning
FROM deliveries
JOIN orders 
ON deliveries.order_id = orders.order_id 
GROUP BY deliveries.rider_id,
EXTRACT( MONTH FROM orders.order_date)
ORDER BY  deliveries.rider_id, EXTRACT( MONTH FROM orders.order_date)


-- Rider Ratings Analysis: 
-- Find the number of 5-star, 4-star, and 3-star ratings each rider has.
-- riders receive this rating based on delivery time.
-- If orders are delivered less than 15 minutes of order received time the rider get 5 star rating,
-- if they deliver 15 and 20 minute they get 4 star rating 
-- if they deliver after 20 minute they get 3 star rating.
SELECT 
	rider_id,
	stars,
	COUNT(*) as total_stars
FROM
(
	SELECT
		rider_id,
		delivery_took_time,
		CASE 
			WHEN delivery_took_time < 15 THEN '5 star'
			WHEN delivery_took_time BETWEEN 15 AND 20 THEN '4 star'
			ELSE '3 star'
		END as stars
		
	FROM
	(
		SELECT 
			o.order_id,
			o.order_time,
			d.delivery_time,
			EXTRACT(EPOCH FROM (d.delivery_time - o.order_time + 
			CASE WHEN d.delivery_time < o.order_time THEN INTERVAL '1 day' 
			ELSE INTERVAL '0 day' END
			))/60 as delivery_took_time,
			d.rider_id
		FROM orders as o
		JOIN deliveries as d
		ON o.order_id = d.order_id
		WHERE delivery_status = 'Delivered'
	) as t1
) as t2
GROUP BY 1, 2
ORDER BY 1, 3 DESC




-- Monthly Restaurant Growth Ratio: 
-- Calculate each restaurant's growth ratio based on the total number of delivered orders since its joining

SELECT restaurants.restaurant_id ,EXTRACT(MONTH FROM orders.order_date) AS  MONTH,
COUNT(orders.order_id) 
FROM restaurants
JOIN orders 
ON restaurants.restaurant_id = orders.restaurant_id 
GROUP BY restaurants.restaurant_id,
EXTRACT( MONTH FROM orders.order_date)
ORDER BY restaurants.restaurant_id, EXTRACT( MONTH FROM orders.order_date)


-- Customer Segmentation: 
-- Customer Segmentation: Segment customers into 'Gold' or 'Silver' groups based on their total spending 
-- compared to the average order value (AOV). If a customer's total spending exceeds the AOV, 
-- label them as 'Gold'; otherwise, label them as 'Silver'. Write an SQL query to determine each segment's 
-- total number of orders and total revenue

-- cx total spend
-- aov
-- gold
-- silver
-- each category and total orders and total rev


SELECT AVG(total_amount) AS AVG FROM orders -- 322.82

SELECT customer_id,
labels,
COUNT(*) AS total
FROM
(select 
customer_id,
total_amount,
case 
when total_amount > 322.82 then 'gold'
when total_amount <= 322.82 then 'silver'
end as labels
from orders
)
group by customer_id, labels
order by customer_id 


-- Order Frequency by Day: 
-- Analyze order frequency per day of the week and identify the peak day for each restaurant.

SELECT restaurant_id, EXTRACT(WEEK FROM order_date),
COUNT(order_id)
FROM orders
GROUP BY restaurant_id, EXTRACT(WEEK FROM order_date)
ORDER BY restaurant_id, EXTRACT(WEEK FROM order_date)



-- another function
SELECT restaurant_id, DATE_TRUNC('week', order_date),
COUNT(order_id)
FROM orders
GROUP BY restaurant_id, DATE_TRUNC('week', order_date)  
ORDER BY restaurant_id, DATE_TRUNC('week', order_date)  

-- SELECT restaurant_id,
-- select(
-- extract(WEEK from order_date),
-- count(order_id) 
-- from orders 
-- where count(order_id) is max
-- )
-- count(order_id)
-- from orders
-- group by restaurant_id, extract(WEEK from order_date)
-- order by restaurant_id, extract(WEEK from order_date)


-- select max(order_date), min(order_date)
-- from orders


-- Customer Lifetime Value (CLV): 
-- Calculate the total revenue generated by each customer over all their orders.
SELECT 
orders.customer_id,
customers.customer_name,
SUM(orders.total_amount) as CLV
FROM orders 
JOIN customers
ON orders.customer_id = customers.customer_id
GROUP BY orders.customer_id,
customers.customer_name
order by orders.customer_id

-- Monthly Sales Trends: 
-- Identify sales trends by comparing each month's total sales to the previous month.
SELECT 
EXTRACT(YEAR FROM order_date) as year,
EXTRACT(MONTH FROM order_date) as month,
SUM(total_amount) as total_sale,
LAG(SUM(total_amount), 1) OVER(ORDER BY EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date)) as prev_month_sale
FROM orders
GROUP BY 1, 2


-- Rank each city based on the total revenue for last year 2023 

SELECT 
r.city,
SUM(total_amount) as total_revenue,
RANK() OVER(ORDER BY SUM(total_amount) DESC) as city_rank
FROM orders as o
JOIN
restaurants as r
ON o.restaurant_id = r.restaurant_id
GROUP BY r.city

-- Order Item Popularity: 
-- Track the popularity of specific order items over time and identify seasonal demand spikes.

SELECT * FROM
(
SELECT orders.order_item,
EXTRACT(YEAR FROM orders.order_date) AS year,
EXTRACT(MONTH FROM orders.order_date) AS MONTH,
COUNT(orders.order_id) AS tota_sold,
RANK()
OVER(PARTITION BY
EXTRACT(YEAR FROM orders.order_date),
EXTRACT(MONTH FROM orders.order_date) 
ORDER BY COUNT(orders.order_id) DESC) 
AS rank1
FROM orders
GROUP BY orders.order_item, 
EXTRACT(MONTH FROM orders.order_date),
EXTRACT(YEAR FROM orders.order_date)
) AS t
WHERE rank1 = 1


-- Rider Efficiency: 
-- Evaluate rider efficiency by determining average delivery times and identifying those with the lowest and highest averages.

WITH new_table
AS
(
	SELECT 
		*,
		d.rider_id as riders_id,
		EXTRACT(EPOCH FROM (d.delivery_time - o.order_time + 
		CASE WHEN d.delivery_time < o.order_time THEN INTERVAL '1 day' ELSE
		INTERVAL '0 day' END))/60 as time_deliver
	FROM orders as o
	JOIN deliveries as d
	ON o.order_id = d.order_id
	WHERE d.delivery_status = 'Delivered'
),

riders_time
AS

(
	SELECT 
		riders_id,
		AVG(time_deliver) avg_time
	FROM new_table
	GROUP BY 1
)
SELECT 
	MIN(avg_time),
	MAX(avg_time)
FROM riders_time




