# E-Commerce Sales Analytics

End-to-end Data Analyst portfolio project analyzing e-commerce sales performance, customer behavior, product performance, profitability, and operational performance using SQL, Python, and Power BI.

Disclaimer

This project uses a simulated e-commerce dataset created for portfolio and learning purposes.

The dataset does not represent a real company's confidential data.

The purpose of this project is to demonstrate practical Data Analyst skills including SQL analysis, Python EDA, data modeling, DAX, Power BI dashboard development, and business insight generation.

## Project Overview

This project analyzes an e-commerce business with:

- 20,000 customers
- 50 product categories
- 500 suppliers
- 1,000 products
- 100,000 orders
- 271,636 order items
- 100,000 payments
- 100,000 shipments

The project follows an end-to-end Data Analyst workflow:

Raw Data
→ SQL Analysis
→ Python EDA
→ Data Modeling
→ DAX
→ Power BI Dashboard
→ Business Insights

## Business Questions

The analysis aims to answer:

1. How is revenue performing over time?
2. Which product categories generate the highest revenue and profit?
3. Which products have the highest revenue, profit, margin, and sales quantity?
4. Which customer segments generate the most revenue?
5. How many customers make repeat purchases?
6. Who are the highest-value customers?
7. How do order statuses perform?
8. Which payment methods are most commonly used?
9. How is shipment performance?
10. What business insights can be derived from the data?

## Tools & Technologies

- MySQL
- SQL
- Python
- Pandas
- Power BI
- DAX
- GitHub

## Data Model

The project contains eight related tables:

- customers
- categories
- suppliers
- products
- orders
- order_items
- payments
- shipments

Main relationships:

customers
→ orders
→ order_items
→ products
→ categories

products
→ suppliers

orders
→ payments

orders
→ shipments

## SQL Analysis

SQL was used for:

- Data validation
- Revenue analysis
- Profit analysis
- Category performance
- Product performance
- City performance
- Customer analysis
- Monthly revenue trends
- Repeat customer analysis
- Order status analysis

## Python EDA

Python and Pandas were used to:

- Load and inspect the datasets
- Check data quality
- Analyze revenue and profit
- Analyze customer segments
- Analyze product performance
- Analyze monthly revenue trends
- Investigate business performance

## Power BI Dashboard

The Power BI dashboard contains four analytical pages.

### 1. Executive Overview

Provides an overview of:

- Completed Revenue
- Completed Profit
- Profit Margin
- Completed Orders
- Monthly Revenue Trend
- Revenue by Category
- Revenue by City

### 2. Product Performance

Analyzes:

- Revenue
- Profit
- Profit Margin
- Quantity Sold
- Top 10 Products by Revenue
- Top 10 Products by Profit

### 3. Customer Analysis

Analyzes:

- Customer count
- Repeat customers
- Average Revenue per Customer
- Revenue by Customer Segment
- Customer distribution by segment
- Top 10 Customers
- Average Revenue per Customer by City

### 4. Operations Analysis

Analyzes:

- Completed Orders
- Cancelled Orders
- Returned Orders
- Order Status Distribution
- Payment Methods
- Shipment Status
- Average Delivery Days

## Key Findings

### Overall Business Performance

Completed orders generated:

- Revenue: Rp2,559,379,566,250
- Profit: Rp711,454,129,926
- Profit Margin: 27.80%
- Completed Orders: 89,956

### Category Performance

Category 47 generated the highest revenue and profit.

However, Category 41 achieved the highest profit margin.

This shows that the category generating the most revenue is not necessarily the category with the best profitability efficiency.

### Product Performance

Different products lead different business metrics:

- Product 769 → highest revenue
- Product 577 → highest profit and margin
- Product 380 → highest quantity sold

This indicates that sales volume, revenue, and profitability do not always identify the same products.

### Customer Analysis

13,415 customers made more than one completed order.

The Regular segment generated the highest total revenue, largely associated with its larger customer base.

The customer with the highest revenue did not have the highest number of orders.

Customer 9747 generated the highest revenue with 35 completed orders, while the highest completed order count among customers was 43.

This indicates that customer revenue is influenced not only by purchase frequency but also by transaction value.

### Monthly Revenue

The highest monthly revenue occurred in August 2024:

Rp112,427,109,100

The lowest monthly revenue occurred in February 2024:

Rp100,015,195,450

The difference was associated with differences in:

- Number of orders
- Number of customers
- Quantity sold
- Average revenue per order

August 2024 had approximately 300 more orders and over 200 more customers than February 2024, along with a higher average revenue per order.

## Business Recommendations

Based on the analysis:

1. Investigate the characteristics of high-margin products such as Product 577 and categories with strong margins to identify opportunities for profitable growth.

2. Monitor high-revenue products separately from high-profit products because revenue leadership does not always translate into the highest profitability.

3. Develop retention strategies for repeat customers because repeat purchasing represents a significant portion of the customer base.

4. Analyze high-value customers based on both purchase frequency and average order value to identify opportunities for customer segmentation and targeted offers.

5. Investigate the drivers behind monthly revenue fluctuations by monitoring order volume, customer volume, quantity sold, and average order value.

## Project Structure

```text
ecommerce-sales-analytics/
│
├── README.md
│
├── sql/
│   └── ecommerce_analysis.sql
│
├── python/
│   └── ecommerce_eda.ipynb
│
├── powerbi/
│   └── ecommerce_sales_analytics.pbix
│
└── screenshots/
    ├── executive_overview.png
    ├── product_performance.png
    ├── customer_analysis.png
    └── operations_analysis.png
