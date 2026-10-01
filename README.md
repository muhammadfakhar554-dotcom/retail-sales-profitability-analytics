# Retail Sales & Profitability Analytics

## Project Overview

This project analyzes three years of retail transaction data to understand sales performance, profitability, customer purchasing behavior, product performance, store performance, and return patterns.

The project uses SQL for data cleaning, transformation, validation, and analysis, followed by Power BI for interactive visualization and business reporting.

> **Note:** The dataset is a fictional educational dataset created for analytics and portfolio purposes. The findings from this project should not be interpreted as actual business performance of a real company.

---

## Business Problem

Management wants to better understand how the retail business is performing across different areas of the business, including:

* Sales and revenue trends
* Gross profitability
* Customer purchasing behavior
* Product and category performance
* Store and regional performance
* Product and order returns

The goal is to identify meaningful patterns and areas that may require further business attention.

---

## Project Objective

Analyze three years of retail transaction data to evaluate:

* Sales performance
* Gross profit and gross margin
* Customer purchasing behavior
* Product and category performance
* Store and regional performance
* Return patterns

The analysis will then translate the findings into business insights and recommendations.

---

## Key Business Questions

### Sales

* How have sales changed over time?
* Which stores, regions, and product categories generate the most revenue?
* Are there noticeable seasonal patterns?

### Profitability

* Which products and categories generate the most gross profit?
* Which products generate high revenue but relatively low margins?
* How does profitability vary across stores and regions?

### Customers

* How many customers are purchasing from the business?
* How frequently do customers make purchases?
* Which customers have the highest purchase value?
* What patterns can be observed between repeat and less frequent customers?

### Products

* Which products generate the most revenue and profit?
* Which categories, subcategories, and brands perform best?
* Are there products with strong sales but weak profitability?

### Stores

* Which stores and regions perform best in terms of revenue and gross profit?
* How does performance differ by store type?
* How does store size relate to sales performance?

### Returns

* What percentage of orders are returned?
* What are the most common return reasons?
* Which products, categories, or stores have higher return activity?
* How do return patterns change over time?

---

## Dataset

The dataset contains retail transactions covering **2022–2024**.

It includes:

* Customer information
* Product information
* Store information
* Employee information
* Date information
* Orders
* Order details
* Returns

### Main Tables

| Table                   | Description                                           |
| ----------------------- | ----------------------------------------------------- |
| `dim_customers`         | Customer information                                  |
| `dim_date`              | Calendar and date attributes                          |
| `dim_employees`         | Employee information                                  |
| `dim_products`          | Product, category, brand, price, and cost information |
| `dim_stores`            | Store information                                     |
| `fact_orders_2022_2023` | Orders from 2022–2023                                 |
| `fact_orders_2024`      | Orders from 2024                                      |
| `fact_order_details`    | Individual products within each order                 |
| `fact_returns`          | Return transactions                                   |

---

## Tools

* SQL
* MySQL
* Power BI
* GitHub

---

## Project Status

**Current stage:** Project setup and dataset preparation

The next stages will include:

1. Data exploration and quality checks
2. Data cleaning
3. Data transformation
4. SQL analysis
5. Power BI dashboard development
6. Business insights and recommendations
