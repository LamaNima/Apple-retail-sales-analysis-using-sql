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


-- Least selling product in each country for each year based on total units sold
WITH cte AS(
	SELECT 
		p.product_name,
		YEAR(sale_date) AS years,
		st.country,
		SUM(s.quantity) as units_sold,
		DENSE_RANK() OVER (
			PARTITION BY st.country,YEAR(sale_date)
			ORDER BY SUM(s.quantity))
		AS rnk
	FROM products p
	INNER JOIN sales s
	ON p.product_id = s.product_id
	INNER JOIN stores st
	ON s.store_id = st.store_id
	GROUP BY p.product_name,YEAR(sale_date),st.country
)

SELECT product_name,years,country,units_sold 
FROM cte 
WHERE rnk = 1;


-- Number of warranty claims filed for products within 180 days of sale
SELECT 
	COUNT(w.claim_id) AS claims_within_180d
FROM sales s
JOIN warranty w ON w.sale_id = s.sale_id
WHERE DATEDIFF(DAY, s.sale_date, w.claim_date) <= 180;


-- Number of warranty claims filed for products launched in the last 2 years
SELECT 
    p.product_name,
    COUNT(w.claim_id) AS no_of_claims,
	COUNT(s.sale_id) AS total_sales
FROM sales s
LEFT JOIN warranty w
ON w.sale_id = s.sale_id
JOIN products p
ON s.product_id  = p.product_id
WHERE p.launch_date >= DATEFROMPARTS(YEAR(GETDATE())-2, 1, 1)  
  AND p.launch_date <  GETDATE()    
GROUP BY p.product_name;


-- Number of months in the last 3 years where sales exceeded 20000 units in USA
SELECT 
	DATENAME(YEAR,s.sale_date) AS yrs,
	DATENAME(MONTH,s.sale_date) AS mnth,
	SUM(s.quantity) as total_units_sold
FROM sales s
JOIN stores st
ON s.store_id = st.store_id
WHERE s.sale_date >=DATEFROMPARTS(YEAR(GETDATE())-3,1,1) 
		AND s.sale_date < GETDATE()
		AND country = 'United States'
GROUP BY DATENAME(YEAR,s.sale_date),DATENAME(MONTH,s.sale_date)
HAVING SUM(s.quantity) > 20000;


-- Top 3 categories with the most warranty claims filed in the last 3 years
SELECT TOP 3
	c.category_name,
	COUNT(claim_id) AS no_of_claims
FROM warranty w
JOIN sales s
ON w.sale_id = s.sale_id
JOIN products p
ON s.product_id = p.product_id
JOIN category c
ON p.category_id = c.category_id
WHERE s.sale_date>= DATEFROMPARTS(YEAR(GETDATE())-3,1,1) 
	AND s.sale_date < GETDATE()
GROUP BY c.category_name
ORDER BY COUNT(claim_id) DESC;
