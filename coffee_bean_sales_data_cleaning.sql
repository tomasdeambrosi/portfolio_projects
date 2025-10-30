-- DATA CLEANING
-- Dataset source: https://www.kaggle.com/datasets/saadharoon27/coffee-bean-sales-raw-dataset

SELECT * FROM
orders;

SELECT *
FROM products;

SELECT *
FROM customers;

-- 1. ORDERS
-- 1.1 Drop empty columns from orders
ALTER TABLE orders
DROP COLUMN `Customer Name`,
DROP COLUMN Email,
DROP COLUMN Country,
DROP COLUMN `Coffee Type`,
DROP COLUMN `Roast Type`,
DROP COLUMN Size,
DROP COLUMN `Unit Price`,
DROP COLUMN Sales;

-- 1.2 Convert `Order Date` to DATE
ALTER TABLE orders
ADD COLUMN order_date DATE;

UPDATE orders
SET order_date = STR_TO_DATE(`Order Date`, '%d/%m/%Y');

ALTER TABLE orders
DROP COLUMN `Order Date`;

ALTER TABLE orders
CHANGE COLUMN order_date `Order Date` DATE;

ALTER TABLE orders
MODIFY COLUMN `Order Date` DATE AFTER `Order ID`;

-- 2. PRODUCTS
-- 2.1 Convert `Size` to DECIMAL
UPDATE products
SET Size = REPLACE(Size, ',', '.');

ALTER TABLE products
MODIFY COLUMN Size DECIMAL(10,1);

-- 2.2 Convert `Unit Price` to DECIMAL
UPDATE products
SET `Unit Price` = REPLACE(`Unit Price`, ',', '.');

ALTER TABLE products
MODIFY COLUMN `Unit Price` DECIMAL(10,3);

-- 2.3 Convert `Price per 100g` to DECIMAL
UPDATE products
SET `Price per 100g` = REPLACE(`Price per 100g`, ',', '.');

ALTER TABLE products
MODIFY COLUMN `Price per 100g` DECIMAL(10,4);

-- 2.4 Convert `Profit` to DECIMAL
UPDATE products
SET Profit = REPLACE(Profit, ',', '.');

ALTER TABLE products
MODIFY COLUMN Profit DECIMAL(10,5);
