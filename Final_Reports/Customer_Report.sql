/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average order value
		- average monthly spend
===============================================================================
*/

CREATE VIEW gold.report_customers AS

/*---------------------------------------------------------------------------
1) Base Query: Retrieves core columns from tables
---------------------------------------------------------------------------*/
WITH base_query AS (
    SELECT
        -- 1. Order / transaction details
        s.order_number,
        s.product_key,
        s.order_date,
        s.sales_amount,
        s.quantity,

        -- 2. Customer identifiers
        c.customer_key,
        c.customer_number,

        -- 3. Customer descriptive attributes
        CONCAT(c.first_name, ' ', c.last_name) AS customer_full_name,
        DATEDIFF(year, c.birthdate, GETDATE()) AS customer_age

    FROM gold.fact_sales AS s

    LEFT JOIN gold.dim_customers AS c
        ON s.customer_key = c.customer_key  -- join on customer

    WHERE
        s.order_date IS NOT NULL  -- only valid sales dates
)


/*---------------------------------------------------------------------------
2) Customer Aggregations: Summarizes key metrics at the customer level
---------------------------------------------------------------------------*/
, customer_aggregation AS (
    SELECT
        -- 1. Identifiers
        customer_key,
        customer_number,

        -- 2. Descriptive attributes
        customer_full_name,
        customer_age,

        -- 3. Time metrics
        MAX(order_date) AS last_order_date,
        DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan,

        -- 4. Aggregated metrics
        COUNT(DISTINCT order_number) AS total_orders,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,
        COUNT(DISTINCT product_key) AS total_products

    FROM base_query

    GROUP BY
        customer_key,
        customer_number,
        customer_full_name,
        customer_age
)


/*---------------------------------------------------------------------------
3) Final Query: Combines all customer results into one output
---------------------------------------------------------------------------*/
SELECT
    -- 1. Identifiers
    customer_key,
    customer_number,

    -- 2. Descriptive attributes
    customer_full_name,
    customer_age,

    -- 3. Segmentation / labels
    CASE
        WHEN customer_age < 20 THEN 'Under 20'
        WHEN customer_age BETWEEN 20 AND 29 THEN 'Age 20-29'
        WHEN customer_age BETWEEN 30 AND 39 THEN 'Age 30-39'
        WHEN customer_age BETWEEN 40 AND 49 THEN 'Age 40-49'
        ELSE 'Age above 50'
    END AS age_segment,

    CASE
        WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
        WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
        ELSE 'New'
    END AS customer_segment,

    -- 4. Time-related fields
    lifespan,
    last_order_date,
    DATEDIFF(month, last_order_date, GETDATE()) AS months_since_last_order,

    -- 5. Aggregated metrics
    total_orders,
    total_sales,
    total_quantity,
    total_products,

    -- 6. KPIs / Calculations
    CASE
        WHEN total_orders = 0 THEN 0
        ELSE total_sales / total_orders
    END AS avg_order_value,

    CASE
        WHEN lifespan = 0 THEN total_sales
        ELSE total_sales / lifespan
    END AS avg_monthly_spend

FROM customer_aggregation;