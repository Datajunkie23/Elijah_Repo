-- Creating A Database 
create schema pizzaDB;

-- Making the Database the Default Database 
use pizzadb;
select * from pizza_sales;

-- Data Cleaning and Data Transformation

-- Transforming and Updating the "order_date" column from "Text" to "Date"
select order_date,str_to_date(order_date,"%d-%m-%Y") from pizza_sales;
update pizza_sales set order_date=str_to_date(order_date,"%d-%m-%Y");

-- Changing the data type of the "order_date" column 
alter table pizza_sales modify column order_date date null;

-- Changing the data type of the "order_time" column from "Text" to "Time" 
alter table pizza_sales modify column order_time time null;

-- Exploratory Data Analysis (EDA)
# Key Performance Indicators (KPI's)
# Chart Requirements 

-- Key Performance Indicators
-- Total Revenue
select round(sum(total_price),2) Total_Revenue from pizza_sales; 

-- Average Order value/amount
select round(sum(total_price)/count(distinct order_id),2)  Average_order_value  from pizza_sales;

-- Total Pizzas Sold
select sum(quantity) Total_Pizzas_sold from pizza_sales;

-- Extra queries
select min(order_date),max(order_date) from pizza_sales;
select count(distinct order_date) from pizza_sales;

-- Total Orders Placed
select count(distinct order_id) Total_orders from pizza_sales; 

-- Average Pizzas per order
select round(sum(quantity)/count(distinct order_id),2)  Average_pizzas_per_order from pizza_sales;

--  Chart Requirements 
-- Daily Trend of Total Orders
select dayname(order_date) day_name,count(distinct order_id) Total_orders from pizza_sales group by dayname(order_date) order by 
total_orders desc;

-- Monthly Trend of Total Orders
select monthname(order_date) monthname,count(distinct order_id) Total_orders from pizza_sales group by monthname(order_date) order by 2 desc;

-- Hourly Trend of Total Orders 
select hour(order_time) `time`,count(distinct order_id) Total_orders from pizza_sales  group by time order by 2 desc;

-- Percentage of sales by Pizza Category
select pizza_category,round((total_sales/(select sum(total_price) from pizza_sales))*100,2) Percentage_of_sales from 
(select pizza_category,sum(total_price) Total_sales from pizza_sales  group by pizza_category)a order by percentage_of_sales desc;

-- Extra Queries
select * from pizza_sales;
select distinct pizza_size from pizza_sales;

-- Percentage of sales by pizza size
select pizza_size,round((sum(total_price)/(select sum(total_price) from pizza_sales))*100,2) Percentage_of_sales from pizza_sales
group by pizza_size order by percentage_of_sales desc;

-- Total Pizzas sold by pizza category 
select pizza_category, sum(quantity) Total_sales from pizza_sales group by pizza_category order by 2 desc;

-- Extra Queries  
select  * from pizza_sales;
select distinct pizza_category from pizza_sales;
select distinct pizza_name from pizza_sales;
select distinct pizza_name from pizza_sales where pizza_category="classic";
select distinct pizza_name from pizza_sales where pizza_category="veggie";
select distinct pizza_name from pizza_sales where pizza_category="supreme";
select distinct pizza_name from pizza_sales where pizza_category="chicken";

-- Top 5 best sellers by Total Revenue
select pizza_name,sum(total_price) Total_revenue from pizza_sales group by pizza_name order by total_revenue desc limit 5;

-- Bottom 5 pizzas by Total Revenue
select pizza_name,round(sum(total_price),2) Total_Revenue from pizza_sales group by pizza_name order by 2 asc limit 5;

-- Top 5 best sellers by Total Quantity
select pizza_name,sum(quantity) Total_quantity from pizza_sales group by pizza_name order by total_quantity desc limit 5;

-- Bottom 5 Pizzas by Total Quantity
select pizza_name,sum(quantity) Total_quantity from pizza_sales group by pizza_name order by total_quantity asc limit 5;

-- Top 5 best sellers by Total Orders
select pizza_name,count(distinct order_id) Total_orders from pizza_sales group by pizza_name order by total_orders desc limit 5;

-- Bottom 5 Pizzas by Total Orders
select pizza_name,count(distinct order_id) Total_orders from pizza_sales group by pizza_name order by total_orders asc limit 5;

-- End of project
 
