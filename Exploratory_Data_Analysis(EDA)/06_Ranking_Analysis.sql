/*
===============================================================================
Step 6: Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards (TOP N / BOTTTOM N performers).

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/


-- Which 5 products Generating the Highest Revenue?
SELECT TOP 5
    p.product_name,
    SUM(s.sales_amount) AS Total_Revenue
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
GROUP BY p.product_name
ORDER BY Total_Revenue DESC

-- What are the 5 worst-performing products in terms of sales?
SELECT TOP 5
    p.product_name,
    SUM(s.sales_amount) AS Total_Revenue
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
GROUP BY p.product_name
ORDER BY Total_Revenue ASC

-- Which 5 subcategory Generating the Highest Revenue?
SELECT TOP 5
    p.subcategory,
    SUM(s.sales_amount) AS Total_Revenue
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
GROUP BY p.subcategory
ORDER BY Total_Revenue DESC

-- What are the 5 worst-performing subcategory in terms of sales?
SELECT TOP 5
    p.subcategory,
    SUM(s.sales_amount) AS Total_Revenue
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
GROUP BY p.subcategory
ORDER BY Total_Revenue ASC

-- Complex but Flexibly Ranking Using Window Functions
SELECT
    *
FROM(
    SELECT 
    p.product_name,
    SUM(s.sales_amount) AS Total_Revenue,
    RANK() OVER(ORDER BY SUM(s.sales_amount) DESC) AS Rank_Products
    FROM gold.fact_sales AS s
    LEFT JOIN gold.dim_products AS p
    ON s.product_key = p.product_key
    GROUP BY p.product_name
    ) AS t
WHERE Rank_Products <= 5

-- Find the top 10 customers who have generated the highest revenue
SELECT TOP 10
    c.customer_key,
    c.first_name,
    c.last_name,
    SUM(s.sales_amount) AS Total_Revenue
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_customers AS c
ON s.customer_key = c.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name
ORDER BY Total_Revenue DESC

-- Rank top 10 customers who have generated the highest revenue 
SELECT
    *
FROM(
    SELECT
    c.customer_key,
    c.first_name,
    c.last_name,
    SUM(s.sales_amount) AS Total_Revenue,
    ROW_NUMBER() OVER(ORDER BY SUM(s.sales_amount) DESC) AS Rank_Customer
    FROM gold.fact_sales AS s
    LEFT JOIN gold.dim_customers AS c
    ON s.customer_key = c.customer_key
    GROUP BY c.customer_key, c.first_name, c.last_name
    ) AS t
WHERE Rank_Customer <= 10

-- The 3 customers with the fewest orders placed
SELECT TOP 3
    c.customer_key,
    c.first_name,
    c.last_name,
    COUNT(DISTINCT s.order_number) AS Total_Orders
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_customers AS c
ON s.customer_key = c.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name
ORDER BY Total_Orders ASC