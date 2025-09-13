CREATE DATABASE IF NOT EXISTS Retail_sales_analysis;
USE Retail_sales_analysis;

DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales (
    transactions_id INT PRIMARY KEY,	
    sale_date DATE,	 
    sale_time TIME,	
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(50),	
    quantiy INT, 
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);

-- Preview first 10 rows
SELECT * FROM retail_sales
LIMIT 10;

-- Count total rows
SELECT COUNT(*) AS total_rows FROM retail_sales;

-- Find rows with NULLs
SELECT * FROM retail_sales
WHERE transactions_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR gender IS NULL
   OR category IS NULL
   OR quantiy IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;

-- Delete rows with NULLs
DELETE FROM retail_sales
WHERE transactions_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR gender IS NULL
   OR category IS NULL
   OR quantiy IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;


-- Total sales count (rows)
SELECT COUNT(*) AS total_sales FROM retail_sales;

-- Unique customers
SELECT COUNT(DISTINCT customer_id) AS unique_customers FROM retail_sales;

-- Categories
SELECT DISTINCT category FROM retail_sales;

-- Q1: Sales made on 2022-11-05
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q2: Clothing sales with quantity > 4 in Nov-2022
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND DATE_FORMAT(sale_date, '%m-%y') = '11-2022'
  AND quantiy > 3;
  
  -- Q3: Total sales per category
  SELECT 
    category,
    SUM(total_sale) AS net_sale,
    COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;

-- Q4: Avg age of Beauty customers
SELECT 
    ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';

-- Q5: Transactions > 1000
SELECT *
FROM retail_sales
WHERE total_sale > 1000;

-- Q6: Transactions by gender & category
SELECT 
    category,
    gender,
    COUNT(*) AS total_trans
FROM retail_sales
GROUP BY category, gender
ORDER BY category;

-- Q7: Best-selling month each year (by avg sale)
SELECT year, month, avg_sale
FROM (
    SELECT 
        YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS rnk
    FROM retail_sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
) t
WHERE rnk = 1;

-- Q8: Top 5 customers by sales
SELECT 
    customer_id,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

-- Q9: Unique customers per category
SELECT 
    category,
    COUNT(DISTINCT customer_id) AS cnt_unique_customers
FROM retail_sales
GROUP BY category;

-- Q10: Orders by shift
SELECT shift, COUNT(*) AS total_orders
FROM (
    SELECT *,
        CASE
            WHEN HOUR(sale_time) < 12 THEN 'Morning'
            WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales
) t
GROUP BY shift;












