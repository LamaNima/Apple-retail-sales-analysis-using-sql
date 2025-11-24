# Apple Product Sales & Warranty Analytics — SQL Project

This project showcases my ability to design relational database schemas, optimize database performance using indexing, and write advanced analytical SQL queries. The dataset models Apple product sales, store performance, pricing segmentation, and warranty claim trends. The entire workflow—from schema creation to insights generation—was completed using Microsoft SQL Server.

## Project Overview

The goal of this project was to simulate a real-world retail analytics system for Apple Stores.
It includes:

- Designing normalized database schemas
- Implementing indexes for faster query execution
- Writing analytical SQL queries using window functions, CASE expressions, joins, and aggregations
- Answering business questions related to sales performance, pricing segments, store trends, and warranty behavior

This project demonstrates strong SQL proficiency, database optimization skills, and analytical thinking.

## Dataset

The raw data files used in this project are available at:  
🔗 [Kaggle - Apple_Retail_Sales_Dataset](https://www.kaggle.com/datasets/amangarg08/apple-retail-sales-dataset)
- **Size**: 1 million+ rows of sales data.
- **Period Covered**: The data spans multiple years, allowing for long-term trend analysis.
- **Geographical Coverage**: Sales data from Apple stores across various countries.

## Entity Relationship Diagram (ERD)

![ERD](https://github.com/najirh/Apple-Retail-Sales-SQL-Project---Analyzing-Millions-of-Sales-Rows/blob/main/erd.png)

## Database Schema

The project uses five main tables:
1. **category**: Holds product category information.
   - `category_id`: Unique identifier for each product category.
   - `category_name`: Name of the category.

2. **products**: Details about Apple products.
   - `product_id`: Unique identifier for each product.
   - `product_name`: Name of the product.
   - `category_id`: References the category table.
   - `launch_date`: Date when the product was launched.
   - `price`: Price of the product.

3. **sales**: Stores sales transactions.
   - `sale_id`: Unique identifier for each sale.
   - `sale_date`: Date of the sale.
   - `store_id`: References the store table.
   - `product_id`: References the product table.
   - `quantity`: Number of units sold.

4. **stores**: Contains information about Apple retail stores.
   - `store_id`: Unique identifier for each store.
   - `store_name`: Name of the store.
   - `city`: City where the store is located.
   - `country`: Country of the store.

5. **warranty**: Contains information about warranty claims.
   - `claim_id`: Unique identifier for each warranty claim.
   - `claim_date`: Date the claim was made.
   - `sale_id`: References the sales table.
   - `repair_status`: Status of the warranty claim (e.g., Paid Repaired, Warranty Void).

## Business Problems
### Basic & Descriptive Analytics

1. How many stores are there in each country?
2. How many units were sold by each store?
3. How many sales occurred in November 2024?
4. How many stores never had a warranty claim filed?
5. What percentage of warranty claims are marked as completed?
6. Which store had the highest total units sold in the last year?
7. How many unique products were sold last year?
8. What is the average price of products in each category?
9. How many warranty claims were filed in February 2024?
10. What is the best-selling weekday for each store based on quantity sold?
11. What is the best-selling month for each store in 2024?
    
### Advanced & Multi-level Analytics

12. What is the least-selling product in each country for each year based on units sold?
13. How many warranty claims were filed for products within 180 days of sale?
14. How many warranty claims were filed for products launched in the last 2 years?
15. In the last 3 years, how many months did the USA have total sales above 20,000 units?
16. What are the top 3 categories with the most warranty claims filed in the last 3 years?
17. What is the percentage chance of receiving a warranty claim after each purchase for each country?
18. What is the year-by-year growth ratio for each store?
19. What is the relationship between product price segments and number of warranty claims in the last 2 years?
20. What is the monthly running total of sales for each store over the past 4 years?

## Query Optimization Using Indexing

To significantly improve query performance, I implemented covering indexes on the sales table. These indexes were designed based on the most frequently filtered and joined columns.
- Built covering indexes to avoid unnecessary lookups
- Indexed high-cardinality columns used in WHERE clauses
- Included frequently selected columns to provide seek + fetch access
- Achieved 5x–20x performance improvement in analytical queries

## Conclusion

This project reflects my ability to:
- Design efficient database systems
- Write optimized SQL for analytics
- Translate business problems into technical solutions
- Produce clean, readable, and well-structured SQL code
