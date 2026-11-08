CREATE DATABASE retail_sales_analytics;
USE retail_sales_analytics;

## Data Quality Checks 
## Step 1: Verify the number of rows
USE retail_sales_analytics;
SELECT 'dim_customers' AS table_name, COUNT(*) AS row_count FROM dim_customers
UNION ALL
SELECT 'dim_date', COUNT(*) FROM dim_date
UNION ALL
SELECT 'dim_employees', COUNT(*) FROM dim_employees
UNION ALL
SELECT 'dim_products', COUNT(*) FROM dim_products
UNION ALL
SELECT 'dim_stores', COUNT(*) FROM dim_stores
UNION ALL
SELECT 'fact_order_details', COUNT(*) FROM fact_order_details
UNION ALL
SELECT 'fact_orders_2022_2023', COUNT(*) FROM fact_orders_2022_2023
UNION ALL
SELECT 'fact_orders_2024', COUNT(*) FROM fact_orders_2024
UNION ALL
SELECT 'fact_returns', COUNT(*) FROM fact_returns;

## Step 2: Inspecting tables data-type
USE retail_sales_analytics;
DESCRIBE dim_customers;
DESCRIBE dim_date;
DESCRIBE dim_employees;
DESCRIBE dim_products;
DESCRIBE dim_stores;
DESCRIBE fact_order_details;
DESCRIBE fact_orders_2022_2023;
DESCRIBE fact_orders_2024;
DESCRIBE fact_returns;


## Step 3: Check missing values
USE retail_sales_analytics;

SELECT
    COUNT(*) AS total_rows,
    SUM(customer_id IS NULL OR TRIM(customer_id) = '') AS missing_customer_id,
    SUM(full_name IS NULL OR TRIM(full_name) = '') AS missing_name,
    SUM(email IS NULL OR TRIM(email) = '') AS missing_email,
    SUM(gender IS NULL OR TRIM(gender) = '') AS missing_gender,
    SUM(birth_date IS NULL OR TRIM(birth_date) = '') AS missing_birth_date
FROM dim_customers;

SELECT
    COUNT(*) AS total_rows,
    SUM(customer_id IS NULL OR TRIM(customer_id) = '') AS missing_customer_id,
    SUM(full_name IS NULL OR TRIM(full_name) = '') AS missing_name,
    SUM(email IS NULL OR TRIM(email) = '') AS missing_email,
    SUM(gender IS NULL OR TRIM(gender) = '') AS missing_gender,
    SUM(birth_date IS NULL OR TRIM(birth_date) = '') AS missing_birth_date,
    SUM(phone IS NULL OR TRIM(phone) = '') AS missing_phone,
    SUM(city IS NULL OR TRIM(city) = '') AS missing_city,
    SUM(region IS NULL OR TRIM(region) = '') AS missing_region,
    SUM(loyalty_tier IS NULL OR TRIM(loyalty_tier) = '') AS missing_loyalty_tier
FROM dim_customers;

SELECT
    COUNT(*) AS total_rows,
    SUM(employee_id IS NULL OR TRIM(employee_id) = '') AS missing_employee_id,
    SUM(first_name IS NULL OR TRIM(first_name) = '') AS missing_first_name,
    SUM(last_name IS NULL OR TRIM(last_name) = '') AS missing_last_name,
    SUM(gender IS NULL OR TRIM(gender) = '') AS missing_gender,
    SUM(role IS NULL OR TRIM(role) = '') AS missing_role,
    SUM(store_id IS NULL) AS missing_store_id,
    SUM(hire_date IS NULL OR TRIM(hire_date) = '') AS missing_hire_date,
    SUM(monthly_salary_egp IS NULL) AS missing_salary
FROM dim_employees;

SELECT
    COUNT(*) AS total_rows,
    SUM(date_id IS NULL) AS missing_date_id,
    SUM(full_date IS NULL OR TRIM(full_date) = '') AS missing_full_date,
    SUM(day IS NULL) AS missing_day,
    SUM(month IS NULL) AS missing_month,
    SUM(month_name IS NULL OR TRIM(month_name) = '') AS missing_month_name,
    SUM(quarter IS NULL) AS missing_quarter,
    SUM(year IS NULL) AS missing_year,
    SUM(day_name IS NULL OR TRIM(day_name) = '') AS missing_day_name,
    SUM(is_weekend IS NULL) AS missing_weekend,
    SUM(is_ramadan IS NULL) AS missing_ramadan
FROM dim_date;

SELECT
    COUNT(*) AS total_rows,
    SUM(product_id IS NULL OR TRIM(product_id) = '') AS missing_product_id,
    SUM(product_name_raw IS NULL OR TRIM(product_name_raw) = '') AS missing_product_name,
    SUM(category IS NULL OR TRIM(category) = '') AS missing_category,
    SUM(subcategory IS NULL OR TRIM(subcategory) = '') AS missing_subcategory,
    SUM(brand IS NULL OR TRIM(brand) = '') AS missing_brand,
    SUM(unit_price IS NULL) AS missing_unit_price,
    SUM(unit_cost IS NULL) AS missing_unit_cost,
    SUM(stock_qty IS NULL) AS missing_stock_qty
FROM dim_products;

SELECT
    COUNT(*) AS total_rows,
    SUM(store_id IS NULL) AS missing_store_id,
    SUM(store_name IS NULL OR TRIM(store_name) = '') AS missing_store_name,
    SUM(city IS NULL OR TRIM(city) = '') AS missing_city,
    SUM(district IS NULL OR TRIM(district) = '') AS missing_district,
    SUM(region IS NULL OR TRIM(region) = '') AS missing_region,
    SUM(opening_year IS NULL) AS missing_opening_year,
    SUM(size_sqm IS NULL) AS missing_size,
    SUM(store_type IS NULL OR TRIM(store_type) = '') AS missing_store_type
FROM dim_stores;

SELECT
    COUNT(*) AS total_rows,
    SUM(detail_id IS NULL OR TRIM(detail_id) = '') AS missing_detail_id,
    SUM(order_id IS NULL OR TRIM(order_id) = '') AS missing_order_id,
    SUM(product_id IS NULL OR TRIM(product_id) = '') AS missing_product_id,
    SUM(quantity IS NULL) AS missing_quantity,
    SUM(unit_price IS NULL) AS missing_unit_price,
    SUM(discount_pct IS NULL) AS missing_discount,
    SUM(selling_price IS NULL) AS missing_selling_price,
    SUM(unit_cost IS NULL) AS missing_unit_cost,
    SUM(line_total_revenue IS NULL) AS missing_revenue,
    SUM(line_total_cost IS NULL) AS missing_cost
FROM fact_order_details;

SELECT
    COUNT(*) AS total_rows,
    SUM(order_id IS NULL OR TRIM(order_id) = '') AS missing_order_id,
    SUM(order_date IS NULL OR TRIM(order_date) = '') AS missing_order_date,
    SUM(date_id IS NULL) AS missing_date_id,
    SUM(customer_id IS NULL OR TRIM(customer_id) = '') AS missing_customer_id,
    SUM(store_id IS NULL) AS missing_store_id,
    SUM(employee_id IS NULL OR TRIM(employee_id) = '') AS missing_employee_id,
    SUM(payment_method IS NULL OR TRIM(payment_method) = '') AS missing_payment_method,
    SUM(order_status IS NULL OR TRIM(order_status) = '') AS missing_status,
    SUM(total_revenue IS NULL) AS missing_revenue,
    SUM(total_cost IS NULL) AS missing_cost
FROM fact_orders_2022_2023;

SELECT
    COUNT(*) AS total_rows,
    SUM(order_id IS NULL OR TRIM(order_id) = '') AS missing_order_id,
    SUM(order_date IS NULL OR TRIM(order_date) = '') AS missing_order_date,
    SUM(date_id IS NULL) AS missing_date_id,
    SUM(customer_id IS NULL OR TRIM(customer_id) = '') AS missing_customer_id,
    SUM(store_id IS NULL) AS missing_store_id,
    SUM(employee_id IS NULL OR TRIM(employee_id) = '') AS missing_employee_id,
    SUM(payment_method IS NULL OR TRIM(payment_method) = '') AS missing_payment_method,
    SUM(order_status IS NULL OR TRIM(order_status) = '') AS missing_status,
    SUM(total_revenue IS NULL) AS missing_revenue,
    SUM(total_cost IS NULL) AS missing_cost
FROM fact_orders_2024;

SELECT
    COUNT(*) AS total_rows,
    SUM(return_id IS NULL OR TRIM(return_id) = '') AS missing_return_id,
    SUM(order_id IS NULL OR TRIM(order_id) = '') AS missing_order_id,
    SUM(return_date IS NULL OR TRIM(return_date) = '') AS missing_return_date,
    SUM(return_reason IS NULL OR TRIM(return_reason) = '') AS missing_reason,
    SUM(return_amount IS NULL) AS missing_return_amount,
    SUM(refund_method IS NULL OR TRIM(refund_method) = '') AS missing_refund_method,
    SUM(return_status IS NULL OR TRIM(return_status) = '') AS missing_status
FROM fact_returns;

## Step 4: Finding Duplicate Values

SELECT
    customer_id,
    COUNT(*) AS record_count
FROM dim_customers
GROUP BY customer_id
HAVING COUNT(*) > 1
ORDER BY record_count DESC;

SELECT
    gender,
    COUNT(*) AS record_count
FROM dim_customers
GROUP BY gender
ORDER BY record_count DESC;

SELECT
    payment_method,
    COUNT(*) AS record_count
FROM fact_orders_2022_2023
GROUP BY payment_method
ORDER BY record_count DESC;

SELECT
    payment_method,
    COUNT(*) AS record_count
FROM fact_orders_2024
GROUP BY payment_method
ORDER BY record_count DESC;

SELECT *
FROM dim_customers
WHERE customer_id IN (
    SELECT customer_id
    FROM dim_customers
    GROUP BY customer_id
    HAVING COUNT(*) > 1
)
ORDER BY customer_id;

SELECT
    COUNT(*) AS duplicate_rows,
    COUNT(DISTINCT customer_id) AS duplicated_customers
FROM dim_customers
WHERE customer_id IN (
    SELECT customer_id
    FROM dim_customers
    GROUP BY customer_id
    HAVING COUNT(*) > 1
);

