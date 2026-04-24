/*
===============================================================================
Step 2: Dimensions Exploration
===============================================================================
Purpose:
    - To explore the structure of dimension tables.
    - Identify the unique values in each dimension.
	
SQL Functions Used:
    - DISTINCT
    - ORDER BY
===============================================================================
*/

-- Retrieve a list of unique countries from which customers originate
SELECT 
    DISTINCT country 
FROM gold.dim_customers
ORDER BY country ASC
-- Retrieve a list of unique categories, subcategories, and products
SELECT 
    DISTINCT category,
    subcategory,
    product_name
FROM gold.dim_products
ORDER BY
    category,
    subcategory,
    product_name