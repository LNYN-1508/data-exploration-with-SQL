-- I have create schema project

CREATE TABLE project.runners (
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
  "order_time" TIMESTAMP
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


-- CLEANING DATA

-- 1. Clean table customer_orders
SELECT * FROM customer_orders
WHERE exclusions LIKE '%null%' OR exclusions LIKE '%nan' OR exclusions = '';

UPDATE customer_orders
SET exclusions = 
	(CASE WHEN exclusions LIKE '%null%' 
	 		OR exclusions LIKE '%nan' 
	 		OR exclusions = '' THEN NULL ELSE exclusions END
	);

UPDATE customer_orders
SET extras = CASE WHEN extras = '' OR extras LIKE '%null%' THEN NULL ELSE extras END;

-- 2. Clean table runner_orders
UPDATE runner_orders
SET pickup_time = CASE WHEN pickup_time LIKE '%null%' THEN NULL ELSE pickup_time END,
	distance = CASE WHEN distance LIKE '%null%' THEN NULL ELSE distance END,
	duration = CASE WHEN duration LIKE '%null%' THEN NULL ELSE duration END,
	cancellation = CASE WHEN cancellation LIKE '%null%' OR cancellation = '' THEN NULL ELSE cancellation END
;

SELECT * FROM runner_orders;
UPDATE runner_orders
SET distance = replace(distance, 'km', '');

-- Change data type of column distance
ALTER TABLE runner_orders
ALTER COLUMN distance TYPE DECIMAL(3, 1)
USING distance::DECIMAL(3, 1);

-- Just take the number for easier query so I delete anything that is not number
-- And change data type of column duration
UPDATE runner_orders
SET duration = TRIM(regexp_replace(duration, 'minutes|mins|minute', ''));

ALTER TABLE runner_orders
ALTER COLUMN duration TYPE INT
USING duration::INT;

ALTER TABLE runner_orders
RENAME COLUMN distance TO distance_km;

ALTER TABLE runner_orders
RENAME COLUMN duration TO duration_mins;

-- SELECT * FROM runner_orders;


-- 3. Clean table pizza_recipes
-- SELECT * FROM pizza_recipes;
-- The toppings column is comma-separated so I want to explode it to row by row
CREATE TEMP TABLE temp_pizza_recipes (
	pizza_id INT,
	topping_id TEXT
);

INSERT INTO temp_pizza_recipes (pizza_id, topping_id)
SELECT 
    pizza_id,
    unnest(string_to_array(toppings, ',')::INT[])
FROM pizza_recipes;

-- Delete all data of table pizza_recipes
TRUNCATE TABLE pizza_recipes;

-- Insert data into table pizza_recipes
INSERT INTO pizza_recipes (pizza_id, toppings)
SELECT pizza_id, topping_id FROM temp_pizza_recipes;

DROP TABLE IF EXISTS temp_pizza_recipes;

-- Change data type
ALTER TABLE pizza_recipes
ALTER COLUMN toppings TYPE INT
USING toppings::INT;
-- SELECT * FROM pizza_recipes;
