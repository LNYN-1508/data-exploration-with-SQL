-- I have create schema project
SET search_path = project;

-- DATA EXPLORATION
-- A. Pizza Metrics
-- 1. How many pizzas were ordered?
SELECT COUNT(pizza_id) AS pizza_amounts
FROM customer_orders;


-- 2. How many unique customer orders were made?
SELECT COUNT(DISTINCT order_id) AS total_unique_orders
FROM customer_orders
;


-- 3. How many successful orders were delivered by each runner?
SELECT runner_id, COUNT(order_id) AS successful_delivery
FROM runner_orders
WHERE cancellation IS NULL
GROUP BY runner_id;


-- 4. How many of each type of pizza was delivered?
SELECT pizza_id, COUNT(pizza_id)
FROM customer_orders c
JOIN runner_orders r ON c.order_id = r.order_id
WHERE r.cancellation IS NULL
GROUP BY pizza_id; 


-- 5. How many Vegetarian and Meatlovers were ordered by each customer?
-- SELECT c.customer_id, p.pizza_name, COUNT(c.pizza_id) AS count_type_pizza
-- FROM customer_orders c 
-- JOIN pizza_names p ON c.pizza_id = p.pizza_id
-- GROUP BY c.customer_id, p.pizza_name
-- ORDER BY c.customer_id;

SELECT customer_id, 
	SUM(CASE WHEN pizza_id = 1 THEN 1 ELSE 0 END) AS total_meatlover,
	SUM(CASE WHEN pizza_id = 2 THEN 1 ELSE 0 END) AS total_vegetarian
FROM customer_orders
GROUP BY customer_id
ORDER BY customer_id;


-- 6. What was the maximum number of pizzas delivered in a single order?
SELECT r.order_id, COUNT(c.order_id) AS total_orders
FROM customer_orders c
JOIN runner_orders r ON c.order_id = r.order_id
WHERE r.pickup_time IS NOT NULL
GROUP BY r.order_id
ORDER BY 1;


-- 7. For each customer, how many delivered pizzas had at least 1 change 
-- and how many had no changes?
SELECT c.customer_id,
	SUM(CASE WHEN c.exclusions IS NULL AND c.extras IS NULL THEN 1 ELSE 0 END) AS no_changes,
	SUM(CASE WHEN c.exclusions IS NOT NULL OR c.extras IS NOT NULL THEN 1 ELSE 0 END) AS at_least_1_change
FROM customer_orders c
JOIN runner_orders r 
	ON c.order_id = r.order_id
WHERE cancellation IS NULL
GROUP BY c.customer_id
ORDER BY 1; 

-- This method uses CTE, i think it will be faster
with cte AS (
SELECT c.customer_id,
	CASE WHEN c.exclusions IS NOT NULL OR c.extras IS NOT NULL THEN 1 ELSE 0 END AS at_least_1_change,
	CASE WHEN c.exclusions IS NULL AND c.extras IS NULL THEN 1 ELSE 0 END AS no_changes
FROM customer_orders c
JOIN runner_orders r 
	ON c.order_id = r.order_id
WHERE cancellation IS NULL
)

SELECT customer_id,
	SUM(at_least_1_change),
	SUM(no_changes)
FROM cte
GROUP BY customer_id
ORDER BY 1;


-- 8. How many pizzas were delivered that had both exclusions and extras?
SELECT c.customer_id,
	SUM(CASE WHEN c.exclusions <> '' AND c.extras <> '' THEN 1 ELSE 0 END) AS exclusions_extras
FROM customer_orders c
JOIN runner_orders r
	ON c.order_id = r.order_id
WHERE r.cancellation IS NULL
GROUP BY c.customer_id
ORDER BY 1;
	
-- 9. What was the total volume of pizzas ordered for each hour of the day?
SELECT 
	DATE_TRUNC('hour', order_time) AS order_hour,
	COUNT(order_id) AS total_pizzas
FROM customer_orders
GROUP BY order_hour
ORDER BY 1;
 

-- 10. What was the volume of orders for each day of the week?
with cte AS (
	SELECT 
		EXTRACT(DOW FROM order_time) AS day_of_week,
		COUNT(order_id) AS order_count
	FROM customer_orders
	GROUP BY day_of_week
	ORDER BY 1
)

SELECT 
	CASE 
		WHEN day_of_week = 0 THEN 'Sunday'
		WHEN day_of_week = 1 THEN 'Monday'
		WHEN day_of_week = 2 THEN 'Tuesday'
		WHEN day_of_week = 3 THEN 'Wednesday'
		WHEN day_of_week = 4 THEN 'Thursday'
		WHEN day_of_week = 5 THEN 'Friday'
		WHEN day_of_week = 6 THEN 'Saturday'
	END AS day_of_week,
	order_count
FROM cte;












