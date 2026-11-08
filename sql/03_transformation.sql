-- ============================================================
-- Retail Sales & Profitability Analytics
-- File: 03_transformations.sql
-- Purpose: Transform cleaned data into analytical tables
-- ============================================================

USE retail_sales_analytics;


-- ============================================================
-- 1. Combine Orders: 2022-2024
-- ============================================================

CREATE TABLE fact_orders_clean AS
SELECT
    order_id,
    order_date,
    date_id,
    customer_id,
    store_id,
    employee_id,
    payment_method,
    order_status,
    total_revenue,
    total_cost
FROM fact_orders_2022_2023_clean

UNION ALL

SELECT
    order_id,
    order_date,
    date_id,
    customer_id,
    store_id,
    employee_id,
    payment_method,
    order_status,
    total_revenue,
    total_cost
FROM fact_orders_2024_clean;
SELECT
    COUNT(*) AS total_orders,
    COUNT(DISTINCT order_id) AS unique_orders,
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date
FROM fact_orders_clean;

-- ============================================================
-- 2. Add Profitability Metrics
-- ============================================================

CREATE TABLE fact_orders_analytics AS
SELECT
    order_id,
    order_date,
    date_id,
    customer_id,
    store_id,
    employee_id,
    payment_method,
    order_status,
    total_revenue,
    total_cost,

    total_revenue - total_cost AS gross_profit,

    CASE
        WHEN total_revenue = 0 THEN NULL
        ELSE (total_revenue - total_cost) / total_revenue * 100
    END AS gross_margin_pct

FROM fact_orders_clean;
SELECT
    COUNT(*) AS total_orders,
    ROUND(SUM(total_revenue), 2) AS total_revenue,
    ROUND(SUM(total_cost), 2) AS total_cost,
    ROUND(SUM(gross_profit), 2) AS total_gross_profit,
    ROUND(
        SUM(gross_profit) / NULLIF(SUM(total_revenue), 0) * 100,
        2
    ) AS overall_gross_margin_pct
FROM fact_orders_analytics;

-- ============================================================
-- 3. Add Profitability Metrics to Order Details
-- ============================================================

CREATE TABLE fact_order_details_analytics AS
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
    line_total_cost,

    line_total_revenue - line_total_cost AS line_gross_profit,

    CASE
        WHEN line_total_revenue = 0 THEN NULL
        ELSE (line_total_revenue - line_total_cost)
             / line_total_revenue * 100
    END AS line_gross_margin_pct
FROM fact_order_details_clean;
SELECT
    COUNT(*) AS total_detail_rows,
    COUNT(DISTINCT detail_id) AS unique_detail_ids
FROM fact_order_details_analytics;

-- ============================================================
-- 4. Prepare Date Dimension
-- ============================================================

CREATE TABLE dim_dates_analytics AS
SELECT
    date_id,
    full_date,
    year,
    quarter,
    month,
    month_name,
    day,
    day_of_week,
    day_name,
    is_weekend,
    week_of_year,
    is_ramadan
FROM dim_date;
SELECT
    COUNT(*) AS total_date,
    COUNT(DISTINCT date_id) AS unique_date_ids,
    MIN(full_date) AS first_date,
    MAX(full_date) AS last_date
FROM dim_dates_analytics;

-- ============================================================
-- 5. Prepare Customer Dimension
-- ============================================================

CREATE TABLE dim_customers_analytics AS
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
    registration_date
FROM dim_customers_clean_final;
SELECT
    COUNT(*) AS total_customers,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM dim_customers_analytics;

-- ============================================================
-- 6. Prepare Store Dimension
-- ============================================================

CREATE TABLE dim_stores_analytics AS
SELECT
    store_id,
    store_name,
    city,
    district,
    region,
    opening_year,
    size_sqm,
    store_type
FROM dim_stores_clean;

-- ============================================================
-- 6. Prepare Store Dimension
-- ============================================================

CREATE TABLE dim_stores_analytics AS
SELECT
    store_id,
    store_name,
    city,
    district,
    region,
    opening_year,
    size_sqm,
    store_type
FROM dim_stores_clean;
SELECT
    COUNT(*) AS total_stores,
    COUNT(DISTINCT store_id) AS unique_stores
FROM dim_stores_analytics;

-- ============================================================
-- 7. Prepare Employee Dimension
-- ============================================================

CREATE TABLE dim_employees_analytics AS
SELECT
    employee_id,
    first_name,
    last_name,
    gender,
    role,
    store_id,
    hire_date,
    monthly_salary_egp
FROM dim_employees_clean;
SELECT
    COUNT(*) AS total_employees,
    COUNT(DISTINCT employee_id) AS unique_employees
FROM dim_employees_analytics;

-- ============================================================
-- 8. Add Return Indicator to Orders
-- ============================================================

CREATE TABLE fact_orders_final AS
SELECT
    o.order_id,
    o.order_date,
    o.date_id,
    o.customer_id,
    o.store_id,
    o.employee_id,
    o.payment_method,
    o.order_status,
    o.total_revenue,
    o.total_cost,
    o.gross_profit,
    o.gross_margin_pct,

    CASE
        WHEN r.order_id IS NOT NULL THEN 1
        ELSE 0
    END AS is_returned

FROM fact_orders_analytics o
LEFT JOIN fact_returns_clean r
    ON o.order_id = r.order_id;
SELECT
    COUNT(*) AS total_orders,
    COUNT(DISTINCT order_id) AS unique_orders,
    SUM(is_returned) AS returned_orders,
    SUM(CASE WHEN is_returned = 0 THEN 1 ELSE 0 END) AS non_returned_orders
FROM fact_orders_final;

SELECT 'fact_orders_final' AS table_name, COUNT(*) AS row_count
FROM fact_orders_final

UNION ALL

SELECT 'fact_order_details_analytics', COUNT(*)
FROM fact_order_details_analytics

UNION ALL

SELECT 'dim_customers_analytics', COUNT(*)
FROM dim_customers_analytics

UNION ALL

SELECT 'dim_products_clean', COUNT(*)
FROM dim_products_clean

UNION ALL

SELECT 'dim_stores_analytics', COUNT(*)
FROM dim_stores_analytics

UNION ALL

SELECT 'dim_employees_analytics', COUNT(*)
FROM dim_employees_analytics;


DROP TABLE IF EXISTS dim_customers_clean;
DROP TABLE IF EXISTS dim_customers_clean_v2;
DROP TABLE IF EXISTS dim_customers_clean_final;

SELECT
    COUNT(*) AS total_customers,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM dim_customers_analytics;