/* 
Author     : Gurrala Madhu<gurralamadhu652@gmail.com>
Purpose    : Extracting the data from the database/dataset using mysql
start_Date : 15/04/2025
End_Date   : 16/04/2025
*/

## Step-1 : I have created a schema/Database online_sales
-- Here the dataset used is online sales in USA

create database if not exists online_sales;

## Note : 
-- IF NOT EXISTS Keyword:
-- It used to check whether the database exists are not 
-- If exists it throws a warning message instead of an error that database exists.

## Step-2 : Created a active session database using use keyword

USE online_sales;

## Note :
-- USE Keyword:
-- It is used to create a active session database.
-- While retrieving or creating a table if the database we want to retrieve/modify is not active session will throws an error that table/column does not exists 

## Step-3 : Loaded the dataset Online Sales USA into the database/schema online_sales using table data import wizard option.

## Step-4 : To display the data type of each column i have used the describe keyword

Describe sales;

## Note :
-- Describe keyword tells about the structure of columns including column names ,Data type of columns and Constraints.
 
 ## Step-5 : Changed the data type of columns using alter keyword
 
 alter table online_sales.sales
 change column order_date order_date date;
 
 select str_to_date (`Customer Since`,'%d/%m/%y') as `Customer Since` from sales;
## Note :
-- ALTER KEYWORD
-- ALTER Keyword is used to modify the definition of table and modify the defination of columns.
-- ALTER KEYWORD USE CASES 
-- RENAME the existing table
-- ADD a new column
-- DROP the existing columns
-- MODIFY the existing columns
-- To change the order of columns 

## Note : Here the column sku is stock keeping unit(sku),bi_st is Business intelligence status(bi_st) and SSN is social service number(SSN).

## Dropped the unwanted columns for analysis

alter table sales
drop column year, drop column month,drop column full_name,drop column `User Name`;

## Note :
-- Drop keyword is used to drop the tables/columns/database.

## Step-6 : Combined the multiple columns using concat function

ALTER TABLE sales
add column customer_name varchar(50) after order_date;
UPDATE sales 
SET 
    customer_name = CONCAT_WS(' ',
            `Name Prefix`,
            `Middle Initial`,
            `First Name`,
            `Last Name`);
 
 ## Note:
 -- There are two types of concat functions in sql.They are
 -- 1.concat(string/column,......)
 -- 2.concat_ws('seperator',string/column,....)
 -- Along with concat function there is another functiom called COALESCE
 -- COALESCE function will replace the null with an empty string ' ' .
 
 ## Note: 
 -- Update keyword is used to update the records ina table/column/row.
 
 -- Dropping unwanted columns after combining the columns
 
 Alter table sales
 drop  `Name Prefix`,
 drop  `Middle Initial`,
 drop  `First Name`,
 drop  `Last Name`;
 
 ## Step-7 : removing the duplicate values in every column
 
 select distinct * from sales;
 
 ## Step-8 : checking for sum of null values in each cloumn
 
 select 
 sum(case when order_id is null then 1 else 0 end) as order_id,
 sum(case when order_date is null then 1 else 0 end) as order_date,
 sum(case when customer_name is null then 1 else 0 end) as customer_name,
 sum(case when status is null then 1 else 0 end) as status,
 sum(case when item_id is null then 1 else 0 end) as item_id,
 sum(case when sku is null then 1 else 0 end) as sku,
 sum(case when qty_ordered is null then 1 else 0 end) as qty_ordered,
 sum(case when price is null then 1 else 0 end) as price,
 sum(case when value is null then 1 else 0 end) as value,
 sum(case when discount_amount is null then 1 else 0 end) as discount_amount,
 sum(case when total is null then 1 else 0 end) as total,
 sum(case when payment_method is null then 1 else 0 end) as payment_method,
 sum(case when category is null then 1 else 0 end) as category,
 sum(case when bi_st is null then 0 else 0 end) as bi_st,
 sum(case when cust_id is null then 1 else 0 end) as cust_id,
 sum(case when ref_num is null then 1 else 0 end) as ref_Num,
 sum(case when Gender is null then 1 else 0 end) as Gender,
 sum(case when age is null then 1 else 0 end) as age,
 sum(case when`E Mail` is null then 1 else 0 end) as `E Mail`,
 sum(case when `Customer Since` is null then 1 else 0 end) as `Customer Since`,
 sum(case when SSN is null then 1 else 0 end) as SSN,
 sum(case when `Phone No.` IS NULL THEN 1 ELSE 0 END) AS `Phone No.`,
 sum(case when `Place Name` is null then 1 else 0 end) as `Place Name`,
 sum(case when County is null then 1 else 0 end) as County,
 sum(case when City is null then 1 else 0 end) as City,
 sum(case when State is null then 1 else 0 end) as State,
 sum(CASE WHEN Zip is null then 1 else 0 end) AS Zip,
 sum(case when Region is null then 1 else 0 end) as Region,
 sum(case when Discount_Percent is null then 1 else 0 end) as Discount_Percent
 from sales;
 
 -- There are no null values in the dataset/database.

-- We can see there is no duplicate values/records in a table

## Retrieve the count of sales happened based on region wise and order the regions from top to bottom

SELECT 
    Region, COUNT(qty_ordered) AS Total_sales
FROM
    sales
GROUP BY Region
ORDER BY Total_sales DESC;

-- Here we can see the midwest region is the highest sales occuring region

## Retrieve the Month wise sales of regions

SELECT 
    monthname(order_date) AS Month,Region,
    COUNT(qty_ordered) AS Total_sales
FROM
    sales
    group by Month,Region
ORDER BY Total_sales DESC;

-- October is the highest sales happening month in the USA.

## Retrieve the status of orders and sales happened for each status

SELECT 
    status,Region,
    COUNT(order_id) AS Orders,
    COUNT(qty_ordered) AS Total_sales
FROM
    sales
GROUP BY status ,Region
ORDER BY orders desc, Total_sales desc;

-- Midwest is the region which has high orders delivered and cancelled for online sales.


## Retrive which category has highest sales and revenue

SELECT 
    category,
    COUNT(qty_ordered) AS Total_sales,
    SUM(total) AS Total_revenue
FROM
    sales
GROUP BY category
ORDER BY Total_sales DESC , Total_revenue DESC;

-- Men's Fashion is the highest revenue generated category.

## Retrieve the region which has discount amount highest 

SELECT 
    Region, SUM(total) AS revenue
FROM
    sales
GROUP BY region
ORDER BY revenue DESC
LIMIT 1;

-- Midwest is the region has highest revenue

## Retrieve which revenue,and sales generated by each state

SELECT 
    State, COUNT(qty_ordered) AS Sales, SUM(total) AS revenue
FROM
    sales
GROUP BY State
ORDER BY Sales DESC , revenue DESC;

## Retrieve city wise sales and revenue where state is OH,KS,AK,IL,CT,SD,MI,ND

SELECT 
    City, COUNT(qty_ordered) AS Sales, SUM(total) AS revenue
FROM
    sales
WHERE
    State IN ('OH' , 'KS', 'AK', 'IL', 'CT', 'SD', 'MI', 'ND')
GROUP BY City
ORDER BY Sales DESC , revenue DESC;

## Retrieve state,city,county average sales and revenue and give top 10 among them.

SELECT 
    County,
    State,
    City,
    AVG(qty_ordered) AS avg_sales,
    AVG(value) AS avg_revenue
FROM
    sales
GROUP BY County , State , City
ORDER BY avg_sales DESC , avg_revenue DESC;

## What are the count of payment methods used by different customers

SELECT 
    payment_method, COUNT(customer_name) AS Users
FROM
    sales
GROUP BY payment_method
ORDER BY Users DESC;

-- Cash on Delivery is the payment method mostly used by users.

## Retrieve the top 5 customers of getting high discoun amount

SELECT 
    customer_name, SUM(discount_amount) AS discount_amount
FROM
    sales
GROUP BY customer_name
ORDER BY discount_amount DESC
LIMIT 0 , 5;

## caluculate the sales and avg revenue geder wise 

SELECT 
    Gender, SUM(qty_ordered) AS sales, AVG(total) AS avg_revenue
FROM
    sales
GROUP BY Gender;

## Caluculate the revenue and sales for business intelligence unit where County is 'Bradford','Grand Forks','Hawaii'

SELECT 
    bi_st, SUM(qty_ordered) AS sales, SUM(total) AS revenue
FROM
    sales
    where County in ('Bradford','Grand Forks','Hawaii')
GROUP BY bi_st
ORDER BY sales DESC , revenue DESC;

-- Gross is business intelligence unit contributing more revenue through online sales in Counties 'Bradford','Grand Forks','Hawaii'.

## Retrive the max sales and max revenue collected day with name

SELECT 
    DAYNAME(order_date) AS `Day`,
    SUM(qty_ordered) AS sales,
    SUM(total) AS revenue
FROM
    sales
GROUP BY `Day`
ORDER BY sales DESC , revenue DESC
LIMIT 1;

-- ON overall THURSDAY is the day that has high sales happened and high revenue collected
    
## Calculate the year wise sales and revenue discount percent and amount

SELECT 
    YEAR(order_date) AS Year,
    SUM(qty_ordered) AS sales,
    SUM(total) AS revenue,
    AVG(Discount_Percent) AS discount_percent,
    SUM(discount_amount) AS discount_amount
FROM
    sales
GROUP BY Year;

## Retrive customer name,gender,age,highest sales happend by him,highest revenue generated by him, belongs to county,city,state,region

# USING JOINS
## SELF JOIN 
-- SELF JOIN is a join where a table joins with itself.

-- LETS make the table alias names as M1,M2

SELECT 
    customer_name,
    Gender,
    age,
    County,
    Region,
    State,
    City,
    SUM(qty_ordered) AS sales,
    SUM(total) AS revenue
FROM
    sales
GROUP BY customer_name , Gender , age , County , Region , State , City
ORDER BY sales DESC , revenue DESC
LIMIT 1;


## Retrieve which county ,state, city,region has highest orders  and revenue in the year 2020

SELECT 
    County,
    Region,
    State,
    City,
    SUM(qty_ordered) AS sales,
    SUM(total) AS revenue
FROM
    sales
WHERE
    YEAR(order_date) = '2020'
GROUP BY County , Region , State , City
ORDER BY sales DESC , revenue DESC
LIMIT 1;


