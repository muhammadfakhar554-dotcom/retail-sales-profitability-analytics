-- ============================================================
-- Retail Sales & Profitability Analytics
-- File: 02_cleaning.sql
-- Purpose: Clean and standardize analytical data
-- ============================================================

USE retail_sales_analytics;
-- ============================================================
-- 1. Clean Customer Dimension
-- ============================================================

CREATE TABLE dim_customers_clean AS
SELECT DISTINCT
    customer_id,
    full_name,

    CASE
        WHEN LOWER(TRIM(gender)) = 'male' THEN 'Male'
        WHEN LOWER(TRIM(gender)) = 'female' THEN 'Female'
        ELSE NULL
    END AS gender,
    birth_date,
    phone,
    email,
    city,
    region,
    loyalty_tier,
    registration_date
FROM dim_customers;
SELECT
    COUNT(*) AS cleaned_rows,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM dim_customers_clean;

SELECT
    birth_date,
    COUNT(*) AS records
FROM dim_customers_clean
GROUP BY birth_date
ORDER BY birth_date
LIMIT 20;
SELECT
    COUNT(*) AS total_customers,
    SUM(
        birth_date NOT REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$'
    ) AS non_standard_dates
FROM dim_customers_clean;
-- ============================================================
-- 2. Standardize Customer Birth Dates
-- ============================================================

CREATE TABLE dim_customers_clean_v2 AS
SELECT
    customer_id,
    full_name,
    gender,

    CASE
        WHEN birth_date LIKE '__/__/____'
            THEN STR_TO_DATE(birth_date, '%d/%m/%Y')
        ELSE
            STR_TO_DATE(birth_date, '%Y-%m-%d')
    END AS birth_date,

    phone,
    email,
    city,
    region,
    loyalty_tier,
    registration_date
FROM dim_customers_clean;

SELECT
    birth_date
FROM dim_customers_clean_v2
LIMIT 10;
DESCRIBE dim_customers_clean_v2;

SELECT
    registration_date,
    COUNT(*) AS records
FROM dim_customers_clean
GROUP BY registration_date
ORDER BY registration_date
LIMIT 20;

SELECT
    COUNT(*) AS total_customers,
    SUM(
        registration_date NOT REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
    ) AS non_standard_dates
FROM dim_customers_clean;

-- ============================================================
-- 3. Finalize Customer Dimension
-- ============================================================

CREATE TABLE dim_customers_clean_final AS
SELECT
    customer_id,
    full_name,
    gender,
    birth_date,
    phone,
    email,
    city,
    region,
    loyalty_tier,
    STR_TO_DATE(registration_date, '%Y-%m-%d') AS registration_date
FROM dim_customers_clean_v2;

DESCRIBE dim_customers_clean_final;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM dim_customers_clean_final;

SELECT
    SUM(email IS NULL OR TRIM(email) = '') AS missing_emails,
    SUM(gender IS NULL) AS missing_gender,
    SUM(birth_date IS NULL) AS missing_birth_dates,
    SUM(registration_date IS NULL) AS missing_registration_dates
FROM dim_customers_clean_final;

SELECT
    CONCAT('[', payment_method, ']') AS payment_method,
    COUNT(*) AS orders
FROM fact_orders_2022_2023
GROUP BY payment_method
ORDER BY orders DESC;

-- ============================================================
-- 4. Clean Orders: 2022-2023
-- ============================================================

CREATE TABLE fact_orders_2022_2023_clean AS
SELECT
    order_id,
    order_date,
    date_id,
    customer_id,
    store_id,
    employee_id,

    TRIM(payment_method) AS payment_method,

    order_status,
    total_revenue,
    total_cost

FROM fact_orders_2022_2023;
SELECT
    CONCAT('[', payment_method, ']') AS payment_method,
    COUNT(*) AS orders
FROM fact_orders_2022_2023_clean
GROUP BY payment_method
ORDER BY orders DESC;
SELECT
    COUNT(*) AS total_orders,
    SUM(employee_id IS NULL) AS missing_employee_ids
FROM fact_orders_2022_2023_clean;

SELECT
    COUNT(*) AS raw_orders,
    SUM(employee_id IS NULL) AS raw_missing_employee_ids
FROM fact_orders_2022_2023;

SELECT
    COUNT(*) AS clean_orders,
    SUM(employee_id IS NULL) AS clean_missing_employee_ids
FROM fact_orders_2022_2023_clean;

-- ============================================================
-- 5. Clean Orders: 2024
-- ============================================================

SELECT
    CONCAT('[', payment_method, ']') AS payment_method,
    COUNT(*) AS orders
FROM fact_orders_2024
GROUP BY payment_method
ORDER BY orders DESC;

CREATE TABLE fact_orders_2024_clean AS
SELECT
    order_id,
    order_date,
    date_id,
    customer_id,
    store_id,
    employee_id,
    TRIM(payment_method) AS payment_method,
    order_status,
    total_revenue,
    total_cost
FROM fact_orders_2024;

SELECT
    payment_method,
    COUNT(*) AS orders
FROM fact_orders_2024_clean
GROUP BY payment_method
ORDER BY orders DESC;

SELECT
    CONCAT('[', order_status, ']') AS order_status,
    COUNT(*) AS orders
FROM fact_orders_2022_2023
GROUP BY order_status
ORDER BY orders DESC;

SELECT
    CONCAT('[', order_status, ']') AS order_status,
    COUNT(*) AS orders
FROM fact_orders_2024
GROUP BY order_status
ORDER BY orders DESC;

SELECT
    MIN(order_date) AS earliest_date,
    MAX(order_date) AS latest_date,
    SUM(order_date IS NULL) AS missing_dates
FROM fact_orders_2022_2023;

SELECT
    MIN(order_date) AS earliest_date,
    MAX(order_date) AS latest_date,
    SUM(order_date IS NULL) AS missing_dates
FROM fact_orders_2024;

SELECT
    COUNT(*) AS total_rows,
    SUM(quantity IS NULL) AS missing_quantity,
    SUM(selling_price IS NULL) AS missing_selling_price,
    SUM(unit_cost IS NULL) AS missing_unit_cost,
    SUM(line_total_revenue IS NULL) AS missing_revenue,
    SUM(line_total_cost IS NULL) AS missing_cost
FROM fact_order_details;
SELECT
    SUM(
        ABS(line_total_revenue - (quantity * selling_price)) > 0.01
    ) AS revenue_mismatches,
    SUM(
        ABS(line_total_cost - (quantity * unit_cost)) > 0.01
    ) AS cost_mismatches
FROM fact_order_details;
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT detail_id) AS unique_detail_ids
FROM fact_order_details;
SELECT
    COUNT(*) AS total_detail_rows,
    COUNT(p.product_id) AS matched_products,
    COUNT(*) - COUNT(p.product_id) AS unmatched_products
FROM fact_order_details od
LEFT JOIN dim_products p
    ON od.product_id = p.product_id;
    
SELECT
    COUNT(*) AS total_products,
    COUNT(DISTINCT product_id) AS unique_product_ids
FROM dim_products;
SELECT
    SUM(unit_price IS NULL) AS missing_unit_price,
    SUM(unit_cost IS NULL) AS missing_unit_cost,
    SUM(unit_price < 0) AS negative_unit_price,
    SUM(unit_cost < 0) AS negative_unit_cost,
    SUM(unit_price = 0) AS zero_unit_price,
    SUM(unit_cost = 0) AS zero_unit_cost
FROM dim_products;
SELECT
    product_id,
    product_name_raw,
    unit_price_text,
    unit_price
FROM dim_products
WHERE
    TRIM(unit_price_text) <> CAST(unit_price AS CHAR)
LIMIT 20;

SELECT
    SUM(product_name_raw IS NULL OR TRIM(product_name_raw) = '') AS missing_product_names,
    SUM(category IS NULL OR TRIM(category) = '') AS missing_categories,
    SUM(subcategory IS NULL OR TRIM(subcategory) = '') AS missing_subcategories,
    SUM(brand IS NULL OR TRIM(brand) = '') AS missing_brands
FROM dim_products;

SELECT
    COUNT(*) AS total_stores,
    COUNT(DISTINCT store_id) AS unique_store_ids
FROM dim_stores;
SELECT
    SUM(store_name IS NULL OR TRIM(store_name) = '') AS missing_store_names,
    SUM(city IS NULL OR TRIM(city) = '') AS missing_cities,
    SUM(district IS NULL OR TRIM(district) = '') AS missing_districts,
    SUM(region IS NULL OR TRIM(region) = '') AS missing_regions,
    SUM(opening_year IS NULL) AS missing_opening_years,
    SUM(size_sqm IS NULL) AS missing_sizes,
    SUM(store_type IS NULL OR TRIM(store_type) = '') AS missing_store_types
FROM dim_stores;

SELECT
    COUNT(*) AS total_employees,
    COUNT(DISTINCT employee_id) AS unique_employee_ids
FROM dim_employees;
SELECT
    SUM(first_name IS NULL OR TRIM(first_name) = '') AS missing_first_names,
    SUM(last_name IS NULL OR TRIM(last_name) = '') AS missing_last_names,
    SUM(gender IS NULL OR TRIM(gender) = '') AS missing_gender,
    SUM(role IS NULL OR TRIM(role) = '') AS missing_roles,
    SUM(store_id IS NULL) AS missing_store_ids,
    SUM(hire_date IS NULL) AS missing_hire_dates,
    SUM(monthly_salary_egp IS NULL) AS missing_salaries
FROM dim_employees;

SELECT
    COUNT(*) AS total_returns,
    COUNT(DISTINCT return_id) AS unique_return_ids,
    SUM(return_id IS NULL) AS missing_return_ids,
    SUM(order_id IS NULL) AS missing_order_ids,
    SUM(return_date IS NULL) AS missing_return_dates,
    SUM(return_amount IS NULL) AS missing_return_amounts
FROM fact_returns;
SELECT
    SUM(return_amount < 0) AS negative_return_amounts,
    SUM(return_amount = 0) AS zero_return_amounts
FROM fact_returns;
SELECT
    COUNT(*) AS total_returns,
    COUNT(o.order_id) AS matched_orders,
    COUNT(*) - COUNT(o.order_id) AS unmatched_orders
FROM fact_returns r
LEFT JOIN (
    SELECT order_id FROM fact_orders_2022_2023
    UNION ALL
    SELECT order_id FROM fact_orders_2024
) o
    ON r.order_id = o.order_id;
    
SELECT
    COUNT(*) AS raw_customers,
    COUNT(DISTINCT customer_id) AS raw_unique_customers
FROM dim_customers;
SELECT
    COUNT(*) AS clean_customers,
    COUNT(DISTINCT customer_id) AS clean_unique_customers
FROM dim_customers_clean_final;

-- ============================================================
-- 5. Clean Order Details
-- ============================================================

CREATE TABLE fact_order_details_clean AS
SELECT
    detail_id,
    order_id,
    product_id,
    quantity,
    unit_price,
    discount_pct,
    selling_price,
    unit_cost,
    line_total_revenue,
    line_total_cost
FROM fact_order_details;
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT detail_id) AS unique_detail_ids
FROM fact_order_details_clean;

-- ============================================================
-- 6. Clean Product Dimension
-- ============================================================

CREATE TABLE dim_products_clean AS
SELECT
    product_id,
    product_name_raw AS product_name,
    category,
    subcategory,
    brand,
    unit_price,
    unit_cost,
    stock_qty,
    is_active
FROM dim_products;
SELECT
    COUNT(*) AS total_products,
    COUNT(DISTINCT product_id) AS unique_products,
    SUM(CASE WHEN unit_price IS NULL THEN 1 ELSE 0 END) AS missing_prices,
    SUM(CASE WHEN unit_cost IS NULL THEN 1 ELSE 0 END) AS missing_costs
FROM dim_products_clean;

-- ============================================================
-- 7. Clean Store Dimension
-- ============================================================

CREATE TABLE dim_stores_clean AS
SELECT
    store_id,
    store_name,
    city,
    district,
    region,
    opening_year,
    size_sqm,
    store_type
FROM dim_stores;
SELECT
    COUNT(*) AS total_stores,
    COUNT(DISTINCT store_id) AS unique_stores,
    SUM(CASE WHEN store_name IS NULL THEN 1 ELSE 0 END) AS missing_store_names,
    SUM(CASE WHEN region IS NULL THEN 1 ELSE 0 END) AS missing_regions,
    SUM(CASE WHEN store_type IS NULL THEN 1 ELSE 0 END) AS missing_store_types
FROM dim_stores_clean;

-- ============================================================
-- 8. Clean Employee Dimension
-- ============================================================

CREATE TABLE dim_employees_clean AS
SELECT
    employee_id,
    first_name,
    last_name,
    gender,
    role,
    store_id,
    hire_date,
    monthly_salary_egp
FROM dim_employees;
SELECT
    COUNT(*) AS total_employees,
    COUNT(DISTINCT employee_id) AS unique_employees,
    SUM(CASE WHEN first_name IS NULL THEN 1 ELSE 0 END) AS missing_first_names,
    SUM(CASE WHEN role IS NULL THEN 1 ELSE 0 END) AS missing_roles,
    SUM(CASE WHEN store_id IS NULL THEN 1 ELSE 0 END) AS missing_store_ids,
    SUM(CASE WHEN monthly_salary_egp IS NULL THEN 1 ELSE 0 END) AS missing_salaries
FROM dim_employees_clean;

-- ============================================================
-- 9. Clean Returns
-- ============================================================

CREATE TABLE fact_returns_clean AS
SELECT
    return_id,
    order_id,
    return_date,
    return_amount
FROM fact_returns;
SELECT
    COUNT(*) AS total_returns,
    COUNT(DISTINCT return_id) AS unique_returns,
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS missing_order_ids,
    SUM(CASE WHEN return_date IS NULL THEN 1 ELSE 0 END) AS missing_return_dates,
    SUM(CASE WHEN return_amount IS NULL THEN 1 ELSE 0 END) AS missing_return_amounts
FROM fact_returns_clean;

SELECT
    (SELECT COUNT(*) FROM fact_orders_2022_2023_clean)
    +
    (SELECT COUNT(*) FROM fact_orders_2024_clean)
    AS total_clean_orders;