-- PRODUCT EDA
-- GENERIC QUESTIONS
-- SELECTING ALL THE FIELDS
SELECT *
FROM sales
;

-- UNIQUE CITIES PRESENTED
SELECT DISTINCT city
FROM sales
;

-- WHICH CITY IS EACH BRAND
SELECT DISTINCT city, branch
FROM sales
ORDER BY branch
;



-- BUSINESS QUESTIONS
-- UNIQUE PRODUCTS LINE
SELECT DISTINCT product_line
FROM sales
;

-- MOST COMMON PAYMENT METHOD
SELECT 
	ROW_NUMBER() OVER(ORDER BY COUNT(payment_method) DESC) AS ranking, 
    payment_method, 
    COUNT(payment_method) AS no_of_methods
FROM sales
GROUP BY payment_method
ORDER BY no_of_methods DESC
;

-- MOST SELLING PRODUCT LINE
SELECT
	ROW_NUMBER() OVER(ORDER BY COUNT(product_line) DESC) AS ranking, 
    product_line, 
    COUNT(product_line) AS no_of_products
FROM sales
GROUP BY product_line
ORDER BY no_of_products DESC
;

-- TOTAL REVENUE BY MONTH
SELECT
	ROW_NUMBER() OVER(ORDER BY ROUND(SUM(total), 2) DESC) AS ranking,
	month_name, 
    ROUND(SUM(total), 2) AS total_revenue
FROM sales
GROUP BY month_name
ORDER BY total_revenue DESC
;

-- MONTH WITH THE LARGEST COGS (COST OF GOODS SOLD)
SELECT 
	ROW_NUMBER() OVER w AS ranking, 
    month_name, 
    SUM(cogs) AS most_cogs_per_month
FROM sales
GROUP BY month_name
WINDOW w AS (ORDER BY SUM(cogs) DESC)
ORDER BY most_cogs_per_month DESC
;

-- PRODUCT LINE WITH THE MOST REVENUE
SELECT 
	ROW_NUMBER() OVER w AS ranking,
    product_line,
    ROUND(SUM(total), 2) AS total_revenue
FROM sales
GROUP BY product_line
WINDOW w AS (ORDER BY SUM(total) DESC)
ORDER BY total_revenue DESC
;

-- CITY WITH THE LARGEST REVENUE
SELECT 
	ROW_NUMBER() OVER w AS ranking,
    city,
    ROUND(SUM(total), 2) AS total_revenue
FROM sales
GROUP BY city
WINDOW w AS (ORDER BY SUM(total) DESC)
ORDER BY total_revenue DESC
;

-- PRODUCT LINE WITH THE LARGEST VAT
SELECT 
	ROW_NUMBER() OVER w AS ranking,
    product_line,
    ROUND(AVG(VAT), 2) AS avg_vat
FROM sales
GROUP BY product_line
WINDOW w AS (ORDER BY ROUND(AVG(VAT), 2) DESC)
ORDER BY avg_vat DESC
;

-- FETCHING EACH PRODUCT LINE AND ADDING A RATING COLUMN (GOOD IF IT IS ABOVE AVERAGE SALES)
SELECT 
	product_line,
    ROUND(AVG(total), 2) AS avg_sales,
    CASE
			WHEN ROUND(AVG(total), 2) > (SELECT ROUND(AVG(total), 2) FROM sales) THEN 'Good'
			ELSE 'Bad' END AS rating
FROM sales
GROUP BY product_line
;

-- BRANCH SOLD MORE PRODUCTS THAN THE AVERAGE PRODUCT SOLD
SELECT
		branch,
		SUM(quantity) AS quantity_sold,
        CASE
				WHEN SUM(quantity) > (SELECT (SUM(quantity) / COUNT(DISTINCT(branch))) FROM sales) THEN 'More than the average'
                WHEN SUM(quantity) < (SELECT (SUM(quantity) / COUNT(DISTINCT(branch))) FROM sales) THEN 'Less than the average'
                END AS classification
FROM sales
GROUP BY branch
;

-- MOST COMMON PRODUCT LINE BY GENDER
SELECT
		product_line,
        gender,
        COUNT(gender) AS no_products_gender
FROM sales
GROUP BY product_line, gender
ORDER BY no_products_gender DESC
;

-- AVERAGE RATING BY PRODUCT LINE
SELECT
		product_line,
        ROUND(AVG(rating), 2) AS avg_rating
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC
;


-- SALES QUESTIONS
-- NUMBER OF SALES MADE IN EACH TIME OF THE DAY PER WEEKDAY
SELECT time_of_the_day, day_name, month_name, COUNT(*) AS total_sales
FROM sales
WHERE day_name NOT IN('Saturday', 'Sunday')
GROUP BY time_of_the_day, day_name, month_name
ORDER BY total_sales DESC
;

-- CUSTOMER TYPE THAT BRINGS THE MOST REVENUE
SELECT 
		customer_type,
        ROUND(SUM(total), 2) AS total_revenue
FROM sales
GROUP BY customer_type
;

-- CITY WITH THE LARGEST TAX PERCENT/ VAT
SELECT
		city,
        AVG(VAT) AS VAT
FROM sales
GROUP BY city
ORDER BY VAT DESC
;

-- CUSTOMER TYPE THAT PAYS THE MOST IN VAT
SELECT
		customer_type,
        ROUND(AVG(VAT), 2) AS VAT
FROM sales
GROUP BY customer_type
ORDER BY VAT DESC
;


-- CUSTOMER QUESTIONS
-- UNIQUE CUSTOMER TYPE PRESENT
SELECT
		DISTINCT(customer_type)
FROM sales
;

-- UNIQUE PAYMENT METHODS PRESENT
SELECT
		DISTINCT(payment_method)
FROM sales
;

-- MOST COMMON CUSTOMER TYPE
SELECT
		COUNT(customer_type) AS no_of_types,
		customer_type
FROM sales
GROUP BY customer_type
ORDER BY no_of_types DESC
;

-- CUSTOMER TYPE THAT BUYS THE MOST
SELECT
		customer_type,
        ROUND(SUM(total), 2) AS total_purchases
FROM sales
GROUP BY customer_type
;
 
 -- MOST COMMON GENDER
 SELECT
		customer_type,
        gender,
        COUNT(gender) AS no_of_gender
 FROM sales
 GROUP BY customer_type, gender
 ORDER BY customer_type DESC, gender DESC
 ;
 
 -- GENDER DISTRIBUITION BY BRANCH
 SELECT
		branch,
        gender,
        COUNT(gender) AS no_of_gender
FROM sales
GROUP BY branch, gender
ORDER BY branch, gender DESC
;

-- TIME OF THE DAY WHEN CUSTOMER GIVES THE MOST RATING
SELECT
        time_of_the_day,
        AVG(rating) AS rating
FROM sales
GROUP BY time_of_the_day
ORDER BY rating DESC