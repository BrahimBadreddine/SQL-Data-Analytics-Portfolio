/*
===============================================================================
Step 3: Date Range Exploration 
===============================================================================
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.

SQL Functions Used:
    - MIN(), MAX(), DATEDIFF()
===============================================================================
*/

-- Determine the first and last order date
-- How many years and months of sales are available
SELECT 
   MIN(order_date) AS First_Order_Date,
   MAX(order_date) AS Last_Order_Date,
   DATEDIFF(year, MIN(order_date), MAX(order_date)) AS Order_Range_Years,
   DATEDIFF(month, MIN(order_date), MAX(order_date)) AS Order_Range_Months
FROM gold.fact_sales

-- Find the youngest and oldest customer based on birthdate
SELECT
    MIN(birthdate) AS Oldest_Customer_Birthdate,
    DATEDIFF(year, MIN(birthdate), GETDATE()) AS Oldest_Age,
    MAX(birthdate) AS Youngest_Customer_Birthdate,
    DATEDIFF(year, MAX(birthdate), GETDATE()) AS Youngest_Age
FROM gold.dim_customers