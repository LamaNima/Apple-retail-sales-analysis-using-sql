-- Business Problems
-- Number of stores in each country
SELECT 
	country,
	COUNT(store_id) as no_of_stores
FROM stores
GROUP BY country
ORDER BY COUNT(store_id) DESC;


-- Number of units sold by each store
SELECT 
	st.store_id,
	st.store_name,
	SUM(quantity) as number_of_units_sold
FROM stores st
INNER JOIN sales s
ON st.store_id = s.store_id
GROUP BY st.store_name,st.store_id
ORDER BY 3 DESC;


-- No. of sales in November 2024
SELECT 
	sale_date,
	COUNT(sale_id) as no_of_sales
FROM sales
WHERE sale_date>='2024-11-01' AND sale_date<'2024-12-01'
GROUP BY sale_date;


-- Number of stores that never had a warranty claim filed
SELECT COUNT(store_id) FROM stores
WHERE store_id IN (
	SELECT DISTINCT store_id	
	FROM sales s
	LEFT JOIN warranty w	
	ON s.sale_id = w.sale_id
	WHERE claim_id IS NOT NULL
)
SELECT * FROM warranty;


-- Percentage of warranty claim marked as completed
SELECT repair_status,COUNT(claim_id) as no_in_current_status
FROM warranty
GROUP BY repair_status
