-- Data Wrangling 
-- Creating a Database  
create schema salesdatawalmart;

-- Making the database a default database 
use salesdatawalmart;

-- Creating the "sales" table 
create table sales(invoice_id varchar(30) not null unique,branch varchar(5) not null,city varchar(30) not null,customer_type varchar(30)not null,
gender varchar(10) not null,product_line varchar(100) not null, unit_price decimal(10,2) not null, 
quantity int not null, VAT float(6,4) not null, total decimal(12,4) not null, date datetime not null,time time not null,
payment_method varchar(15) not null, cogs decimal(10,2) not null, gross_margin_percentage float(11,9), gross_income decimal(12,4) not null,
rating float(2,1));
select * from sales;

-- Feature Engineering
-- Adding a new column "time_of_day" to the "sales" table  
alter table sales add column time_of_day varchar(50) not null;

-- Populating the "time_of_day" column 
select case when hour(time)<12 then "Morning" when hour(time) between 12 and 16 then "Afternoon" else "Evening" end as time_of_day from sales;
update sales set time_of_day=case when hour(time)<12 then "Morning" when time between "12:00:00" and "16:00:00" then "Afternoon" 
else "Evening" end;

-- Adding a new column "day_name" to the sales table
alter table sales add column day_name varchar(50);
-- Populating the "day_name" column 
select date,dayname(date) from sales;
update sales set day_name=dayname(date);

-- Adding a new column "month_name" to the "sales" table 
alter table sales add column month_name varchar(50);
-- Populating the "month_name" column  
select date,monthname(date) from sales;
update sales set month_name=monthname(date);


-- Exploratory Data Analysis (EDA) 
-- Generic questions
-- How many unique cities does the data have?
select distinct city from sales;  

-- In which city is each branch?
select city,branch from sales group by city,branch;

-- Product-related Questions
-- How many unique product lines does the data have?
select * from sales;
select distinct product_line from sales;

-- What is the most common payment method?
select payment_method,count(*) payment_methods_count from sales group by payment_method order by 2 desc;

-- What is the most selling product line? 
select product_line,count(*) sales_count from sales group by product_line order by 2 desc;

-- What is the total revenue by month?
select month(date) Month, monthname(date) Monthname,sum(total) total_revenue from sales group by month(date),monthname(date) order by 3 desc;

-- Which month had the largest COGS?
select month_name,sum(cogs) COGS from sales group by month_name order by 2 desc;

-- What product line had the largest revenue?
select product_line,sum(total) revenue_by_product_line from sales group by product_line order by 2 desc limit 1;

-- What is the city with the largest revenue?
select * from sales;
select city,sum(total) total_revenue from sales group by city order by total_revenue desc limit 1;

-- What product line had the largest VAT?
select product_line,sum(vat) VAT_by_product from sales group by product_line order by 2 desc;

-- Fetch each product line and add a column to those product lines showing "Good", "Bad". "Good" if its greater than average sales 
select avg(total) average_revenue from sales;
with product_line_remark_cte as 
(select product_line,avg(total) avg_total_sales from sales group by product_line)
select *,case when avg_total_sales>(select avg(total) from sales) then "Good" else "Bad" end product_line_remarks from product_line_remark_cte 
order by 2 desc;

-- Which branch sold more products than average product sold?
select * from sales;
select avg(quantity) average_quantity_sold from sales;
select * from 
(select branch,avg(quantity) average_quantity_by_branch from sales group by branch)a where average_quantity_by_branch>
(select avg(quantity) from sales);

-- What is the most common product line by gender?
select gender,product_line,count from 
(select gender,product_line,count(*) `count`,rank()over(partition by gender order by count(*) desc) rnk from sales group by gender,
product_line order by gender,count desc)a where rnk=1;

-- What is the average rating of each product line? 
select product_line,round(avg(rating),2) average_rating from sales group by product_line order by 2 desc;

-- Sales-related Questions
select * from sales;

-- Number of sales made in each time of the day per weekday
select day_name,time_of_day,count(*) total_sales from sales group by day_name,time_of_day order by 1,3 desc;

-- Which of the customer types brings the most revenue?
select customer_type,sum(total) total_revenue from sales group by customer_type order by 2 desc;

-- Which city has the largest VAT?
select city,sum(VAT) total_VAT from sales group by city order by total_vat desc limit 1;

-- Which customer type pays the most in VAT?
 select customer_type,sum(vat) total_VAT from sales group by customer_type order by total_VAT desc;
 
 -- Customer-related Questions
 select * from sales;
 
 -- How many unique customer types does the data have?
 select count(distinct customer_type) unique_customer_types from sales;
 
 -- How many unique payment methods does the data have? 
 select count(distinct payment_method) unique_payment_methods from sales;
 
 -- What is the most common customer type?
 select customer_type,count(*) customer_type_count from sales group by customer_type order by 2 desc;
 
 -- Which customer type buys the most?
 select customer_type,count(*) total_sales from sales group by customer_type order by 2 desc limit 1;
 
 -- What is the gender of most of the customers? 
 select gender,count(*) gender_count from sales group by gender order by gender desc;
 
 -- What is the gender distribution per branch?
select branch,gender,count(*) gender_count from sales group by branch,gender order by 1,3 desc;
 
  -- What time of day do customers give most ratings?
select time_of_day,count(rating) rating_count from 
(select time_of_day,rating from sales)a group by time_of_day order by rating_count desc;
 
 -- What time of day do customers give most ratings per branch?
 select branch,time_of_day,count(rating) rating_count from sales group by branch,time_of_day order by 1,3 desc;
 
 -- Which day of the week has the best avg ratings?
 select day_name,avg(rating) average_rating from sales group by day_name order by 2 desc;
 
 -- Which day of the week has the best average ratings per branch?
 select branch,day_name,avg(rating) average_rating from sales group by branch,day_name order by 1,3 desc;
 
 -- End of Project 
 
 
 
 
 


