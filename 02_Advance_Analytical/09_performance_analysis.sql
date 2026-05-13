/*
===============================================================================
Step 9: Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================
Purpose:
    - Comparing the current value to a target value.
    - To measure the performance of products, customers, or regions over time.
    - For benchmarking and identifying high-performing entities.
    - To track yearly trends and growth.

SQL Functions Used:
    - LAG(): Accesses data from previous rows.
    - AVG() OVER(): Computes average values within partitions.
    - CASE: Defines conditional logic for trend analysis.
===============================================================================
*/

/* Analyze the yearly performance of products by comparing their sales 
to both the average sales performance of the product and the previous year's sales */
WITH Yearly_Product_Sales AS (
SELECT 
    YEAR(s.order_date) AS Order_Year,
    p.product_name,
    SUM(s.sales_amount) AS Current_Sales
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
WHERE s.order_date IS NOT NULL
GROUP BY YEAR(s.order_date), p.product_name
)

SELECT
    Order_Year,
    product_name,
    Current_Sales,
    AVG(Current_Sales) OVER(PARTITION BY product_name) AS Avg_Sales,
    Current_Sales - AVG(Current_Sales) OVER(PARTITION BY product_name) AS Avg_difference,
    CASE
    WHEN Current_Sales - AVG(Current_Sales) OVER(PARTITION BY product_name) > 0 THEN 'Above Average'
    WHEN Current_Sales - AVG(Current_Sales) OVER(PARTITION BY product_name) < 0 THEN 'Below Average'
    ELSE 'Average'
    END AS Avg_Change,
    -- Year-over-Year analysis
    LAG(Current_Sales) OVER(PARTITION BY product_name ORDER BY Order_Year) AS Previous_Year_Sales,
	current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS Difference_Per_Year,
    CASE
    WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
    WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
    ELSE 'No Change'
    END AS Previous_Year_Change
FROM Yearly_Product_Sales
ORDER BY product_name, Order_Year