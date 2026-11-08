# Retail Sales & Profitability Analytics

An end-to-end retail data analytics project using **MySQL** and **Power BI** to investigate sales performance, gross profitability, customer purchasing behavior, product performance, store performance, and return patterns across three years of retail transactions (2022–2024).

> **Dataset Disclaimer:** This project uses the fictional Lotus Group Retail Dataset, created for educational and portfolio purposes. The findings represent analysis of the supplied dataset and should not be interpreted as the actual performance of a real company.

---

## Project Overview

This project simulates the work of a Junior Data Analyst supporting a retail business.

The objective was to transform raw retail data into a structured analytical dataset, investigate business performance using SQL, and develop an interactive Power BI dashboard to communicate findings.

The project covers the end-to-end analytics workflow:

1. Data exploration and quality assessment
2. Data cleaning and standardization
3. Data transformation and preparation
4. SQL-based business analysis
5. Power BI data modeling and DAX measures
6. Interactive dashboard development
7. Business insights and recommendations

## Business Problem

Retail management needs a clearer understanding of how the business performs across its products, customers, stores, and regions.

Raw transaction data alone does not provide an easy way to identify revenue trends, compare profitability, understand repeat purchasing behavior, evaluate store performance, or investigate returns.

The analysis aims to turn this data into actionable business information and highlight areas that may require further investigation.

## Project Objectives

- Analyze sales and revenue trends from 2022 to 2024.
- Evaluate gross profit and gross margin across products, categories, stores, and regions.
- Understand customer purchasing and repeat-purchase behavior.
- Identify high-revenue and high-profit products.
- Compare store and regional performance.
- Examine recorded return activity and its changes over time.
- Investigate the relationship between discounts and loss-making sales.

## Key Business Questions

### Sales Performance
- How did completed-sales revenue change over the three-year period?
- Which product categories, stores, and regions generated the most revenue?
- How did monthly sales performance fluctuate?

### Profitability
- Which categories and products generated the most gross profit?
- Which products generated high revenue but relatively low gross margins?
- How did gross profitability differ across stores and regions?
- Which completed-sale line items generated negative gross profit?

### Customer Behavior
- How many customers made completed purchases?
- What proportion of purchasing customers made repeat purchases?
- How does revenue differ across loyalty tiers and customer regions?

### Product Performance
- Which products generated the most revenue?
- Which products contributed the most gross profit?
- How do product rankings differ when measured by revenue versus gross profit?

### Store Performance
- Which stores generated the most revenue and gross profit?
- Which stores recorded the highest and lowest gross margins?
- How did performance differ across store types and regions?

### Returns
- What proportion of eligible orders had a recorded return?
- How did the recorded return rate change over time?
- What was the total recorded return amount?

---

## Dataset

**Source:** Lotus Group Retail Dataset (Kaggle)

**Coverage:** January 2022 – December 2024

The dataset contains fictional retail data organized into dimension and fact tables.

### Main Source Tables

| Table | Description |
|---|---|
| `dim_customers` | Customer details, demographics, and loyalty information |
| `dim_date` | Calendar and date attributes |
| `dim_employees` | Employee information |
| `dim_products` | Product, category, brand, price, and cost information |
| `dim_stores` | Store details and locations |
| `fact_orders_2022_2023` | Orders from 2022 and 2023 |
| `fact_orders_2024` | Orders from 2024 |
| `fact_order_details` | Individual products and quantities within orders |
| `fact_returns` | Recorded return transactions |

### Dataset Scale

| Data | Records |
|---|---:|
| Orders | 12,000 |
| Order details | 25,099 |
| Customers after deduplication | 3,000 |
| Products | 345 |
| Stores | 15 |
| Employees | 216 |
| Recorded returns | 1,056 |

---

## Tools & Technologies

- **MySQL:** Data cleaning, transformation, validation, and business analysis.
- **Power BI:** Data modeling, DAX calculations, interactive reports, and visualization.
- **SQL:** Analytical queries, aggregations, joins, and data quality checks.
- **Git & GitHub:** Project version control and portfolio documentation.

---

## Data Quality Assessment

Initial data exploration identified several quality issues:

- 50 duplicated customer IDs, represented by 100 duplicate rows.
- 382 missing customer email values in the raw customer data.
- Inconsistent capitalization in customer gender values.
- Mixed birth-date formats in customer records.
- Leading and trailing whitespace in payment method values.
- Seven orders marked as `Returned` without corresponding records in the returns table. All seven occurred in December 2024.
- Order dates covered the complete period from 2022 through 2024.

The raw imported tables were preserved. Cleaning and standardization were performed on separate working tables.

## Data Cleaning

Cleaning was performed using separate analytical tables to preserve the original imported data.

Key activities included:

- Removed 50 duplicate customer records, reducing the customer dimension from 3,050 to 3,000 records.
- Standardized customer gender values.
- Standardized mixed customer birth-date formats.
- Preserved missing customer email addresses as `NULL` rather than generating artificial values. After deduplication, 374 customer records had missing emails.
- Removed leading and trailing whitespace from payment methods.
- Created cleaned analytical copies of customer, employee, product, store, order, order-detail, and return tables.
- Retained usable numeric product price fields and excluded redundant text-formatted pricing from analytical calculations.
- Validated row counts, uniqueness, and missing values across the cleaned tables.

## Data Transformation

The cleaned data was prepared for business analysis.

Key transformations included:

- Combined the 2022–2023 and 2024 order tables into one analytical orders table containing 12,000 unique orders.
- Calculated order-level gross profit and gross margin percentage.
- Calculated line-level gross profit and gross margin percentage for product-level analysis.
- Prepared analytical dimension tables for customers, dates, products, stores, and employees.
- Added a return indicator to identify orders associated with recorded returns.
- Validated row counts and uniqueness across the core analytical tables.

### Baseline Validation

- Total orders: 12,000
- Total order-detail records: 25,099
- Unique customers: 3,000
- Products: 345
- Stores: 15
- Employees: 216
- Recorded returned orders: 1,056
- Eligible orders for the recorded return-rate calculation: 11,505
- Recorded return rate: 9.18%
- Total recorded return amount: EGP 4,013,112.50

> **Profitability Definition:** Gross profit is calculated as revenue minus recorded product costs. It does not account for all operating expenses and must not be interpreted as net profit.

---

## SQL Analysis

SQL was used to explore the cleaned analytical tables and answer the project's business questions.

The analysis covered:

- Overall and annual sales performance.
- Monthly revenue trends.
- Revenue and gross profit by product category.
- Product-level revenue, gross profit, and gross margin.
- Loss-making product lines and discount levels.
- Customer purchasing activity and repeat-customer behavior.
- Revenue by loyalty tier and customer region.
- Store and regional performance.
- Recorded returns and return-rate trends.

The SQL analysis provided reference results for validating Power BI measures and visualizations.

---

## Power BI Dashboard

An interactive Power BI report was developed using the cleaned analytical tables and a relational data model.

The report contains four pages:

### 1. Executive Overview

Provides a high-level summary of overall business performance.

Key metrics include:
- Completed revenue
- Completed gross profit
- Completed gross margin
- Completed orders
- Average order value
- Recorded return rate

Visuals include annual revenue and gross profit trends, category comparisons, and revenue by store.

![Executive Overview](screenshots/executive-overview.png)

### 2. Sales & Profitability

Examines sales trends and profitability in greater detail.

Visuals include:
- Monthly revenue trend
- Revenue by product category
- Gross profit by product category
- Gross profit by discount level
- Loss-making product analysis

![Sales & Profitability](screenshots/sales-profitability.png)

### 3. Customers & Products

Explores customer purchasing behavior and product performance.

Visuals include:
- Customers with completed orders
- Repeat customers and repeat-customer rate
- Revenue by loyalty tier
- Customer revenue by region
- Top 10 products by revenue
- Top 10 products by gross profit

![Customers & Products](screenshots/customers-products.png)

### 4. Stores & Returns

Evaluates store performance and recorded return activity.

Visuals include:
- Revenue and gross profit by store
- Revenue by region
- Recorded return rate by year
- Recorded return amount by year
- Return transaction details

![Stores & Returns](screenshots/stores-returns.png)

---

## Key Findings

The analysis of the fictional Lotus Group Retail Dataset identified the following patterns.

### 1. Sales Performance

Completed-sales revenue increased by approximately 3.87% from 2023 to 2024. However, gross margin declined from 21.73% in 2023 to 21.23% in 2024.

### 2. Product Profitability

Electronics generated approximately EGP 30.13 million in revenue with a gross margin of 13.02%.

Clothing generated approximately EGP 9.52 million in revenue with a substantially higher gross margin of 47.47%. Despite generating less revenue, Clothing contributed more gross profit than Electronics.

### 3. Discount Impact

A total of 197 completed-sale order-detail records generated negative gross profit, resulting in combined losses of EGP 157,725.

Discount levels of 25% and 30% accounted for approximately 98.1% of the recorded loss-making line-item gross loss.

### 4. Customer Behavior

Among the 2,905 customers with completed orders, 2,601 made more than one completed purchase.

This represents a repeat-customer rate of 89.54%. Repeat customers accounted for approximately 97.4% of completed-sales revenue.

### 5. Returns

The recorded return rate changed as follows:

| Year | Recorded Return Rate |
|---|---:|
| 2022 | 9.51% |
| 2023 | 8.79% |
| 2024 | 9.23% |

The total recorded return amount across the three years was approximately EGP 4.01 million.

### 6. Store Performance

Cairo Festival City led the stores in revenue and gross profit.

Tanta Stars recorded the highest gross margin at 22.55%, followed by Luxor Mall at 22.47%. Hurghada Waterfront recorded the lowest gross margin among the stores at 19.86%.

Store comparisons should account for differences in scale and operating costs before informing investment decisions.

---

## Business Recommendations

Based on the observed patterns, the following areas may warrant further investigation:

- Review high-discount Electronics promotions, particularly discount levels of 25% and 30%, to understand their relationship with negative gross profit.
- Investigate product-level pricing, cost, and margin differences before making category-level decisions.
- Examine repeat-customer purchasing behavior to identify potential customer retention opportunities.
- Investigate return reasons and improve return tracking where more detailed data is available.
- Evaluate stores using revenue, gross profit, margin, and relevant operating-cost measures rather than revenue alone.

These recommendations identify opportunities for further analysis; they do not establish that a particular business action will produce a specific outcome.

## Limitations

- The dataset is fictional and intended for educational and portfolio purposes.
- Gross profit is calculated using recorded revenue and product costs. It does not include all operating expenses and is not equivalent to net profit.
- Observed relationships do not establish causation.
- Return records are available at order level, limiting product-specific conclusions about returns.
- Seven orders marked as `Returned` in December 2024 have no corresponding return-table record. These discrepancies were retained and documented.
- Missing customer email addresses were preserved as NULL, which limits analysis requiring complete email information.

---

## Project Structure

```text
Retail Sales & Profitability Analytics/
│
├── data/
│   ├── raw/
│   └── cleaned/
│── sql/
├   ├──01_data_quality_checks.sql
│   ├──02_cleaning.sql
├   ├──03_transformation.sql
│   ├──04_analysis.sql
├── screenshots/
│   ├── executive-overview.png
│   ├── sales-profitability.png
│   ├── customers-products.png
│   └── stores-returns.png
│
├── .gitignore
├── README.md
└── Retail_sales_analytics_dashboard.pbix
```

---

## Conclusion

This project demonstrates an end-to-end retail analytics workflow, from raw data quality assessment and SQL-based transformation to Power BI data modeling, DAX calculations, interactive reporting, and business insight generation.

It showcases practical skills in SQL, MySQL, data cleaning, analytical thinking, data modeling, Power BI, and business-focused data visualization.