
-- ============================================================
-- Retail Sales & Profitability Analytics
-- File: 04_analysis.sql
-- Purpose: Analyze sales, profitability, customers, products,
--          stores, and returns to identify business insights
-- ============================================================

USE retail_sales_analytics;


-- ============================================================
-- Analysis 1: Annual Sales and Profitability
-- Business question: How did annual performance change?
-- ============================================================

SELECT
    YEAR(order_date) AS sales_year,
    COUNT(*) AS total_orders,
    ROUND(SUM(total_revenue), 2) AS total_revenue,
    ROUND(SUM(total_cost), 2) AS total_cost,
    ROUND(SUM(gross_profit), 2) AS gross_profit,
    ROUND(
        SUM(gross_profit) / NULLIF(SUM(total_revenue), 0) * 100,
        2
    ) AS gross_margin_pct
FROM fact_orders_final
WHERE order_status <> 'Cancelled'
GROUP BY YEAR(order_date)
ORDER BY sales_year;


-- ============================================================
-- Analysis 2: Order Status and Returns
-- Business question: How do recorded returns relate to
-- order statuses?
-- ============================================================

SELECT
    order_status,
    COUNT(*) AS total_orders,
    SUM(is_returned) AS orders_with_recorded_returns,
    ROUND(SUM(total_revenue), 2) AS recorded_order_revenue
FROM fact_orders_final
GROUP BY order_status
ORDER BY total_orders DESC;


-- ============================================================
-- Analysis 3: Returned Orders Missing Return Records
-- ============================================================

SELECT
    order_id,
    order_date,
    total_revenue,
    total_cost,
    gross_profit,
    order_status,
    is_returned
FROM fact_orders_final
WHERE order_status = 'Returned'
  AND is_returned = 0
ORDER BY order_date;


-- ============================================================
-- Analysis 4: Sales by Order Status
-- Business question: How do revenue and gross profit differ
-- across order statuses?
-- ============================================================

SELECT
    o.order_status,
    COUNT(*) AS total_orders,
    ROUND(SUM(o.total_revenue), 2) AS recorded_revenue,
    ROUND(SUM(o.gross_profit), 2) AS recorded_gross_profit,
    ROUND(AVG(o.total_revenue), 2) AS avg_order_value,
    ROUND(
        SUM(o.total_revenue) / NULLIF(COUNT(*), 0),
        2
    ) AS revenue_per_order
FROM fact_orders_final o
GROUP BY o.order_status
ORDER BY recorded_revenue DESC;


-- ============================================================
-- Analysis 5: Annual Completed Sales Performance
-- Business question: How did completed sales and profitability
-- change from 2022 to 2024?
-- ============================================================

SELECT
    YEAR(order_date) AS sales_year,
    COUNT(*) AS completed_orders,
    ROUND(SUM(total_revenue), 2) AS completed_revenue,
    ROUND(SUM(total_cost), 2) AS recorded_cost,
    ROUND(SUM(gross_profit), 2) AS recorded_gross_profit,
    ROUND(
        SUM(gross_profit) / NULLIF(SUM(total_revenue), 0) * 100,
        2
    ) AS gross_margin_pct,
    ROUND(AVG(total_revenue), 2) AS avg_order_value
FROM fact_orders_final
WHERE order_status = 'Completed'
GROUP BY YEAR(order_date)
ORDER BY sales_year;


-- ============================================================
-- Analysis 6: Monthly Completed Sales Trend
-- Business question: Which months show stronger or weaker
-- completed sales performance?
-- ============================================================

SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS sales_month,
    COUNT(*) AS completed_orders,
    ROUND(SUM(total_revenue), 2) AS completed_revenue,
    ROUND(SUM(gross_profit), 2) AS recorded_gross_profit,
    ROUND(
        SUM(gross_profit) / NULLIF(SUM(total_revenue), 0) * 100,
        2
    ) AS gross_margin_pct
FROM fact_orders_final
WHERE order_status = 'Completed'
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY sales_month;


-- ============================================================
-- Analysis 7: Average Performance by Calendar Month
-- Business question: Are some months consistently stronger?
-- ============================================================

SELECT
    MONTH(order_date) AS month_number,
    MONTHNAME(order_date) AS month_name,
    COUNT(*) AS completed_orders_across_years,
    ROUND(SUM(total_revenue) / 3, 2)
        AS avg_monthly_revenue,
    ROUND(SUM(gross_profit) / 3, 2)
        AS avg_monthly_gross_profit,
    ROUND(
        SUM(gross_profit) / NULLIF(SUM(total_revenue), 0) * 100,
        2
    ) AS combined_gross_margin_pct
FROM fact_orders_final
WHERE order_status = 'Completed'
GROUP BY MONTH(order_date), MONTHNAME(order_date)
ORDER BY month_number;


-- ============================================================
-- Analysis 8: Product Category Performance
-- Business question: Which categories contribute most to
-- completed sales and gross profit?
-- ============================================================

SELECT
    p.category,
    COUNT(DISTINCT o.order_id) AS completed_orders,
    SUM(d.quantity) AS units_sold,
    ROUND(SUM(d.line_total_revenue), 2) AS product_revenue,
    ROUND(SUM(d.line_gross_profit), 2) AS product_gross_profit,
    ROUND(
        SUM(d.line_gross_profit)
        / NULLIF(SUM(d.line_total_revenue), 0) * 100,
        2
    ) AS gross_margin_pct
FROM fact_orders_final o
JOIN fact_order_details_analytics d
    ON o.order_id = d.order_id
JOIN dim_products_clean p
    ON d.product_id = p.product_id
WHERE o.order_status = 'Completed'
GROUP BY p.category
ORDER BY product_revenue DESC;

-- ============================================================
-- Analysis 9: Product Subcategory Performance
-- Business question: Which subcategories drive revenue,
-- gross profit, and margin?
-- ============================================================

SELECT
    p.category,
    p.subcategory,
    COUNT(DISTINCT o.order_id) AS completed_orders,
    SUM(d.quantity) AS units_sold,
    ROUND(SUM(d.line_total_revenue), 2) AS product_revenue,
    ROUND(SUM(d.line_gross_profit), 2) AS product_gross_profit,
    ROUND(
        SUM(d.line_gross_profit)
        / NULLIF(SUM(d.line_total_revenue), 0) * 100,
        2
    ) AS gross_margin_pct
FROM fact_orders_final o
JOIN fact_order_details_analytics d
    ON o.order_id = d.order_id
JOIN dim_products_clean p
    ON d.product_id = p.product_id
WHERE o.order_status = 'Completed'
GROUP BY p.category, p.subcategory
ORDER BY product_gross_profit DESC;


-- ============================================================
-- Analysis 10: Product-Level Performance
-- Business question: Which products drive revenue and profit?
-- ============================================================

SELECT
    p.product_id,
    p.product_name,
    p.category,
    p.subcategory,
    SUM(d.quantity) AS units_sold,
    ROUND(SUM(d.line_total_revenue), 2) AS product_revenue,
    ROUND(SUM(d.line_gross_profit), 2) AS product_gross_profit,
    ROUND(
        SUM(d.line_gross_profit)
        / NULLIF(SUM(d.line_total_revenue), 0) * 100,
        2
    ) AS gross_margin_pct
FROM fact_orders_final o
JOIN fact_order_details_analytics d
    ON o.order_id = d.order_id
JOIN dim_products_clean p
    ON d.product_id = p.product_id
WHERE o.order_status = 'Completed'
GROUP BY
    p.product_id,
    p.product_name,
    p.category,
    p.subcategory
ORDER BY product_gross_profit DESC
LIMIT 15;


-- ============================================================
-- Analysis 11: High-Revenue, Low-Margin Products
-- ============================================================

SELECT
    p.product_id,
    p.product_name,
    p.category,
    p.subcategory,
    SUM(d.quantity) AS units_sold,
    ROUND(SUM(d.line_total_revenue), 2) AS product_revenue,
    ROUND(SUM(d.line_gross_profit), 2) AS product_gross_profit,
    ROUND(
        SUM(d.line_gross_profit)
        / NULLIF(SUM(d.line_total_revenue), 0) * 100,
        2
    ) AS gross_margin_pct
FROM fact_orders_final o
JOIN fact_order_details_analytics d
    ON o.order_id = d.order_id
JOIN dim_products_clean p
    ON d.product_id = p.product_id
WHERE o.order_status = 'Completed'
GROUP BY
    p.product_id,
    p.product_name,
    p.category,
    p.subcategory
HAVING SUM(d.line_total_revenue) >= 500000
ORDER BY gross_margin_pct ASC
LIMIT 15;


-- ============================================================
-- Analysis 12: Customer Repeat-Purchase Behavior
-- ============================================================

WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(*) AS completed_orders,
        SUM(total_revenue) AS total_revenue,
        SUM(gross_profit) AS total_gross_profit
    FROM fact_orders_final
    WHERE order_status = 'Completed'
    GROUP BY customer_id
)
SELECT
    COUNT(*) AS customers_with_completed_orders,
    SUM(CASE WHEN completed_orders > 1 THEN 1 ELSE 0 END)
        AS repeat_customers,
    SUM(CASE WHEN completed_orders = 1 THEN 1 ELSE 0 END)
        AS one_time_customers,
    ROUND(
        SUM(CASE WHEN completed_orders > 1 THEN 1 ELSE 0 END)
        / COUNT(*) * 100,
        2
    ) AS repeat_customer_pct,
    ROUND(SUM(total_revenue), 2) AS total_completed_revenue,
    ROUND(
        SUM(CASE WHEN completed_orders > 1 THEN total_revenue ELSE 0 END),
        2
    ) AS repeat_customer_revenue,
    ROUND(
        SUM(CASE WHEN completed_orders > 1 THEN total_revenue ELSE 0 END)
        / NULLIF(SUM(total_revenue), 0) * 100,
        2
    ) AS repeat_customer_revenue_pct
FROM customer_orders;


-- ============================================================
-- Analysis 13: Sales Performance by Loyalty Tier
-- ============================================================

SELECT
    c.loyalty_tier,
    COUNT(DISTINCT o.customer_id) AS unique_customers,
    COUNT(*) AS completed_orders,
    ROUND(SUM(o.total_revenue), 2) AS total_revenue,
    ROUND(SUM(o.gross_profit), 2) AS total_gross_profit,
    ROUND(
        SUM(o.gross_profit)
        / NULLIF(SUM(o.total_revenue), 0) * 100,
        2
    ) AS gross_margin_pct,
    ROUND(
        SUM(o.total_revenue) / NULLIF(COUNT(*), 0),
        2
    ) AS average_order_value
FROM fact_orders_final o
JOIN dim_customers_analytics c
    ON o.customer_id = c.customer_id
WHERE o.order_status = 'Completed'
GROUP BY c.loyalty_tier
ORDER BY total_revenue DESC;


-- ============================================================
-- Analysis 14: Regional Sales Performance
-- ============================================================

SELECT
    s.region,
    COUNT(DISTINCT o.order_id) AS completed_orders,
    COUNT(DISTINCT o.customer_id) AS unique_customers,
    ROUND(SUM(o.total_revenue), 2) AS total_revenue,
    ROUND(SUM(o.gross_profit), 2) AS total_gross_profit,
    ROUND(
        SUM(o.gross_profit)
        / NULLIF(SUM(o.total_revenue), 0) * 100,
        2
    ) AS gross_margin_pct,
    ROUND(
        SUM(o.total_revenue) / NULLIF(COUNT(DISTINCT o.order_id), 0),
        2
    ) AS average_order_value
FROM fact_orders_final o
JOIN dim_stores_analytics s
    ON o.store_id = s.store_id
WHERE o.order_status = 'Completed'
GROUP BY s.region
ORDER BY total_revenue DESC;


-- ============================================================
-- Analysis 15: Store-Level Sales Performance
-- ============================================================

SELECT
    s.store_id,
    s.store_name,
    s.city,
    s.region,
    s.store_type,
    COUNT(DISTINCT o.order_id) AS completed_orders,
    COUNT(DISTINCT o.customer_id) AS unique_customers,
    ROUND(SUM(o.total_revenue), 2) AS total_revenue,
    ROUND(SUM(o.gross_profit), 2) AS total_gross_profit,
    ROUND(
        SUM(o.gross_profit)
        / NULLIF(SUM(o.total_revenue), 0) * 100,
        2
    ) AS gross_margin_pct,
    ROUND(
        SUM(o.total_revenue)
        / NULLIF(COUNT(DISTINCT o.order_id), 0),
        2
    ) AS average_order_value
FROM fact_orders_final o
JOIN dim_stores_analytics s
    ON o.store_id = s.store_id
WHERE o.order_status = 'Completed'
GROUP BY
    s.store_id,
    s.store_name,
    s.city,
    s.region,
    s.store_type
ORDER BY total_revenue DESC;


-- ============================================================
-- Analysis 16: Performance by Store Type
-- ============================================================

SELECT
    s.store_type,
    COUNT(DISTINCT s.store_id) AS number_of_stores,
    COUNT(DISTINCT o.order_id) AS completed_orders,
    ROUND(SUM(o.total_revenue), 2) AS total_revenue,
    ROUND(SUM(o.gross_profit), 2) AS total_gross_profit,
    ROUND(
        SUM(o.gross_profit)
        / NULLIF(SUM(o.total_revenue), 0) * 100,
        2
    ) AS gross_margin_pct,
    ROUND(
        SUM(o.total_revenue) / NULLIF(COUNT(DISTINCT o.order_id), 0),
        2
    ) AS average_order_value,
    ROUND(
        SUM(o.total_revenue) / NULLIF(COUNT(DISTINCT s.store_id), 0),
        2
    ) AS revenue_per_store
FROM fact_orders_final o
JOIN dim_stores_analytics s
    ON o.store_id = s.store_id
WHERE o.order_status = 'Completed'
GROUP BY s.store_type
ORDER BY total_revenue DESC;

-- ============================================================
-- Analysis 17: Return Trends by Year
-- ============================================================

SELECT
    YEAR(return_date) AS return_year,
    COUNT(*) AS total_returns,
    COUNT(DISTINCT order_id) AS unique_returned_orders,
    ROUND(SUM(return_amount), 2) AS total_return_amount,
    ROUND(AVG(return_amount), 2) AS average_return_amount
FROM fact_returns_clean
GROUP BY YEAR(return_date)
ORDER BY return_year;

-- ============================================================
-- Analysis 18: Annual Recorded Return Rate
-- ============================================================

SELECT
    YEAR(order_date) AS order_year,
    COUNT(*) AS non_cancelled_orders,
    SUM(is_returned) AS orders_with_recorded_returns,
    ROUND(
        SUM(is_returned) / COUNT(*) * 100,
        2
    ) AS recorded_return_rate_pct
FROM fact_orders_final
WHERE order_status <> 'Cancelled'
GROUP BY YEAR(order_date)
ORDER BY order_year;

-- ============================================================
-- Analysis 19: Recorded Return Rate by Product Category
-- ============================================================

SELECT
    p.category,
    COUNT(DISTINCT o.order_id) AS non_cancelled_orders,
    COUNT(DISTINCT CASE
        WHEN o.is_returned = 1 THEN o.order_id
    END) AS orders_with_recorded_returns,
    ROUND(
        COUNT(DISTINCT CASE
            WHEN o.is_returned = 1 THEN o.order_id
        END)
        / NULLIF(COUNT(DISTINCT o.order_id), 0) * 100,
        2
    ) AS recorded_return_rate_pct
FROM fact_orders_final o
JOIN fact_order_details_analytics d
    ON o.order_id = d.order_id
JOIN dim_products_clean p
    ON d.product_id = p.product_id
WHERE o.order_status <> 'Cancelled'
GROUP BY p.category
ORDER BY recorded_return_rate_pct DESC;

-- ============================================================
-- Analysis 20: Recorded Return Rate by Product Subcategory
-- ============================================================

SELECT
    p.category,
    p.subcategory,
    COUNT(DISTINCT o.order_id) AS non_cancelled_orders,
    COUNT(DISTINCT CASE
        WHEN o.is_returned = 1 THEN o.order_id
    END) AS orders_with_recorded_returns,
    ROUND(
        COUNT(DISTINCT CASE
            WHEN o.is_returned = 1 THEN o.order_id
        END)
        / NULLIF(COUNT(DISTINCT o.order_id), 0) * 100,
        2
    ) AS recorded_return_rate_pct
FROM fact_orders_final o
JOIN fact_order_details_analytics d
    ON o.order_id = d.order_id
JOIN dim_products_clean p
    ON d.product_id = p.product_id
WHERE o.order_status <> 'Cancelled'
GROUP BY
    p.category,
    p.subcategory
ORDER BY recorded_return_rate_pct DESC;

-- ============================================================
-- Analysis 21: Sales Performance by Payment Method
-- ============================================================

SELECT
    payment_method,
    COUNT(*) AS completed_orders,
    ROUND(SUM(total_revenue), 2) AS total_revenue,
    ROUND(SUM(gross_profit), 2) AS total_gross_profit,
    ROUND(
        SUM(gross_profit)
        / NULLIF(SUM(total_revenue), 0) * 100,
        2
    ) AS gross_margin_pct,
    ROUND(AVG(total_revenue), 2) AS average_order_value
FROM fact_orders_final
WHERE order_status = 'Completed'
GROUP BY payment_method
ORDER BY total_revenue DESC;

-- ============================================================
-- Analysis 22: Inspect Discount Values
-- ============================================================

SELECT
    discount_pct,
    COUNT(*) AS order_detail_rows,
    ROUND(AVG(line_total_revenue), 2) AS average_line_revenue,
    ROUND(
        SUM(line_gross_profit)
        / NULLIF(SUM(line_total_revenue), 0) * 100,
        2
    ) AS gross_margin_pct
FROM fact_order_details_analytics
GROUP BY discount_pct
ORDER BY discount_pct;

-- ============================================================
-- Analysis 23: Discount Impact on Completed Sales
-- ============================================================

SELECT
    d.discount_pct,
    COUNT(*) AS order_detail_rows,
    COUNT(DISTINCT o.order_id) AS completed_orders,
    SUM(d.quantity) AS units_sold,
    ROUND(SUM(d.line_total_revenue), 2) AS total_revenue,
    ROUND(SUM(d.line_gross_profit), 2) AS total_gross_profit,
    ROUND(
        SUM(d.line_gross_profit)
        / NULLIF(SUM(d.line_total_revenue), 0) * 100,
        2
    ) AS gross_margin_pct
FROM fact_orders_final o
JOIN fact_order_details_analytics d
    ON o.order_id = d.order_id
WHERE o.order_status = 'Completed'
GROUP BY d.discount_pct
ORDER BY d.discount_pct;

-- ============================================================
-- Analysis 24: Discount Impact by Product Category
-- ============================================================

SELECT
    p.category,
    d.discount_pct,
    COUNT(*) AS order_detail_rows,
    SUM(d.quantity) AS units_sold,
    ROUND(SUM(d.line_total_revenue), 2) AS total_revenue,
    ROUND(SUM(d.line_gross_profit), 2) AS total_gross_profit,
    ROUND(
        SUM(d.line_gross_profit)
        / NULLIF(SUM(d.line_total_revenue), 0) * 100,
        2
    ) AS gross_margin_pct
FROM fact_orders_final o
JOIN fact_order_details_analytics d
    ON o.order_id = d.order_id
JOIN dim_products_clean p
    ON d.product_id = p.product_id
WHERE o.order_status = 'Completed'
GROUP BY
    p.category,
    d.discount_pct
ORDER BY
    p.category,
    d.discount_pct;
    
    -- ============================================================
-- Analysis 25: Products with Negative Gross Profit
-- ============================================================

SELECT
    p.product_id,
    p.product_name,
    p.category,
    p.subcategory,
    d.discount_pct,
    COUNT(*) AS order_detail_rows,
    SUM(d.quantity) AS units_sold,
    ROUND(SUM(d.line_total_revenue), 2) AS total_revenue,
    ROUND(SUM(d.line_gross_profit), 2) AS total_gross_profit,
    ROUND(
        SUM(d.line_gross_profit)
        / NULLIF(SUM(d.line_total_revenue), 0) * 100,
        2
    ) AS gross_margin_pct
FROM fact_orders_final o
JOIN fact_order_details_analytics d
    ON o.order_id = d.order_id
JOIN dim_products_clean p
    ON d.product_id = p.product_id
WHERE o.order_status = 'Completed'
GROUP BY
    p.product_id,
    p.product_name,
    p.category,
    p.subcategory,
    d.discount_pct
HAVING SUM(d.line_gross_profit) < 0
ORDER BY total_gross_profit ASC;

-- ============================================================
-- Analysis 26: Overall Impact of Negative-Gross-Profit Lines
-- ============================================================

SELECT
    COUNT(*) AS total_completed_detail_rows,

    SUM(
        CASE
            WHEN d.line_gross_profit < 0 THEN 1
            ELSE 0
        END
    ) AS loss_making_detail_rows,

    ROUND(
        SUM(
            CASE
                WHEN d.line_gross_profit < 0
                THEN d.line_gross_profit
                ELSE 0
            END
        ),
        2
    ) AS total_gross_loss,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN d.line_gross_profit < 0 THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS loss_making_rows_pct

FROM fact_orders_final o
JOIN fact_order_details_analytics d
    ON o.order_id = d.order_id
WHERE o.order_status = 'Completed';

-- ============================================================
-- Analysis 27: Gross Losses by Discount Level
-- ============================================================

SELECT
    d.discount_pct,
    COUNT(*) AS loss_making_detail_rows,
    SUM(d.quantity) AS units_sold,
    ROUND(SUM(d.line_total_revenue), 2) AS total_revenue,
    ROUND(SUM(d.line_gross_profit), 2) AS total_gross_loss
FROM fact_orders_final o
JOIN fact_order_details_analytics d
    ON o.order_id = d.order_id
WHERE o.order_status = 'Completed'
  AND d.line_gross_profit < 0
GROUP BY d.discount_pct
ORDER BY total_gross_loss ASC;

-- ============================================================
-- Analysis 28: Gross Losses as a Share of Total Gross Profit
-- ============================================================

SELECT
    ROUND(SUM(d.line_gross_profit), 2)
        AS total_completed_gross_profit,

    ROUND(
        SUM(
            CASE
                WHEN d.line_gross_profit < 0
                THEN d.line_gross_profit
                ELSE 0
            END
        ),
        2
    ) AS gross_loss_from_negative_rows,

    ROUND(
        100.0 * ABS(
            SUM(
                CASE
                    WHEN d.line_gross_profit < 0
                    THEN d.line_gross_profit
                    ELSE 0
                END
            )
        ) / NULLIF(SUM(d.line_gross_profit), 0),
        2
    ) AS loss_as_pct_of_gross_profit

FROM fact_orders_final o
JOIN fact_order_details_analytics d
    ON o.order_id = d.order_id
WHERE o.order_status = 'Completed';