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

-- B. Runner and Customer Experience
-- 1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
WITH RECURSIVE weekly_dates AS (
    SELECT 
        '2021-01-01'::timestamp AS week_start,
        ('2021-01-01'::timestamp + interval '7 days') AS week_end
    UNION ALL
    SELECT 
        week_start + interval '7 days' AS week_start,
        week_end + interval '7 days' AS week_end
    FROM 
        weekly_dates
    WHERE 
        week_start + interval '7 days' <= (SELECT max(registration_date) FROM runners)
),
signup_counts AS (
    SELECT
        wd.week_start::date AS week_start,
        count(*) AS signups
    FROM
        weekly_dates wd
    LEFT JOIN
       	runners r
    ON
        r.registration_date >= wd.week_start
    AND
        r.registration_date < wd.week_end
    GROUP BY
        wd.week_start
)
SELECT
    week_start,
    signups
FROM
    signup_counts
ORDER BY
    week_start;

	

SELECT 
	COUNT(runner_id),
	CEILING((registration_date - '2021-01-01'::date) / 7) AS week_number
FROM runners
GROUP BY week_number;


-- 2. What was the average time in minutes it took 
--    for each runner to arrive at the Pizza Runner HQ to pickup the order?
WITH order_durations AS (
    SELECT
        ro.runner_id,
        EXTRACT(EPOCH FROM (ro.pickup_time::TIMESTAMP - co.order_time::TIMESTAMP)) / 60.0 AS duration_in_minutes
    FROM
        runner_orders ro
    JOIN
        customer_orders co ON ro.order_id = co.order_id
    WHERE
        ro.pickup_time IS NOT NULL
        AND ro.cancellation IS NULL
)
SELECT
    runner_id,
    ROUND(AVG(duration_in_minutes), 2) AS average_duration
FROM
    order_durations
GROUP BY
    runner_id
ORDER BY
    runner_id;


-- 3. Is there any relationship between the number of pizzas 
-- 	  and how long the order takes to prepare?
SELECT 
	c.order_id,
	COUNT(c.order_id) AS count_order,
	c.order_time,
	r.pickup_time,
	EXTRACT(EPOCH FROM (r.pickup_time::TIMESTAMP - c.order_time::TIMESTAMP)) / 60.0 AS different_in_mins,
	CASE 
		WHEN COUNT(c.order_id) = 1 THEN 'Takes more than 10 mins to make an order'
		WHEN COUNT(c.order_id) > 1 THEN 'The time increases based on the orders but still around or more than 10 mins for 1 order'
	END AS relationship
FROM customer_orders c
JOIN runner_orders r 
	ON c.order_id = r.order_id AND pickup_time IS NOT NULL
GROUP BY c.order_id, order_time, r.pickup_time
ORDER BY 1;


-- 4. What was the average distance travelled for each customer?
SELECT 
	c.customer_id,
	ROUND(AVG(distance_km),2) AS avg_distance
FROM customer_orders c
LEFT JOIN runner_orders r
	ON c.order_id = r.order_id
GROUP BY c.customer_id;


-- 5. What was the difference between the longest and shortest delivery times for all orders?
SELECT 
	MAX(duration_mins) AS max_duration,
	MIN(duration_mins) AS min_duration,
	MAX(duration_mins) - MIN(duration_mins) AS difference_in_mins
FROM runner_orders;


-- 6. What was the average speed for each runner for each delivery 
-- 	  and do you notice any trend for these values?
SELECT 
	runner_id,
	ROUND(avg(distance_km),2) AS avg_distance,
	ROUND(avg(duration_mins),2) AS avg_duration
FROM runner_orders
GROUP BY runner_id
ORDER BY 1;


-- 7. What is the successful delivery percentage for each runner?
with cte AS (SELECT 
			 	runner_id,
				COUNT(order_id) AS count_with_null
			 FROM runner_orders
			 WHERE pickup_time IS NULL
			 GROUP BY runner_id
		 	 ORDER BY 1)
			 
SELECT 
	r.runner_id,
	COUNT(r.order_id),
	cte.runner_id,
	cte.count_with_null
FROM runner_orders r
LEFT JOIN cte
	ON r.runner_id = cte.runner_id
GROUP BY r.runner_id, cte.runner_id, cte.count_with_null
ORDER BY 1;











