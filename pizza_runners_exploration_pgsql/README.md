# 🍕 Case Study #1 - Pizza Runner
- https://8weeksqlchallenge.com/case-study-2/
<p align="center">
<img src="https://github.com/ndleah/8-Week-SQL-Challenge/blob/main/IMG/org-2.png" width=40% height=40%>


## 📂 Dataset
Danny has shared with you 6 key datasets for this case study:

### **```runners```**
<details>
<summary>
View table
</summary>

The runners table shows the **```registration_date```** for each new runner.



|runner_id|registration_date|
|---------|-----------------|
|1        |1/1/2021         |
|2        |1/3/2021         |
|3        |1/8/2021         |
|4        |1/15/2021        |



</details>


### **```customer_orders```**

<details>
<summary>
View table
</summary>

Customer pizza orders are captured in the **```customer_orders```** table with 1 row for each individual pizza that is part of the order.

|order_id|customer_id|pizza_id|exclusions|extras|order_time          |
|--------|-----------|--------|----------|------|---------------------|
|1       |101        |1       |          |      |2021-01-01 18:05:02  |
|2       |101        |1       |          |      |2021-01-01 19:00:52  |
|3       |102        |1       |          |      |2021-01-02 23:51:23  |
|3       |102        |2       |          |NaN   |2021-01-02 23:51:23  |
|4       |103        |1       |4         |      |2021-01-04 13:23:46  |
|4       |103        |1       |4         |      |2021-01-04 13:23:46  |
|4       |103        |2       |4         |      |2021-01-04 13:23:46  |
|5       |104        |1       |null      |1     |2021-01-08 21:00:29  |
|6       |101        |2       |null      |null  |2021-01-08 21:03:13  |
|7       |105        |2       |null      |1     |2021-01-08 21:20:29  |
|8       |102        |1       |null      |null  |2021-01-09 23:54:33  |
|9       |103        |1       |4         |1, 5  |2021-01-10 11:22:59  |
|10      |104        |1       |null      |null  |2021-01-11 18:34:49  |
|10      |104        |1       |2, 6      |1, 4  |2021-01-11 18:34:49  |


</details>

### **```runner_orders```**

<details>
<summary>
View table
</summary>

After each orders are received through the system - they are assigned to a runner - however not all orders are fully completed and can be cancelled by the restaurant or the customer.

The **```pickup_time```** is the timestamp at which the runner arrives at the Pizza Runner headquarters to pick up the freshly cooked pizzas. 

The **```distance```** and **```duration```** fields are related to how far and long the runner had to travel to deliver the order to the respective customer.



|order_id|runner_id|pickup_time          |distance|duration   |cancellation             |
|--------|---------|---------------------|--------|-----------|-------------------------|
|1       |1        |2021-01-01 18:15:34  |20km    |32 minutes |                         |
|2       |1        |2021-01-01 19:10:54  |20km    |27 minutes |                         |
|3       |1        |2021-01-03 00:12:37  |13.4km  |20 mins    |NaN                      |
|4       |2        |2021-01-04 13:53:03  |23.4    |40         |NaN                      |
|5       |3        |2021-01-08 21:10:57  |10      |15         |NaN                      |
|6       |3        |null                 |null    |null       |Restaurant Cancellation  |
|7       |2        |2020-01-08 21:30:45  |25km    |25mins     |null                     |
|8       |2        |2020-01-10 00:15:02  |23.4 km |15 minute  |null                     |
|9       |2        |null                 |null    |null       |Customer Cancellation    |
|10      |1        |2020-01-11 18:50:20  |10km    |10minutes  |null                     |


</details>

### **```pizza_names```**

<details>
<summary>
View table
</summary>

|pizza_id|pizza_name   |
|--------|-------------|
|1       |Meat Lovers  |
|2       |Vegetarian   |


</details>

### **```pizza_recipes```**

<details>
<summary>
View table
</summary>

Each **```pizza_id```** has a standard set of **```toppings```** which are used as part of the pizza recipe.


|pizza_id|toppings                 |
|--------|-------------------------|
|1       |1, 2, 3, 4, 5, 6, 8, 10  |
|2       |4, 6, 7, 9, 11, 12       |


</details>

### **```pizza_toppings```**

<details>
<summary>
View table
</summary>

This table contains all of the **```topping_name```** values with their corresponding **```topping_id```** value.


|topping_id|topping_name|
|----------|------------|
|1         |Bacon       |
|2         |BBQ Sauce   |
|3         |Beef        |
|4         |Cheese      |
|5         |Chicken     |
|6         |Mushrooms   |
|7         |Onions      |
|8         |Pepperoni   |
|9         |Peppers     |
|10        |Salami      |
|11        |Tomatoes    |
|12        |Tomato Sauce|


</details>

<details>
<summary>
View Entity Relationship Diagram
</summary>
  <p align="center">
<img src="project_ERD.png" width=80% height=80%></p>
</details>

---

## ♻️ Data Cleaning

<details>
<summary>
Create table
</summary>
  
- This is the raw data
  
** **
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

</details>

<details>
<summary>
Cleaning data
</summary>
  
## Clean customer_orders data:

- With this table, the only dirty elements are the inappropriate 'null' values. Therefore, I will replace all of them with 'NULL'

** ** 
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

### Before

|order_id|customer_id|pizza_id|exclusions|extras|order_time          |
|--------|-----------|--------|----------|------|---------------------|
|1       |101        |1       |          |      |2021-01-01 18:05:02  |
|2       |101        |1       |          |      |2021-01-01 19:00:52  |
|3       |102        |1       |          |      |2021-01-02 23:51:23  |
|3       |102        |2       |          |NaN   |2021-01-02 23:51:23  |
|4       |103        |1       |4         |      |2021-01-04 13:23:46  |
|4       |103        |1       |4         |      |2021-01-04 13:23:46  |
|4       |103        |2       |4         |      |2021-01-04 13:23:46  |
|5       |104        |1       |null      |1     |2021-01-08 21:00:29  |
|6       |101        |2       |null      |null  |2021-01-08 21:03:13  |
|7       |105        |2       |null      |1     |2021-01-08 21:20:29  |
|8       |102        |1       |null      |null  |2021-01-09 23:54:33  |
|9       |103        |1       |4         |1, 5  |2021-01-10 11:22:59  |
|10      |104        |1       |null      |null  |2021-01-11 18:34:49  |
|10      |104        |1       |2, 6      |1, 4  |2021-01-11 18:34:49  |

### After
|order_id|customer_id|pizza_id|exclusions|extras|order_time          |
|--------|-----------|--------|----------|------|--------------------|
|1       |101        |1       |          |      |2020-01-01 18:05:02 |
|2       |101        |1       |          |      |2020-01-01 19:00:52 |
|3       |102        |1       |          |      |2020-01-02 23:51:23 |
|3       |102        |2       |          |      |2020-01-02 23:51:23 |
|4       |103        |1       |4         |      |2020-01-04 13:23:46 |
|4       |103        |1       |4         |      |2020-01-04 13:23:46 |
|4       |103        |2       |4         |      |2020-01-04 13:23:46 |
|5       |104        |1       |          |1     |2020-01-08 21:00:29 |
|6       |101        |2       |          |      |2020-01-08 21:03:13 |
|7       |105        |2       |          |1     |2020-01-08 21:20:29 |
|8       |102        |1       |          |      |2020-01-09 23:54:33 |
|9       |103        |1       |4         |1, 5  |2020-01-10 11:22:59 |
|10      |104        |1       |          |      |2020-01-11 18:34:49 |
|10      |104        |1       |2, 6      |1, 4  |2020-01-11 18:34:49 |

## Clean runner_orders data:
- There are 2 elements that are considered as 'dirty' data:
  - Inapproriate null values
  - Including mixed entries like '20km' and '32mins'

** **
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

    -- Change the column name
    ALTER TABLE runner_orders
    RENAME COLUMN distance TO distance_km;
    
    ALTER TABLE runner_orders
    RENAME COLUMN duration TO duration_mins;

### Before
|order_id|runner_id|pickup_time          |distance|duration   |cancellation             |
|--------|---------|---------------------|--------|-----------|-------------------------|
|1       |1        |2021-01-01 18:15:34  |20km    |32 minutes |                         |
|2       |1        |2021-01-01 19:10:54  |20km    |27 minutes |                         |
|3       |1        |2021-01-03 00:12:37  |13.4km  |20 mins    |NaN                      |
|4       |2        |2021-01-04 13:53:03  |23.4    |40         |NaN                      |
|5       |3        |2021-01-08 21:10:57  |10      |15         |NaN                      |
|6       |3        |null                 |null    |null       |Restaurant Cancellation  |
|7       |2        |2020-01-08 21:30:45  |25km    |25mins     |null                     |
|8       |2        |2020-01-10 00:15:02  |23.4 km |15 minute  |null                     |
|9       |2        |null                 |null    |null       |Customer Cancellation    |
|10      |1        |2020-01-11 18:50:20  |10km    |10minutes  |null                     |

### After 
|order_id|runner_id|pickup_time          |distance_km|duration_mins|cancellation             |
|--------|---------|---------------------|-----------|-------------|-------------------------|
|1       |1        |2020-01-01 18:15:34  |20.0       |32           |                         |
|2       |1        |2020-01-01 19:10:54  |20.0       |27           |                         |
|3       |1        |2020-01-03 00:12:37  |13.4       |20           |                         |
|4       |2        |2020-01-04 13:53:03  |23.4       |40           |                         |
|5       |3        |2020-01-08 21:10:57  |10.0       |15           |                         |
|6       |3        |                     |           |             |Restaurant Cancellation  |
|7       |2        |2020-01-08 21:30:45  |25.0       |25           |                         |
|8       |2        |2020-01-10 00:15:02  |23.4       |15           |                         |
|9       |2        |                     |           |             |Customer Cancellation    |
|10      |1        |2020-01-11 18:50:20  |10.0       |10           |                         |


## Clean pizza_recipes data:

- The 'topping' column is comma-seperated, it will be hard to query so i will explode it

** ** 
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

### Before
|pizza_id|toppings                 |
|--------|-------------------------|
|1       |1, 2, 3, 4, 5, 6, 8, 10  |
|2       |4, 6, 7, 9, 11, 12       |

### After 
|pizza_id|toppings   |
|--------|-----------|
|1       |1          |
|1       |2          |
|1       |3          |
|1       |4          |
|1       |5          |
|1       |6          |
|1       |8          |
|1       |10         |
|2       |4          |
|2       |6          |
|2       |7          |
|2       |9          |
|2       |11         |
|2       |12         |

### Other 3 tables are clean enough
[![View Data Exploration Folder](https://img.shields.io/badge/Creating_And_Cleaning_Datasets-007BFF?style=for-the-badge&logo=GITHUB)](https://github.com/LNYN-1508/data-exploration-with-SQL/blob/main/pizza_runners_exploration_pgsql/creata_table_and_cleaning.sql)
</details>

---

## 🔍 Data Exploration

<details>
<summary> 
Pizza Metrics
</summary>
  
### **Q1. How many pizzas were ordered?**
```sql
SELECT COUNT(pizza_id) AS pizza_amounts
FROM customer_orders;
```
|pizza_amounts|
|-------------|
|14           |

### **Q2. How many unique customer orders were made?**
```sql
SELECT COUNT(DISTINCT order_id) AS total_unique_orders
FROM customer_orders;
```
|total_unique_orders|
|-------------------|
|10                 |

### **Q3. How many successful orders were delivered by each runner?**
```sql
SELECT runner_id, COUNT(order_id) AS successful_delivery
FROM runner_orders
WHERE cancellation IS NULL
GROUP BY runner_id;
```
|runner_id|successful_delivery|
|---------|-------------------|
|1        |4                  |
|2        |3                  |
|3        |1                  |

### **Q4. How many of each type of pizza was delivered?**
```sql
SELECT pizza_id, COUNT(pizza_id)
FROM customer_orders c
JOIN runner_orders r ON c.order_id = r.order_id
WHERE r.cancellation IS NULL
GROUP BY pizza_id; 
```
|pizza_id|count|
|--------|-----|
|1       |9    |
|2       |3    |

### **Q5. How many Vegetarian and Meatlovers were ordered by each customer?**
```sql
SELECT customer_id, 
	SUM(CASE WHEN pizza_id = 1 THEN 1 ELSE 0 END) AS total_meatlover,
	SUM(CASE WHEN pizza_id = 2 THEN 1 ELSE 0 END) AS total_vegetarian
FROM customer_orders
GROUP BY customer_id
ORDER BY customer_id;
```
|customer_id|total_meatlover|total_vegetarian|
|-----------|---------------|----------------|
|101        |2              |1               |
|102        |2              |1               |
|103        |3              |1               |
|104        |3              |0               |
|105        |0              |1               |

### **Q6. What was the maximum number of pizzas delivered in a single order?**
```sql
SELECT r.order_id, COUNT(c.order_id) AS total_orders
FROM customer_orders c
JOIN runner_orders r
  ON c.order_id = r.order_id
WHERE r.pickup_time IS NOT NULL
GROUP BY r.order_id
ORDER BY 1;
```
|order_id|total_orders|
|--------|------------|
|1       |1           |
|2       |1           |
|3       |2           |
|4       |3           |
|5       |1           |
|7       |1           |
|8       |1           |
|10      |2           |

### **Q7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?**
```sql
SELECT c.customer_id,
	SUM(CASE WHEN c.exclusions IS NULL AND c.extras IS NULL THEN 1 ELSE 0 END) AS no_changes,
	SUM(CASE WHEN c.exclusions IS NOT NULL OR c.extras IS NOT NULL THEN 1 ELSE 0 END) AS at_least_1_change
FROM customer_orders c
JOIN runner_orders r 
	ON c.order_id = r.order_id
WHERE cancellation IS NULL
GROUP BY c.customer_id
ORDER BY 1; 
```
OR 
```sql
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
	SUM(at_least_1_change) AS at_least_1_change,
	SUM(no_changes) AS no_changes
FROM cte
GROUP BY customer_id
ORDER BY 1;
```
|customer_id|at_least_1_change|no_changes|
|-----------|-----------------|----------|
|101        |0                |2         |
|102        |0                |3         |
|103        |3                |0         |
|104        |2                |1         |
|105        |1                |0         |

### **Q8. How many pizzas were delivered that had both exclusions and extras?**
```sql
SELECT customer_id,
	SUM(CASE WHEN c.exclusions <> '' AND c.extras <> '' THEN 1 ELSE 0 END) AS exclusions_extras_count
FROM customer_orders c
JOIN runner_orders r
	ON c.order_id = r.order_id
WHERE r.cancellation IS NULL
GROUP BY c.customer_id
ORDER BY 2 DESC; 
```
|customer_id|exclusions_extras_count|
|-----------|-----------------------|
|104        |1                      |
|101        |0                      |
|102        |0                      |
|103        |0                      |
|105        |0                      |

### **Q9. What was the total volume of pizzas ordered for each hour of the day?**
```sql
SELECT 
	DATE_TRUNC('hour', order_time) AS order_hour,
	COUNT(order_id) AS total_pizzas
FROM customer_orders
GROUP BY order_hour
ORDER BY 1;
```
|order_hour         |total_pizzas|
|-------------------|------------|
|2020-01-01 18:00:00|1           |
|2020-01-01 19:00:00|1           |
|2020-01-02 23:00:00|2           |
|2020-01-04 13:00:00|3           |
|2020-01-08 21:00:00|3           |
|2020-01-09 23:00:00|1           |
|2020-01-10 11:00:00|1           |
|2020-01-11 18:00:00|2           |

### **Q10. What was the volume of orders for each day of the week?**
```sql
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
```
|day_of_week|order_count|
|-----------|-----------|
|Wednesday  |5          |
|Thursday   |3          |
|Friday     |1          |
|Saturday   |5          |

</details>

