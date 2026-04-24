/*
===============================================================================
Step 8: Cumulative Analysis
===============================================================================
Purpose:
    - To calculate running totals or moving averages for key metrics.
    - To track performance over time cumulatively.
    - Useful for growth analysis or identifying long-term trends.

SQL Functions Used:
    - Window Functions: SUM() OVER(), AVG() OVER()
===============================================================================
*/

-- Calculate the total sales per month 
-- and the running total of sales over time 
SELECT
    Order_Date,
    Total_Sales,
    SUM(Total_Sales) OVER(ORDER BY Order_Date) AS Running_Total_Sales,
    Avg_Price,
    AVG(Avg_Price) OVER(ORDER BY Order_Date) AS Moving_Avg_Price
FROM(
    SELECT 
    DATETRUNC(month, order_date) AS Order_Date,
    SUM(sales_amount) AS Total_Sales,
    AVG(price) AS Avg_Price
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(month, order_date)
    ) AS t