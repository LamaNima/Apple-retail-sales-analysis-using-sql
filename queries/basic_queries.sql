/*
	SECTION 1 - Common Business Queries
*/
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


-- Percentage of warranty claim marked as completed
SELECT 
	ROUND(
	(COUNT(CASE WHEN repair_status = 'Completed' THEN claim_id END)*1.0/COUNT(claim_id) * 100),2) as pct_completed
FROM warranty;


-- Store with the highest total units sold in the last year
SELECT TOP 1 st.store_id,store_name,SUM(quantity) as total_units_sold
FROM sales s
JOIN stores st
ON s.store_id = st.store_id
WHERE s.sale_date >= DATEFROMPARTS(YEAR(GETDATE())-1,1,1) AND s.sale_date <DATEFROMPARTS(YEAR(GETDATE()),1,1)
GROUP BY st.store_id, st.store_name
ORDER BY 3 DESC; 


-- Number of unique products sold last year
SELECT COUNT(DISTINCT p.product_name)
FROM products p
JOIN sales s
ON p.product_id = s.product_id
WHERE 
	s.sale_date >= DATEFROMPARTS(YEAR(GETDATE())-1,1,1) 
	AND s.sale_date < DATEFROMPARTS(YEAR(GETDATE()),1,1);


-- Average price of products in each category
SELECT
	c.category_id,
	c.category_name,
	ROUND(AVG(price),2) as average_price
FROM products P 
INNER JOIN category c
ON p.category_id = c.category_id
GROUP BY c.category_id,c.category_name;


-- Number of warranty claims filed in FEBRUARY,2024
SELECT COUNT(claim_id) as Number_of_warranty_claims_in_feb 
FROM warranty
WHERE DATEPART(MONTH,claim_date) = 2;


-- Best selling weekday for each store based on the highest quantity sold
WITH cte AS(
	SELECT 
		st.store_id,
		st.store_name,
		DATENAME(WEEKDAY,s.sale_date) as day_name,
		SUM(quantity) as units_sold,
		RANK() OVER(
			PARTITION BY st.store_name 
			ORDER BY SUM(quantity) DESC) as rnk
	FROM sales s 
	JOIN stores st
	ON s.store_id = st.store_id
	GROUP BY 
		st.store_id,st.store_name, DATENAME(WEEKDAY,s.sale_date)
)

SELECT 
	store_name, day_name
FROM cte
WHERE rnk = 1;


-- Best selling month for each store in 2024
WITH cte AS(
	SELECT 
		s.store_id,
		st.store_name,
		DATENAME(MONTH,sale_date) as mnth,
		SUM(quantity) as units_sold,
		DENSE_RANK() OVER (
		PARTITION BY s.store_id
		ORDER BY SUM(quantity) DESC) AS rnk
	FROM sales s 
	INNER JOIN stores st
	ON s.store_id = st.store_id
	WHERE YEAR(sale_date) = 2024
	GROUP BY s.store_id,st.store_name,DATENAME(MONTH,sale_date)
)

SELECT 
	store_name,
	mnth,
	units_sold
FROM cte
WHERE rnk=1;
