/*
===============================================================================
Step 10:    Part-to-Whole Analysis
===============================================================================
Purpose:
    - To compare performance or metrics across dimensions or time periods.
    - To evaluate differences between categories.
    - Allowing to understand which category has the greatest impact on the business.
    - Useful for A/B testing or regional comparisons.

SQL Functions Used:
    - SUM(), AVG(): Aggregates values for comparison.
    - Window Functions: SUM() OVER() for total calculations.
===============================================================================
*/
-- Which categories contribute the most to overall sales?
WITH Category_Sales AS (
SELECT
    p.category,
    SUM(s.sales_amount) AS Total_Sales
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
GROUP BY p.category

)

SELECT
    category,
    Total_Sales,
    SUM(Total_Sales) OVER() AS Overall_Sales,
    CONCAT(ROUND ((CAST(Total_Sales AS FLOAT) / SUM(Total_Sales) OVER()) * 100, 2), '%') AS Percentage_Contribution
FROM Category_Sales
ORDER BY Total_Sales DESC