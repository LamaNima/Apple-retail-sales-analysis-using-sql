CREATE TABLE category(
	category_id VARCHAR(10) PRIMARY KEY,
	cagtegory_name VARCHAR(20)
)

CREATE TABLE products(
	product_id VARCHAR(10),
	product_name VARCHAR(40),
	launch_date DATE,
	category_id VARCHAR(10),
	price FLOAT,
	CONSTRAINT product_pk PRIMARY KEY (product_id),
	CONSTRAINT product_fk FOREIGN KEY (category_id) REFERENCES category(category_id)
)

CREATE TABLE sales(
	sale_id VARCHAR(20) PRIMARY KEY,
	sale_date DATE,
	store_id VARCHAR(10),
	product_id VARCHAR(10),
	quantity INTEGER,
	CONSTRAINT sales_stores_fk FOREIGN KEY (store_id) REFERENCES stores(store_id),
	CONSTRAINT sales_products_fk FOREIGN KEY(product_id) REFERENCES products(product_id)
)

CREATE TABLE stores(
	store_id VARCHAR(10) PRIMARY KEY,
	store_name VARCHAR(30),
	city VARCHAR(30),
	country VARCHAR(25)
)

CREATE TABLE warranty(
	claim_id VARCHAR(10) PRIMARY KEY,
	claim_date DATE,
	sale_id VARCHAR(20),
	repair_status VARCHAR(15)
	CONSTRAINT warranty_fk FOREIGN KEY (sale_id) REFERENCES sales(sale_id)
)

