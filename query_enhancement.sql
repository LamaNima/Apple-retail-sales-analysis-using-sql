-- Apple retail sales 
-- Data description
SELECT * FROM category;
SELECT * FROM products;
SELECT * FROM sales;
SELECT * FROM warranty;
SELECT * FROM stores;

-- Query performance enhancement(Creating index)
-- execution time before indexing - 0.111s
-- execution time after indexing - 0.005s
SET STATISTICS TIME,IO ON;
SELECT sale_id, product_id, quantity, sale_date, store_id
FROM sales
WHERE product_id = 'P-44';

CREATE INDEX idx_sales_product_cover
ON sales(product_id)
INCLUDE (quantity, sale_date, sale_id, store_id);

-- execution time before indexing - 0.095s
-- execution time after indexing - 0.005s
SELECT sale_id, product_id, quantity, sale_date, store_id
FROM sales
WHERE store_id = 'ST-35';

CREATE INDEX sales_store_idx
ON sales(store_id)
INCLUDE (quantity, sale_date, sale_id, product_id);

-- execution time before indexing - 0.185s
-- execution time after indexing - 0.088s
SELECT sale_id, product_id, quantity, sale_date, store_id
FROM sales
WHERE sale_date BETWEEN '2020-01-01' AND '2021-01-01';


CREATE INDEX sales_date_idx
ON sales(sale_date)
INCLUDE (quantity,store_id , sale_id, product_id);

