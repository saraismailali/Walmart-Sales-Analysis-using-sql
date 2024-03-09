create database if not exists salesDataWalmart;

CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);
-- Day Time column added
SELECT
     time,
     ( CASE 
           WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN 'Morning'
		   WHEN `time` BETWEEN "12:01:00" AND "15:00:00" THEN 'Afternoon'
           ELSE "Evening"
     END) AS time_of_date
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);
UPDATE SALES
SET time_of_day =(
CASE 
           WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN 'Morning'
		   WHEN `time` BETWEEN "12:01:00" AND "15:00:00" THEN 'Afternoon'
           ELSE "Evening"
     END);
-- DAY NAME column added
SELECT 
      date,
      DAYNAME(date) AS day_name
FROM SALES;

ALTER TABLE SALES ADD COLUMN day_name VARCHAR(10);

UPDATE sales 
SET day_name= DAYNAME(date)

-- MONTH NAME column added

SELECT 
      date, 
      monthname(date)
FROM SALES;

ALTER TABLE SALES ADD COLUMN month_name varchar(20);
update sales
SET month_name= monthname(date)

-- Generic questions --

-- How many unique cities does the data have? --
SELECT 
      DISTINCT city 
from sales;

-- In which city is each branch?
SELECT 
      DISTINCT city,branch 
from sales;

-- Product questions--
-- How many unique product lines does the data have?
Select 
	 count(distinct product_line)
FROM SALES;

-- What is the most selling product line
SELECT 
      sum(quantity) as qty,
      product_line
FROM sales
group by product_line
ORDER BY qty DESC;

-- What is the total revenue by month
SELECT 
     sum(total) as total_revenue,
     month_name 
from sales
group by month_name
order by total_revenue;

-- What month had the largest COGS?
Select 
     sum(cogs) as cogs, 
     month_name as month
FROM sales
group by month
order by cogs

-- What product line had the largest revenue?
Select 
      sum(total) as revenue,
      product_line
from sales
group by producT_line
order by revenue desc;

-- What is the most common payment method?
Select 
     payment, 
     count(payment) AS cnt
FROM sales
GROUP by payment
order by cnt desc; 

-- What is the city with the largest revenue?
SELECT
	branch,
	city,
	SUM(total) AS total_revenue
FROM sales
GROUP BY city, branch 
ORDER BY total_revenue;


-- What product line had the largest VAT?
SELECT
	product_line,
	AVG(tax_pct) as avg_tax
FROM sales
GROUP BY product_line
ORDER BY avg_tax DESC;

-- Fetch each product line and add a column to those product 
SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > 6 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM sales
GROUP BY product_line;

-- Which branch sold more products than the average product sold?
SELECT 
     branch,
     sum(quantity) as qty
FROM sales
GROUP BY branch
HAVING SUM(quantity)> avg(quantity) ;

SELECT 
     product_line , gender, count(gender) as cnt
FROM sales
GROUP by product_line, gender
order by cnt desc;

SELECT 
     product_line, round(avg(rating),2) as average_rating
FROM sales
group by product_line
order by average_rating desc;