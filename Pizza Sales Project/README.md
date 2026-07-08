# 🍕 Pizza Sales Analysis using SQL

## Project Overview

This project explores a pizza sales dataset using SQL to uncover valuable business insights related to sales performance, customer purchasing behaviour, and product performance. The analysis focuses on identifying sales trends, evaluating key business metrics, and determining the best and worst-performing pizza products to support data-driven business decisions.

---

## Dataset Overview

The dataset was provided in a CSV file and contains **48,620** sales records. Each record represents an individual pizza sale and includes information such as:

- Pizza ID
- Order ID
- Quantity
- Order Date
- Order Time
- Unit Price
- Total Price
- Pizza Size
- Pizza Category
- Pizza Ingredients
- Pizza Name

📸 **Raw Pizza Sales Dataset**

![raw data 1](../SQL%20Projects%20Images/Pizza%20Sales%20Project%20Images/raw%20data%201.png)

![raw data 2](../SQL%20Projects%20Images/Pizza%20Sales%20Project%20Images/raw%20data%202.png)

---

## Project Objectives

The primary objectives of this project were to:

- Build a SQL database for storing the pizza sales dataset.
- Perform data cleaning and data transformation to ensure appropriate data types.
- Calculate important business Key Performance Indicators (KPIs).
- Analyse customer purchasing patterns and sales trends.
- Identify the best and worst-performing pizza products based on different business metrics.
- Generate actionable insights that can support business decision-making.

---

# Database Creation

The first step of the project was to create a database named **`pizzaDB`** and make it the default database before importing the pizza sales dataset.

```sql
-- Creating A Database
CREATE SCHEMA pizzaDB;

-- Making the Database the Default Database
USE pizzaDB;
```

After creating the database, the pizza sales dataset was imported into the **pizza_sales** table, which contains **48,620** transaction records.

---

# Data Cleaning & Data Transformation

Although most columns already had the correct data types, two fields required transformation before analysis could begin:

- `order_date`
- `order_time`

The **order_date** column was originally stored as **Text**. Since SQL requires dates to follow the standard **YYYY-MM-DD** format, the values were first converted using the **STR_TO_DATE()** function before changing the column's data type to **DATE**.

```sql
-- Transforming and Updating the "order_date" column
SELECT order_date,
       STR_TO_DATE(order_date,"%d-%m-%Y")
FROM pizza_sales;

UPDATE pizza_sales
SET order_date = STR_TO_DATE(order_date,"%d-%m-%Y");

-- Changing the data type
ALTER TABLE pizza_sales
MODIFY COLUMN order_date DATE NULL;
```

The **order_time** column was also converted from **Text** to the **TIME** data type to support time-based analysis.

```sql
ALTER TABLE pizza_sales
MODIFY COLUMN order_time TIME NULL;
```

📸 **Order Date and Order Time Data Transformation**

![date and time 1](../SQL%20Projects%20Images/Pizza%20Sales%20Project%20Images/date%20and%20time%201.png)

![date and time 2](../SQL%20Projects%20Images/Pizza%20Sales%20Project%20Images/date%20and%20time%202.png)



After completing these transformations, the dataset was ready for Exploratory Data Analysis (EDA).

# Exploratory Data Analysis (EDA)

After completing the data cleaning and transformation process, the dataset was ready for analysis.

The Exploratory Data Analysis (EDA) was divided into two sections:

- **Key Performance Indicators (KPIs)**
- **Business Trend Analysis**

This section focuses on the Key Performance Indicators used to measure the overall performance of the pizza business.

---

# Key Performance Indicators (KPIs)

## Total Revenue

The first KPI calculated was the **Total Revenue**, which represents the total amount generated from all pizza sales.

```sql
SELECT ROUND(SUM(total_price),2) AS Total_Revenue
FROM pizza_sales;
```

📸 **Total Revenue**

![Total Revenue](../SQL%20Projects%20Images/Pizza%20Sales%20Project%20Images/Total%20Revenue.png)

The analysis showed that the business generated a total revenue of **$817,860.05** during the analysis period.

---

## Average Order Value

The average amount spent per order was calculated by dividing the total revenue by the total number of unique orders.

```sql
SELECT ROUND(
       SUM(total_price) /
       COUNT(DISTINCT order_id),2
       ) AS Average_Order_Value
FROM pizza_sales;
```

📸 **Average Order Value**

![average order value](../SQL%20Projects%20Images/Pizza%20Sales%20Project%20Images/average%20order%20value.png)

Customers spent an average of **$38.31** per order.

---

## Total Pizzas Sold

The total number of pizzas sold was calculated by summing the **quantity** column.

```sql
SELECT SUM(quantity) AS Total_Pizzas_Sold
FROM pizza_sales;
```

📸 **Total Pizzas Sold**

![Total Pizzas](../SQL%20Projects%20Images/Pizza%20Sales%20Project%20Images/Total%20Pizzas.png)

A total of **49,574 pizzas** were sold during the period covered by the dataset.

To better understand the sales period, the minimum and maximum order dates, along with the number of unique operating days, were also examined.

```sql
SELECT MIN(order_date),
       MAX(order_date)
FROM pizza_sales;

SELECT COUNT(DISTINCT order_date)
FROM pizza_sales;
```
![order dates](../SQL%20Projects%20Images/Pizza%20Sales%20Project%20Images/order%20dates.png)

The analysis showed that sales occurred over **358 operating days**, resulting in an average of approximately **138 pizzas sold per day**.

---

## Total Orders Placed

The total number of customer orders was determined by counting the distinct order IDs.

```sql
SELECT COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales;
```

📸 **Total Orders**

![total orders](../SQL%20Projects%20Images/Pizza%20Sales%20Project%20Images/total%20orders.png)

The business processed **21,350** customer orders during the analysis period.

---

## Average Pizzas per Order

The average number of pizzas purchased per order was calculated by dividing the total number of pizzas sold by the total number of unique orders.

```sql
SELECT ROUND(
       SUM(quantity) /
       COUNT(DISTINCT order_id),2
       ) AS Average_Pizzas_Per_Order
FROM pizza_sales;
```

📸 **Average Pizzas per Order**

![average pizza](../SQL%20Projects%20Images/Pizza%20Sales%20Project%20Images/average%20pizza.png)

On average, customers purchased approximately **2.32 pizzas** per order, indicating that many customers bought more than one pizza during each transaction.

# Business Trend Analysis

The second section of the Exploratory Data Analysis focused on identifying sales patterns and customer purchasing behaviour over different periods. The analysis examined trends by day, month, hour, pizza category, and pizza size.

---

# Daily Trend of Total Orders

The **DAYNAME()** function was used to extract the weekday from each order date before counting the total number of unique orders.

```sql
SELECT DAYNAME(order_date) AS day_name,
       COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY DAYNAME(order_date)
ORDER BY Total_Orders DESC;
```

📸 **Daily Trend of Total Orders**

![daily trends](../SQL%20Projects%20Images/Pizza%20Sales%20Project%20Images/daily%20trends.png)

Friday recorded the highest number of customer orders, followed by Thursday and Saturday. This indicates that customer demand generally increased towards the end of the week.

---

# Monthly Trend of Total Orders

The **MONTHNAME()** function was used to group customer orders by month.

```sql
SELECT MONTHNAME(order_date) AS Month_Name,
       COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY MONTHNAME(order_date)
ORDER BY Total_Orders DESC;
```

📸 **Monthly Trend of Total Orders**

![mtrend](../SQL%20Projects%20Images/Pizza%20Sales%20Project%20Images/mtrend.png)


July recorded the highest number of orders, while October had the lowest. This suggests that customer demand varied throughout the year, with some months experiencing noticeably higher sales activity.

---

# Hourly Trend of Total Orders

The **HOUR()** function was used to determine how customer orders were distributed throughout the day.

```sql
SELECT HOUR(order_time) AS Hour,
       COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY Hour
ORDER BY Total_Orders DESC;
```

📸 **Hourly Trend of Total Orders**
![hourly trend](../SQL%20Projects%20Images/Pizza%20Sales%20Project%20Images/hourly%20trend.png)

Customer activity peaked around **12 PM** and **1 PM**, with another noticeable increase during the early evening hours. These periods represent the busiest sales hours for the business.

---

# Percentage of Sales by Pizza Category
The contribution of each pizza category to the overall revenue was calculated by dividing the revenue generated by each category by the total business revenue.

```sql
SELECT pizza_category,
       ROUND(
       (total_sales /
       (SELECT SUM(total_price)
       FROM pizza_sales))*100,2)
       AS Percentage_of_Sales
FROM
(
SELECT pizza_category,
       SUM(total_price) AS Total_Sales
FROM pizza_sales
GROUP BY pizza_category
) a
ORDER BY Percentage_of_Sales DESC;
```

📸 **Percentage of Sales by Pizza Category**
![pizza category](../SQL%20Projects%20Images/Pizza%20Sales%20Project%20Images/pizza%20category.png)

The **Classic** pizza category contributed the largest share of total revenue, followed by **Supreme**, while **Veggie** generated the smallest revenue contribution.

---

# Percentage of Sales by Pizza Size

The percentage contribution of each pizza size to total revenue was also analysed.

```sql
SELECT pizza_size,
       ROUND(
       (SUM(total_price) /
       (SELECT SUM(total_price)
       FROM pizza_sales))*100,2)
       AS Percentage_of_Sales
FROM pizza_sales
GROUP BY pizza_size
ORDER BY Percentage_of_Sales DESC;
```

📸 **Percentage of Sales by Pizza Size**

![pizza size](../SQL%20Projects%20Images/Pizza%20Sales%20Project%20Images/pizza%20size.png)


Large-sized pizzas generated the highest share of revenue, followed by Medium and Small pizzas. Extra-Large and Extra-Extra-Large pizzas contributed only a small percentage of total sales.

---

# Total Pizzas Sold by Pizza Category

The total number of pizzas sold was calculated for each pizza category by summing the quantity purchased.

```sql
SELECT pizza_category,
       SUM(quantity) AS Total_Sales
FROM pizza_sales
GROUP BY pizza_category
ORDER BY Total_Sales DESC;
```

📸 **Total Pizzas Sold by Pizza Category**

![pizza category sales](../SQL%20Projects%20Images/Pizza%20Sales%20Project%20Images/pizza%20category%20sales.png)

The **Classic** category recorded the highest number of pizzas sold, while the **Chicken** category had the lowest sales volume. This reinforces the strong performance of the Classic category throughout the analysis.

# Product Performance Analysis

To identify the best and worst-performing products, the analysis compared pizza types using three important business metrics:

- Total Revenue
- Total Quantity Sold
- Total Orders

These analyses help identify which products contribute the most to business performance and which products may require further attention.

---

# Top 5 and Bottom 5 Pizzas by Total Revenue

The following queries were used to identify the pizzas that generated the highest and lowest revenue.

### Top 5 Pizzas by Revenue

```sql
SELECT pizza_name,
       SUM(total_price) AS Total_Revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Revenue DESC
LIMIT 5;
```

📸 **Top 5 Pizzas by Revenue**

![top total revenue](../SQL%20Projects%20Images/Pizza%20Sales%20Project%20Images/top%20total%20revenue.png)

The **Thai Chicken Pizza** generated the highest revenue, followed closely by the **Barbecue Chicken Pizza** and the **California Chicken Pizza**.

---

### Bottom 5 Pizzas by Revenue

```sql
SELECT pizza_name,
       ROUND(SUM(total_price),2) AS Total_Revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Revenue
LIMIT 5;
```

📸 **Bottom 5 Pizzas by Revenue**

![bottom total revenue](../SQL%20Projects%20Images/Pizza%20Sales%20Project%20Images/bottom%20total%20revenue.png)

The **Brie Carre Pizza** generated the lowest revenue among all pizza types.

---

# Top 5 and Bottom 5 Pizzas by Quantity Sold

The next analysis compared pizza performance based on the total quantity sold.

### Top 5 Pizzas by Quantity

```sql
SELECT pizza_name,
       SUM(quantity) AS Total_Quantity
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Quantity DESC
LIMIT 5;
```

📸 **Top 5 Pizzas by Quantity**

![top quantity](../SQL%20Projects%20Images/Pizza%20Sales%20Project%20Images/top%20quantity.png)

The **Classic Deluxe Pizza** sold the highest number of pizzas, followed by the **Barbecue Chicken Pizza** and the **Hawaiian Pizza**.

---

### Bottom 5 Pizzas by Quantity

```sql
SELECT pizza_name,
       SUM(quantity) AS Total_Quantity
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Quantity
LIMIT 5;
```

📸 **Bottom 5 Pizzas by Quantity**

![bottom quantity](../SQL%20Projects%20Images/Pizza%20Sales%20Project%20Images/bottom%20quantity.png)

The **Brie Carre Pizza** recorded the lowest quantity sold during the analysis period.

---

# Top 5 and Bottom 5 Pizzas by Total Orders

Finally, pizza performance was analysed based on the number of customer orders.

### Top 5 Pizzas by Orders

```sql
SELECT pizza_name,
       COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Orders DESC
LIMIT 5;
```

📸 **Top 5 Pizzas by Orders**

![Best Orders](../SQL%20Projects%20Images/Pizza%20Sales%20Project%20Images/Best%20Orders.png)

The **Classic Deluxe Pizza** appeared in the highest number of customer orders, demonstrating strong and consistent customer demand.

---

### Bottom 5 Pizzas by Orders

```sql
SELECT pizza_name,
       COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Orders
LIMIT 5;
```

📸 **Bottom 5 Pizzas by Orders**

![Worst Orders](../SQL%20Projects%20Images/Pizza%20Sales%20Project%20Images/Worst%20Orders.png)

The **Brie Carre Pizza** appeared in the fewest customer orders, making it the least frequently purchased pizza in the dataset.

---

### Overall Observation

Across all three analyses, several pizza types consistently ranked among the best performers, including the **Classic Deluxe Pizza**, **Barbecue Chicken Pizza**, **Hawaiian Pizza**, and **Thai Chicken Pizza**.

Similarly, pizzas such as the **Brie Carre Pizza**, **Mediterranean Pizza**, and **Spinach Supreme Pizza** frequently appeared among the lowest-performing products. These results provide valuable insights into customer preferences and can help guide future product promotion and inventory planning.

# Key Findings

The analysis revealed several important insights into customer purchasing behaviour and product performance.

- The business generated a total revenue of **$817,860.05** from **21,350** customer orders.
- Customers spent an average of **$38.31** per order and purchased approximately **2.32 pizzas** per transaction.
- A total of **49,574 pizzas** were sold across **358 operating days**, averaging about **138 pizzas sold per day**.
- **Friday** recorded the highest number of customer orders, while **July** was the busiest month.
- Customer activity peaked around **12 PM–1 PM**, with another noticeable increase during the early evening hours.
- The **Classic** pizza category contributed the highest percentage of total revenue and also recorded the highest sales volume.
- **Large-sized** pizzas generated the largest share of total revenue.
- The **Classic Deluxe Pizza**, **Barbecue Chicken Pizza**, and **Thai Chicken Pizza** consistently ranked among the best-performing products across multiple performance metrics.
- The **Brie Carre Pizza** consistently appeared among the lowest-performing pizzas in terms of revenue, quantity sold, and total orders.

---

# SQL Concepts Demonstrated

This project demonstrates the practical application of several SQL concepts commonly used in data analysis.

### Database Management

- CREATE SCHEMA
- USE

### Data Cleaning & Data Transformation

- UPDATE
- ALTER TABLE
- MODIFY COLUMN
- STR_TO_DATE()

### Aggregate Functions

- SUM()
- COUNT()
- ROUND()
- MIN()
- MAX()

### Date & Time Functions

- STR_TO_DATE()
- DAYNAME()
- MONTHNAME()
- HOUR()

### Data Filtering & Grouping

- GROUP BY
- ORDER BY
- DISTINCT
- LIMIT

### Subqueries

```sql
SELECT pizza_category,
       ROUND(
       (total_sales /
       (SELECT SUM(total_price)
        FROM pizza_sales))*100,2)
FROM
(
SELECT pizza_category,
       SUM(total_price) AS total_sales
FROM pizza_sales
GROUP BY pizza_category
)a;
```

---

# Business Recommendations

Based on the analysis, the following recommendations could help improve business performance:

- Continue promoting the **Classic** pizza category since it consistently generated the highest sales and revenue.
- Maintain adequate inventory for **Large-sized** pizzas because they contribute the highest percentage of revenue.
- Schedule sufficient staff and inventory during **Fridays**, **lunchtime (12 PM–1 PM)**, and the **early evening** to meet periods of peak customer demand.
- Increase marketing efforts for consistently high-performing pizzas such as the **Classic Deluxe Pizza**, **Thai Chicken Pizza**, and **Barbecue Chicken Pizza**.
- Review the pricing, recipe, or promotional strategy for consistently low-performing pizzas like the **Brie Carre Pizza** before considering removing them from the menu.

---

# Conclusion

This project demonstrated how SQL can be used to transform raw transactional data into meaningful business insights.

Starting with database creation and data transformation, the project progressed into a comprehensive exploratory analysis that examined sales performance, customer purchasing patterns, product performance, and business trends.

The insights generated from this analysis can support better inventory planning, marketing decisions, staffing strategies, and product management, ultimately helping the business make more informed, data-driven decisions.

---

🍕📊💾