/*
===============================================================================
Product Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
===============================================================================
*/

CREATE VIEW gold.report_products AS

/*---------------------------------------------------------------------------
1) Base Query: Retrieves core columns from tables
---------------------------------------------------------------------------*/
WITH base_query AS (
    SELECT
        -- 1. Order / transaction details
        s.order_number,
        s.order_date,
        s.sales_amount,
        s.quantity,

        -- 2. Customer reference
        s.customer_key,

        -- 3. Product identifiers
        p.product_key,

        -- 4. Product descriptive attributes
        p.product_name,
        p.category,
        p.subcategory,
        p.cost

    FROM gold.fact_sales AS s

    LEFT JOIN gold.dim_products AS p
        ON s.product_key = p.product_key  -- join on product

    WHERE
        s.order_date IS NOT NULL  -- only valid sales dates
)

/*---------------------------------------------------------------------------
2) Product Aggregations: Summarizes key metrics at the product level
---------------------------------------------------------------------------*/
, product_aggregation AS (
    SELECT
        -- 1. Product identifiers
        product_key,

        -- 2. Product descriptive attributes
        product_name,
        category,
        subcategory,
        cost,

        -- 3. Time metrics
        MAX(order_date) AS last_sales_date,
        DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan,

        -- 4. Aggregated metrics
        COUNT(DISTINCT order_number) AS total_orders,
        COUNT(DISTINCT customer_key) AS total_customers,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,

        -- 5. KPIs / Calculations
        ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity, 0)), 1) AS avg_selling_price

    FROM base_query

    GROUP BY
        product_key,
        product_name,
        category,
        subcategory,
        cost
)


/*---------------------------------------------------------------------------
3) Final Query: Combines all product results into one output
---------------------------------------------------------------------------*/
SELECT
    -- 1. Product identifiers
    product_key,

    -- 2. Product descriptive attributes
    product_name,
    category,
    subcategory,
    cost,

    -- 3. Segmentation
    CASE
        WHEN total_sales > 50000 THEN 'High-Performers'
        WHEN total_sales >= 10000 THEN 'Mid-Range'
        ELSE 'Low-Performers'
    END AS product_segment,

    -- 4. Time metrics
    lifespan,
    last_sales_date,
    DATEDIFF(month, last_sales_date, GETDATE()) AS months_since_last_sale,

    -- 5. Aggregated metrics
    total_orders,
    total_customers,
    total_sales,
    total_quantity,
    avg_selling_price,

    -- 6. KPIs / Calculations
    CASE
        WHEN total_orders = 0 THEN 0
        ELSE total_sales / total_orders
    END AS avg_order_revenue,

    CASE
        WHEN lifespan = 0 THEN total_sales
        ELSE total_sales / lifespan
    END AS avg_monthly_revenue

FROM product_aggregation;