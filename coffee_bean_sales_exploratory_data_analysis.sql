-- EXPLORATORY DATA ANALYSIS
-- Dataset source: https://www.kaggle.com/datasets/saadharoon27/coffee-bean-sales-raw-dataset
-- Data cleaning: https://github.com/tomasdeambrosi/portfolio_projects/blob/main/coffee_bean_sales_data_cleaning.sql

SELECT * FROM
orders;

SELECT *
FROM products;

SELECT *
FROM customers;

-- Most expensive product
SELECT *
FROM products
ORDER BY `Price per 100g` DESC
LIMIT 1;

-- Less expensive product
SELECT *
FROM products
ORDER BY `Price per 100g` ASC
LIMIT 1;

-- Top 5 most profitable products per unit (without considering sales)
SELECT *
FROM products
ORDER BY Profit DESC
LIMIT 5;

-- Total revenue per coffee type and roast type
SELECT `Coffee Type`, `Roast Type`, SUM(Quantity * Profit) AS total_profit
FROM orders as ord
JOIN products as prod
	ON ord.`Product ID` = prod.`Product ID`
GROUP BY `Coffee Type`, `Roast Type`
ORDER BY total_profit DESC;

-- Largests clients
SELECT cus.`Customer Name`, SUM(ord.Quantity * pro.Profit) AS total_profit
FROM orders AS ord
JOIN customers AS cus
	ON ord.`Customer ID` = cus.`Customer ID`
JOIN products AS pro
	ON ord.`Product ID` = pro.`Product ID`
GROUP BY cus.`Customer Name`
ORDER BY total_profit DESC;

-- Total revenue by country
SELECT cus.Country, SUM(ord.Quantity * pro.Profit) AS total_profit
FROM orders AS ord
JOIN customers AS cus
	ON ord.`Customer ID` = cus.`Customer ID`
JOIN products AS pro
	ON ord.`Product ID` = pro.`Product ID`
GROUP BY cus.Country
ORDER BY total_profit DESC;

-- Total revenue by year
SELECT YEAR(ord.`Order Date`), SUM(ord.Quantity * pro.Profit) AS total_profit
FROM orders AS ord
JOIN customers AS cus
	ON ord.`Customer ID` = cus.`Customer ID`
JOIN products AS pro
	ON ord.`Product ID` = pro.`Product ID`
GROUP BY YEAR(ord.`Order Date`)
ORDER BY total_profit DESC;

-- Total revenue by country and year
SELECT cus.Country, YEAR(ord.`Order Date`) AS order_year, SUM(ord.Quantity * pro.Profit) AS total_profit
FROM orders AS ord
JOIN customers AS cus
    ON ord.`Customer ID` = cus.`Customer ID`
JOIN products AS pro
    ON ord.`Product ID` = pro.`Product ID`
GROUP BY cus.Country, YEAR(ord.`Order Date`)
ORDER BY total_profit DESC;

-- Average daily sales
SELECT AVG(daily_total) AS avg_daily_sales
FROM (
    SELECT DATE(ord.`Order Date`) AS order_day, SUM(ord.Quantity * pro.Profit) AS daily_total
    FROM orders AS ord
    JOIN products AS pro
        ON ord.`Product ID` = pro.`Product ID`
    GROUP BY DATE(`Order Date`)
) AS daily_totals;

-- Days above average daily sales
SELECT DATE(ord.`Order Date`) AS order_day, SUM(ord.Quantity * pro.Profit) AS daily_total
FROM orders AS ord
JOIN products AS pro
	ON ord.`Product ID` = pro.`Product ID`
GROUP BY DATE(ord.`Order Date`)
HAVING daily_total > (
    SELECT AVG(daily_total) 
    FROM (
        SELECT SUM(ord2.Quantity * pro2.Profit) AS daily_total
        FROM orders AS ord2
        JOIN products AS pro2
            ON ord2.`Product ID` = pro2.`Product ID`
        GROUP BY DATE(ord2.`Order Date`)
    ) AS daily_totals
)
ORDER BY daily_total DESC;