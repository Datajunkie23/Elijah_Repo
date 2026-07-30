# 🛒 Walmart Sales Analysis Using SQL

## Project Overview

This project explores Walmart sales data to understand branch performance, product performance, customer behaviour, and sales trends. The goal of the analysis is to identify insights that can help improve business decision-making, optimize sales strategies, and better understand customer purchasing patterns.

The project focuses on answering business questions related to:

- Branch performance
- Product performance
- Revenue generation
- Customer behaviour
- Payment preferences
- Sales trends

---

## 📥 Downloading Project Files

You can download individual files from a specific project folder or download the entire repository containing all available project folders.

### 🔹 Downloading an Individual Project File

To download a specific file from a project folder:

1. Open the project folder you are interested in (e.g., `Bank Loan Project`).
2. Click on the specific file you want to download within the project folder (e.g., `Bank Loan Analysis Project.sql` or `financial_loan.csv`).
3. Click the **three-dot menu (`⋯`)** in the top-right corner and select **Download**.
4. Once the download is complete, open the downloaded file on your device to explore the SQL script, dataset, or other project material.

### 🔹 Downloading the Entire Repository

To download all project folders and files contained within the entire repository:

1. If you are currently viewing a specific project folder (e.g., `Bank Loan Project`), navigate back to the main repository page by clicking the repository name or going one level back.
2. Once you are on the main repository page (e.g., `SQL-Projects`), click the **Code** button.
3. Select **Download ZIP** from the dropdown menu.
4. Once the download is complete, locate the ZIP file on your device and extract it.
5. After extraction, you will have access to all the project folders and files contained within the repository.

> **Note:** The **Download ZIP** option downloads the entire repository, not just one individual project folder.


## Purpose of the Project

The primary objective of this project is to gain insights into Walmart's sales data and understand the various factors that influence sales performance across different branches.

By analysing sales transactions, customer behaviour, product performance, and revenue trends, businesses can make more informed decisions regarding product offerings, marketing strategies, customer engagement, and operational efficiency.

---
## Dataset Overview

The dataset used for this project was provided as a CSV file containing Walmart sales transactions.

The dataset contains information such as:

- Invoice ID
- Branch
- City
- Customer Type
- Gender
- Product Line
- Unit Price
- Quantity
- VAT
- Total Sales
- Date
- Time
- Payment Method
- Cost of Goods Sold (COGS)
- Gross Income
- Rating

The dataset contains **1,000 sales records** across three Walmart branches located in different cities within Myanmar.

### Raw Dataset

![Raw Dataset](../SQL%20Projects%20Images/Walmart%20Sales%20Analysis%20Images/Raw%20Dataset.png)

---

## Project Structure

The project was divided into three major phases:

1. Data Wrangling
2. Feature Engineering
3. Exploratory Data Analysis (EDA)

---

# Data Wrangling

Data wrangling was the first stage of the project.

The objective of this phase was to create the database structure required for the analysis and ensure that the imported data complied with the project requirements.

---

## Creating the Database

A database named **salesdatawalmart** was created to store the Walmart sales dataset.

To simplify query execution, the database was set as the default database using the `USE` statement.

### SQL Query

```sql
CREATE SCHEMA salesdatawalmart;

USE salesdatawalmart;
```

---

## Creating the Sales Table

A table named **sales** was created to store the Walmart sales records.

The project brief specified that the table should not contain null values. To enforce this requirement, the `NOT NULL` constraint was applied to the relevant columns during table creation.

Additionally, the `Invoice_ID` column was assigned a `UNIQUE` constraint to ensure that duplicate invoice records could not exist within the dataset.

### SQL Query

```sql
CREATE TABLE sales(
    invoice_id VARCHAR(30) NOT NULL UNIQUE,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    VAT FLOAT(6,4) NOT NULL,
    total DECIMAL(12,4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment_method VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_percentage FLOAT(11,9),
    gross_income DECIMAL(12,4) NOT NULL,
    rating FLOAT(2,1)
);
```

By enforcing these constraints during table creation, records with missing values were prevented from being imported into the database.

This ensured that the dataset was suitable for further analysis without requiring extensive data cleaning operations.

---

# Feature Engineering

Feature engineering was the second phase of the project.

The objective of this phase was to create additional fields that would make the dataset more useful for analysis. Rather than repeatedly performing calculations during the analysis stage, new columns were added to the dataset and populated using existing information in the table.

Three new columns were created:

- time_of_day
- day_name
- month_name

These newly created columns were later used extensively throughout the Exploratory Data Analysis (EDA) phase of the project.

---

## Creating the Time of Day Column

The first feature created was the **time_of_day** column.

This column was designed to categorize each transaction into one of three periods of the day:

- Morning
- Afternoon
- Evening

The categorization was achieved using a SQL `CASE` statement together with the existing `time` column.

### SQL Query

```sql
ALTER TABLE sales
ADD COLUMN time_of_day VARCHAR(50) NOT NULL;
```

### Populating the Column

```sql
UPDATE sales
SET time_of_day =
CASE
    WHEN HOUR(time) < 12 THEN 'Morning'
    WHEN time BETWEEN '12:00:00' AND '16:00:00' THEN 'Afternoon'
    ELSE 'Evening'
END;
```

###

![time-of-day](../SQL%20Projects%20Images/Walmart%20Sales%20Analysis%20Images/time-of-day.png)

The creation of this column made it easier to analyse customer behaviour and sales activity during different periods of the day.

---

## Creating the Day Name Column

The second feature created was the **day_name** column.

The objective of this column was to identify the day of the week associated with each transaction.

Instead of repeatedly calculating the day name during analysis, the values were generated once and stored directly in the table.

### SQL Query

```sql
ALTER TABLE sales
ADD COLUMN day_name VARCHAR(50);
```

### Populating the Column

```sql
UPDATE sales
SET day_name = DAYNAME(date);
```

### Query Result

![dayname](../SQL%20Projects%20Images/Walmart%20Sales%20Analysis%20Images/dayname.png)

This feature later made it possible to analyse customer activity, ratings, and sales performance across different days of the week.

---

## Creating the Month Name Column

The final feature created during this phase was the **month_name** column.

The purpose of this column was to extract the month from the transaction date and store it directly in the dataset.

### SQL Query

```sql
ALTER TABLE sales
ADD COLUMN month_name VARCHAR(50);
```

### Populating the Column

```sql
UPDATE sales
SET month_name = MONTHNAME(date);
```

### Query Result

![monthname](../SQL%20Projects%20Images/Walmart%20Sales%20Analysis%20Images/monthname.png)

This feature was particularly useful when analysing revenue trends and cost of goods sold (COGS) across different months.

---

# Exploratory Data Analysis (EDA)

After completing the data wrangling and feature engineering stages, the dataset was ready for analysis.

The Exploratory Data Analysis phase was divided into four sections:

- Generic Questions
- Product-Related Questions
- Sales-Related Questions
- Customer-Related Questions

The objective of this phase was to uncover patterns, trends, and insights that could help Walmart better understand its customers, products, and branch performance.

---

## Generic Questions

The first section of the analysis focused on understanding the basic structure of the dataset before moving into more detailed business questions.

### How Many Unique Cities Does the Dataset Contain?

The first question was to determine how many unique cities were represented in the dataset.

### SQL Query

```sql
SELECT DISTINCT city
FROM sales;
```

### Query Result

![city](../SQL%20Projects%20Images/Walmart%20Sales%20Analysis%20Images/city.png)

### Insight

The dataset contains three unique cities:

- Yangon
- Mandalay
- Naypyitaw

Further research showed that all three cities are located in Myanmar, indicating that the analysis focuses on Walmart branch performance within different regions of the same country.

---

### In Which City Is Each Branch Located?

The next question was to identify the city associated with each Walmart branch.

### SQL Query

```sql
SELECT city, branch
FROM sales
GROUP BY city, branch;
```

### Query Result

![city and branches](../SQL%20Projects%20Images/Walmart%20Sales%20Analysis%20Images/city%20and%20branches.png)

### Insight

The analysis revealed the following branch distribution:

| Branch | City |
|----------|----------|
| A | Yangon |
| B | Mandalay |
| C | Naypyitaw |

Having branches spread across different cities allows the business to serve a wider customer base and establish a stronger market presence across multiple regions.

# Product-Related Questions

The next section of the analysis focused on product performance, customer purchasing preferences, revenue generation, and product profitability.

The objective was to identify the products that generated the most sales, the products that generated the most revenue, and the factors contributing to overall business performance.

---

## How Many Unique Product Lines Does the Business Have?

The first question in this section was to determine the number of unique product lines available in the dataset.

### SQL Query

```sql
SELECT DISTINCT product_line
FROM sales;
```

### Query Result

![product lines](../SQL%20Projects%20Images/Walmart%20Sales%20Analysis%20Images/product%20lines.png)

### Insight

The dataset contains six unique product lines:

- Food and Beverages
- Health and Beauty
- Sports and Travel
- Fashion Accessories
- Home and Lifestyle
- Electronic Accessories

This indicates that Walmart serves customers across multiple product categories rather than focusing on a single product segment.

---

## What Is the Most Common Payment Method?

The next question was to determine the payment method most frequently used by customers.

### SQL Query

```sql
SELECT payment_method,
       COUNT(*) payment_methods_count
FROM sales
GROUP BY payment_method
ORDER BY 2 DESC;
```

### Query Result

![payment method](../SQL%20Projects%20Images/Walmart%20Sales%20Analysis%20Images/payment%20method.png)

### Insight

The analysis revealed that:

1. Cash was the most frequently used payment method.
2. E-wallet ranked second.
3. Credit cards were the least used payment method.

This suggests that customers preferred making direct payments rather than relying heavily on credit-based transactions.

---

## What Is the Most Selling Product Line?

The next objective was to identify the product line with the highest number of sales transactions.

### SQL Query

```sql
SELECT product_line,
       COUNT(*) sales_count
FROM sales
GROUP BY product_line
ORDER BY 2 DESC;
```

### Query Result
![popular product line](../SQL%20Projects%20Images/Walmart%20Sales%20Analysis%20Images/popular%20product%20line.png)


### Insight

The analysis showed the following ranking:

| Product Line | Sales Count |
|--------------|------------|
| Fashion Accessories | 178 |
| Food and Beverages | 174 |
| Electronic Accessories | 169 |
| Sports and Travel | 163 |
| Home and Lifestyle | 160 |
| Health and Beauty | 151 |

Fashion Accessories recorded the highest sales count, slightly outperforming Food and Beverages.

Interestingly, although Food and Beverages are generally considered essential products, customers purchased Fashion Accessories more frequently during the period covered by the dataset.

---

## What Is the Total Revenue by Month?

The next analysis focused on identifying revenue trends across different months.

### SQL Query

```sql
SELECT MONTH(date) Month,
       MONTHNAME(date) Monthname,
       SUM(total) total_revenue
FROM sales
GROUP BY MONTH(date), MONTHNAME(date)
ORDER BY 3 DESC;
```

### Query Result

![total revenue](../SQL%20Projects%20Images/Walmart%20Sales%20Analysis%20Images/total%20revenue.png)

### Insight

The monthly revenue generated was:

| Month | Revenue |
|--------|----------|
| January | 116,291.8680 |
| March | 108,867.1500 |
| February | 95,727.3765 |

January generated the highest revenue while February generated the lowest revenue.

This result was particularly interesting because one might expect February to perform strongly due to Valentine's season. However, the data suggests that January was the strongest revenue-generating month during the period covered by the dataset.

---

## Which Month Had the Largest Cost of Goods Sold (COGS)?

The next analysis focused on identifying the month with the highest Cost of Goods Sold (COGS).

### SQL Query

```sql
SELECT month_name,
       SUM(cogs) COGS
FROM sales
GROUP BY month_name
ORDER BY 2 DESC;
```

### Query Result

![largest cogs](../SQL%20Projects%20Images/Walmart%20Sales%20Analysis%20Images/largest%20cogs.png)

### Insight

The analysis revealed:

| Month | COGS |
|--------|----------|
| January | 110,754.16 |
| March | 103,683.00 |
| February | 91,168.93 |

January recorded the highest Cost of Goods Sold.

This result aligns closely with the revenue analysis since higher sales volumes often lead to higher production and inventory costs.

A strong relationship can therefore be observed between revenue generation and Cost of Goods Sold throughout the dataset.


## What Product Line Generated the Largest Revenue?

The next objective was to identify the product line that generated the highest revenue for the business.

### SQL Query

```sql
SELECT product_line,
       SUM(total) revenue_by_product_line
FROM sales
GROUP BY product_line
ORDER BY 2 DESC
LIMIT 1;
```

### Query Result

![product line revenue](../SQL%20Projects%20Images/Walmart%20Sales%20Analysis%20Images/product%20line%20revenue.png)

### Insight

The analysis revealed that **Food and Beverages** generated the highest revenue among all product lines.

Interestingly, although **Fashion Accessories** recorded the highest sales count, it was **Food and Beverages** that generated the most revenue.

This shows that the most frequently purchased product category is not necessarily the category that generates the highest revenue. Factors such as product pricing and transaction values play a significant role in overall revenue generation.

---

## Which City Generated the Largest Revenue?

The next analysis focused on determining which city contributed the most revenue to the business.

### SQL Query

```sql
SELECT city,
       SUM(total) total_revenue
FROM sales
GROUP BY city
ORDER BY total_revenue DESC
LIMIT 1;
```

### Query Result

![city revenue](../SQL%20Projects%20Images/Walmart%20Sales%20Analysis%20Images/city%20revenue.png)

### Insight

The city with the highest revenue was:

| City | Revenue |
|--------|----------|
| Naypyitaw | 110,490.7755 |

This suggests that the branch located in Naypyitaw was the strongest revenue-generating branch during the period covered by the dataset.

The result indicates strong customer demand and purchasing activity within that city.

---

## What Product Line Generated the Highest VAT?

The next analysis focused on identifying the product line that contributed the highest amount of Value Added Tax (VAT).

### SQL Query

```sql
SELECT product_line,
       SUM(vat) VAT_by_product
FROM sales
GROUP BY product_line
ORDER BY 2 DESC;
```

### Query Result

![product line vat](../SQL%20Projects%20Images/Walmart%20Sales%20Analysis%20Images/product%20line%20vat.png)

### Insight

The analysis showed that **Food and Beverages** generated the highest VAT contribution.

This result aligns closely with the revenue analysis because VAT is directly related to the value of products sold.

As revenue increases, the amount of VAT collected also increases.

This further confirms the strong financial performance of the Food and Beverages category.

---

## Product Line Performance Classification (Good vs Bad)

The next analysis aimed to classify product lines based on their average sales performance.

The objective was to determine whether each product line performed above or below the overall average sales value of the business.

A Common Table Expression (CTE) was used to calculate the average sales for each product line before comparing those values against the overall business average.

### SQL Query

```sql
WITH product_line_remark_cte AS
(
    SELECT product_line,
           AVG(total) avg_total_sales
    FROM sales
    GROUP BY product_line
)

SELECT *,
       CASE
           WHEN avg_total_sales >
                (SELECT AVG(total) FROM sales)
           THEN 'Good'
           ELSE 'Bad'
       END product_line_remarks
FROM product_line_remark_cte
ORDER BY 2 DESC;
```

### Query Result

![product line status](../SQL%20Projects%20Images/Walmart%20Sales%20Analysis%20Images/product%20line%20status.png)

### Insight

The analysis revealed that the following product lines performed above the overall business average:

- Home and Lifestyle
- Sports and Travel
- Health and Beauty
- Food and Beverages

These product lines were classified as **Good**.

The remaining product lines:

- Electronic Accessories
- Fashion Accessories

were classified as **Bad** because their average sales values fell below the overall business average.

One particularly interesting observation is that some product lines generated high overall revenue but still recorded lower average transaction values compared to other categories.

This demonstrates the importance of evaluating both total revenue and average sales performance when assessing product success.

---

## Which Branch Sold More Products Than the Business Average?

The next analysis focused on identifying branches whose average quantity sold exceeded the overall business average.

The first step was to calculate the average quantity sold across the entire business before comparing individual branch performance.

### SQL Query

```sql
SELECT *
FROM
(
    SELECT branch,
           AVG(quantity) average_quantity_by_branch
    FROM sales
    GROUP BY branch
) a
WHERE average_quantity_by_branch >
(
    SELECT AVG(quantity)
    FROM sales
);
```

### Query Result

![branch sales](../SQL%20Projects%20Images/Walmart%20Sales%20Analysis%20Images/branch%20sales.png)

### Insight

The overall average quantity sold across the business was approximately **5.50 units**.

The analysis revealed that only **Branch C** exceeded this benchmark.

This result aligns with previous findings that showed Naypyitaw (the city associated with Branch C) generated the highest revenue.

Higher quantities sold generally contribute to stronger revenue performance, making this result consistent with earlier analyses.

---

## What Is the Most Common Product Line by Gender?

The next analysis examined purchasing preferences across gender groups.

A window function was used to rank product lines based on sales counts for each gender category.

### SQL Query

```sql
SELECT gender,
       product_line,
       count
FROM
(
    SELECT gender,
           product_line,
           COUNT(*) count,
           RANK() OVER
           (
               PARTITION BY gender
               ORDER BY COUNT(*) DESC
           ) rnk
    FROM sales
    GROUP BY gender, product_line
) a
WHERE rnk = 1;
```

### Query Result

![product line by gender](../SQL%20Projects%20Images/Walmart%20Sales%20Analysis%20Images/product%20line%20by%20gender.png)

### Insight

The analysis revealed:

| Gender | Most Common Product Line |
|----------|-------------------------|
| Female | Fashion Accessories |
| Male | Health and Beauty |

The results suggest differences in purchasing behaviour between customer groups.

Fashion Accessories were most popular among female customers, while Health and Beauty products were most popular among male customers during the period covered by the dataset.

---

## What Is the Average Rating of Each Product Line?

The final product-related question focused on customer satisfaction across product categories.

### SQL Query

```sql
SELECT product_line,
       ROUND(AVG(rating),2) average_rating
FROM sales
GROUP BY product_line
ORDER BY 2 DESC;
```

### Query Result

![product line rating](../SQL%20Projects%20Images/Walmart%20Sales%20Analysis%20Images/product%20line%20rating.png)

### Insight

The analysis revealed the following ranking:

| Product Line | Average Rating |
|--------------|---------------|
| Food and Beverages | 7.11 |
| Fashion Accessories | 7.03 |
| Health and Beauty | 6.98 |
| Electronic Accessories | 6.91 |
| Sports and Travel | 6.86 |
| Home and Lifestyle | 6.84 |

Food and Beverages received the highest average customer rating.

Combining this result with the revenue analysis further highlights the strong performance of this product category.

High revenue together with strong customer ratings suggests that Food and Beverages were among the most successful product categories within the business.

# Sales-Related Questions

The next section of the analysis focused on sales performance across different periods, customer categories, and locations.

The objective was to identify patterns that influence revenue generation and understand how customer behaviour affects overall business performance.

---

## Number of Sales Made in Each Time of the Day Per Weekday

The first question in this section was to determine how sales activity varied across different days of the week and different times of the day.

The analysis made use of the **day_name** and **time_of_day** columns that were created during the feature engineering phase of the project.

### SQL Query

```sql
SELECT day_name,
       time_of_day,
       COUNT(*) total_sales
FROM sales
GROUP BY day_name, time_of_day
ORDER BY 1,3 DESC;
```

### Query Result

![sales by time of day](../SQL%20Projects%20Images/Walmart%20Sales%20Analysis%20Images/sales%20by%20time%20of%20day.png)

### Insight

The analysis revealed that the highest number of sales on most weekdays occurred during the **Evening** period.

For:

- Sunday
- Monday
- Tuesday
- Thursday
- Saturday

the Evening period recorded the highest sales volume.

However, on:

- Wednesday
- Friday

the Afternoon period recorded the highest number of sales.

A consistent pattern across the entire dataset was that the Morning period recorded the lowest number of sales transactions.

This suggests that customers were more active later in the day, particularly after typical working hours when they had more time available for shopping.

---

## Which Customer Type Generates the Most Revenue?

The next objective was to determine which customer category contributed the most revenue to the business.

### SQL Query

```sql
SELECT customer_type,
       SUM(total) total_revenue
FROM sales
GROUP BY customer_type
ORDER BY 2 DESC;
```

### Query Result

![customer type revenue](../SQL%20Projects%20Images/Walmart%20Sales%20Analysis%20Images/customer%20type%20revenue.png)

### Insight

The analysis revealed the following:

| Customer Type | Revenue |
|--------------|----------|
| Member | 163,625.1015 |
| Normal | 157,261.2930 |

Member customers generated more revenue than Normal customers.

This suggests that loyalty or membership programs may encourage customers to make more purchases and contribute more significantly to overall business revenue.

The result highlights the importance of customer retention programs and membership initiatives in driving business growth.

---

## Which City Generated the Highest VAT?

The next analysis focused on determining which city contributed the highest amount of Value Added Tax (VAT).

### SQL Query

```sql
SELECT city,
       SUM(VAT) total_VAT
FROM sales
GROUP BY city
ORDER BY total_VAT DESC
LIMIT 1;
```

### Query Result

![highest vat by city](../SQL%20Projects%20Images/Walmart%20Sales%20Analysis%20Images/highest%20vat%20by%20city.png)

### Insight

The analysis showed that:

| City | Total VAT |
|------|------------|
| Naypyitaw | 5,261.4655 |

Naypyitaw generated the highest VAT contribution among all cities.

This result is consistent with previous analyses where Naypyitaw also recorded the highest revenue.

Since VAT is directly linked to sales value, cities with higher revenue are expected to contribute higher VAT amounts.

---

## Which Customer Type Pays the Most VAT?

The final sales-related question focused on identifying which customer category contributed the highest amount of VAT.

### SQL Query

```sql
SELECT customer_type,
       SUM(vat) total_VAT
FROM sales
GROUP BY customer_type
ORDER BY total_VAT DESC;
```

### Query Result

![highest vat](../SQL%20Projects%20Images/Walmart%20Sales%20Analysis%20Images/highest%20vat.png)

### Insight

The analysis revealed the following:

| Customer Type | Total VAT |
|--------------|-----------|
| Member | 7,791.6715 |
| Normal | 7,488.6330 |

Member customers contributed more VAT than Normal customers.

This result aligns with the earlier revenue analysis which showed that Member customers generated more sales revenue overall.

Because VAT is calculated as a percentage of transaction value, customers who spend more naturally contribute more VAT.

The findings suggest that Member customers play a particularly important role in both revenue generation and tax contribution within the business.

# Customer-Related Questions

The final section of the project focused on customer behaviour and customer demographics.

The objective of this section was to better understand Walmart's customer base by analysing customer types, payment preferences, purchasing behaviour, and gender distribution across branches.

Understanding customer behaviour can help businesses improve customer retention strategies, tailor marketing campaigns, and enhance overall customer experience.

---

## How Many Unique Customer Types Does the Dataset Have?

The first question was to determine the number of unique customer categories represented in the dataset.

### SQL Query

```sql
SELECT COUNT(DISTINCT customer_type) unique_customer_types
FROM sales;
```

### Query Result

![customer type count](../SQL%20Projects%20Images/Walmart%20Sales%20Analysis%20Images/customer%20type%20count.png)

### Insight

The analysis revealed that the dataset contains **2 unique customer types**:

- Member
- Normal

This suggests that Walmart categorizes customers based on membership status, allowing the business to compare purchasing behaviour between loyalty program members and regular customers.

---

## How Many Unique Payment Methods Does the Dataset Have?

The next question was to determine the number of available payment methods used by customers.

### SQL Query

```sql
SELECT COUNT(DISTINCT payment_method) unique_payment_methods
FROM sales;
```

### Query Result

![unique payment methods](../SQL%20Projects%20Images/Walmart%20Sales%20Analysis%20Images/unique%20payment%20methods.png)

### Insight

The analysis revealed that customers used **3 different payment methods**:

- Cash
- E-Wallet
- Credit Card

The presence of multiple payment options provides customers with flexibility and convenience when making purchases.

---

## What Is the Most Common Customer Type?

The next objective was to determine which customer category appeared most frequently within the dataset.

### SQL Query

```sql
SELECT customer_type,
       COUNT(*) customer_type_count
FROM sales
GROUP BY customer_type
ORDER BY 2 DESC;
```

### Query Result

![common customer type](../SQL%20Projects%20Images/Walmart%20Sales%20Analysis%20Images/common%20customer%20type.png)

### Insight

The analysis revealed the following customer distribution:

| Customer Type | Count |
|--------------|--------|
| Member | 499 |
| Normal | 496 |

Member customers slightly outnumbered Normal customers.

Although the difference is very small, the result suggests that Walmart's membership program has achieved a relatively balanced adoption rate among customers.

The small gap also indicates that there may still be opportunities to attract more Normal customers into the membership program.

---

## Which Customer Type Purchases the Most Products?

The next question was to identify the customer category responsible for the highest number of purchases.

### SQL Query

```sql
SELECT customer_type,
       COUNT(*) total_sales
FROM sales
GROUP BY customer_type
ORDER BY 2 DESC
LIMIT 1;
```

### Query Result

![buys the most](../SQL%20Projects%20Images/Walmart%20Sales%20Analysis%20Images/buys%20the%20most.png)

### Insight

The analysis showed that **Member customers** recorded the highest number of purchases.

This finding aligns closely with previous analyses where Member customers also generated the highest revenue and contributed the highest VAT.

Taken together, these results suggest that Member customers represent a particularly valuable customer segment for the business.

---

## What Is the Gender Distribution of Customers?

The next analysis focused on understanding the gender composition of Walmart's customer base.

### SQL Query

```sql
SELECT gender,
       COUNT(*) gender_count
FROM sales
GROUP BY gender
ORDER BY gender DESC;
```

### Query Result

![gender count](../SQL%20Projects%20Images/Walmart%20Sales%20Analysis%20Images/gender%20count.png)

### Insight

The analysis revealed the following distribution:

| Gender | Count |
|---------|--------|
| Male | 498 |
| Female | 497 |

The customer base is almost perfectly balanced between male and female customers.

This suggests that Walmart's products and services appeal broadly to both genders rather than being heavily concentrated toward a specific demographic group.

---

## What Is the Gender Distribution Per Branch?

The next analysis examined how gender distribution varied across different branches.

### SQL Query

```sql
SELECT branch,
       gender,
       COUNT(*) gender_count
FROM sales
GROUP BY branch, gender
ORDER BY 1,3 DESC;
```

### Query Result

![gender distribution](../SQL%20Projects%20Images/Walmart%20Sales%20Analysis%20Images/gender%20distribution.png)

### Insight

The analysis revealed the following:

| Branch | Gender | Count |
|---------|---------|--------|
| A | Male | 179 |
| A | Female | 160 |
| B | Male | 169 |
| B | Female | 160 |
| C | Female | 177 |
| C | Male | 150 |

Branches A and B recorded more male customers than female customers.

However, Branch C displayed a different pattern, with female customers significantly outnumbering male customers.

This suggests that customer demographics may vary across locations and could be influenced by local purchasing behaviour, population characteristics, or branch-specific factors.

## What Time of Day Do Customers Give the Most Ratings?

The next analysis focused on identifying the period of the day when customers were most likely to provide ratings.

This analysis made use of the **time_of_day** column that was created during the feature engineering phase of the project.

### SQL Query

```sql
SELECT time_of_day,
       COUNT(rating) rating_count
FROM
(
    SELECT time_of_day,
           rating
    FROM sales
) a
GROUP BY time_of_day
ORDER BY rating_count DESC;
```

### Query Result

![rating-count](../SQL%20Projects%20Images/Walmart%20Sales%20Analysis%20Images/rating-count.png)

### Insight

The analysis revealed the following:

| Time of Day | Rating Count |
|-------------|--------------|
| Evening | 429 |
| Afternoon | 376 |
| Morning | 190 |

The Evening period recorded the highest number of customer ratings.

This may indicate that customers are more willing to provide feedback later in the day when they have completed their shopping activities and have more time available.

The Morning period recorded the lowest number of ratings, which could be attributed to customers being occupied with work, school, or other daily activities during that period.

---

## What Time of Day Do Customers Give the Most Ratings Per Branch?

The next analysis expanded upon the previous question by examining rating activity at the branch level.

The objective was to determine the period of the day during which customers were most likely to submit ratings for each branch.

### SQL Query

```sql
SELECT branch,
       time_of_day,
       COUNT(rating) rating_count
FROM sales
GROUP BY branch, time_of_day
ORDER BY 1,3 DESC;
```

### Query Result

![ratings per branch](../SQL%20Projects%20Images/Walmart%20Sales%20Analysis%20Images/ratings%20per%20branch.png)

### Insight

The analysis revealed that:

- Branch A received the highest number of ratings during the Evening.
- Branch B received the highest number of ratings during the Evening.
- Branch C received the highest number of ratings during the Evening.

The consistency across all three branches strengthens the earlier finding that customers are most likely to provide feedback during the Evening period.

This pattern may reflect customer availability after work hours or increased shopping activity later in the day.

---

## Which Day of the Week Has the Best Average Rating?

The next objective was to identify the day of the week that recorded the highest average customer rating.

### SQL Query

```sql
SELECT day_name,
       AVG(rating) average_rating
FROM sales
GROUP BY day_name
ORDER BY 2 DESC;
```

### Query Result

![best average rating](../SQL%20Projects%20Images/Walmart%20Sales%20Analysis%20Images/best%20average%20rating.png)

### Insight

The analysis revealed the following ranking:

| Day | Average Rating |
|------|---------------|
| Monday | 7.13 |
| Friday | 7.06 |
| Tuesday | 7.00 |
| Sunday | 6.99 |
| Saturday | 6.90 |
| Thursday | 6.89 |
| Wednesday | 6.76 |

Monday recorded the highest average customer rating, while Wednesday recorded the lowest.

This suggests that customer satisfaction levels may vary throughout the week.

The higher ratings observed on Mondays and Fridays could be influenced by factors such as customer mood, staffing levels, product availability, or shopping patterns.

---

## Which Day of the Week Has the Best Average Rating Per Branch?

The final analysis of the project focused on identifying the highest-rated day for each branch.

This allowed for a more detailed understanding of customer satisfaction at the branch level.

### SQL Query

```sql
SELECT branch,
       day_name,
       AVG(rating) average_rating
FROM sales
GROUP BY branch, day_name
ORDER BY 1,3 DESC;
```

### Query Result

![best average rating per branch](../SQL%20Projects%20Images/Walmart%20Sales%20Analysis%20Images/best%20average%20rating%20per%20branch.png)

### Insight

The analysis revealed the following:

| Branch | Highest Rated Day |
|----------|------------------|
| A | Friday |
| B | Monday |
| C | Friday |

Branch B achieved its highest average rating on Monday, while Branches A and C recorded their highest average ratings on Friday.

These findings suggest that customer satisfaction patterns vary slightly across branches and may be influenced by branch-specific operations, staffing, customer demographics, or local shopping habits.

The ability to identify the strongest-performing days for each branch can help management better understand customer behaviour and maintain high service standards.

---

This marks the completion of the Customer-Related Questions section and the Exploratory Data Analysis phase of the project.


# Key Findings

The analysis generated several important business insights regarding customer behaviour, product performance, branch performance, and revenue generation.

### Branch Performance

- Branch C, located in Naypyitaw, generated the highest revenue among all branches.
- Branch C was also the only branch that sold more products than the overall business average.
- Naypyitaw recorded both the highest revenue and the highest VAT contribution.

### Product Performance

- Fashion Accessories recorded the highest sales count.
- Food and Beverages generated the highest revenue.
- Food and Beverages also generated the highest VAT contribution.
- Food and Beverages received the highest average customer rating.

These findings demonstrate that the most frequently purchased product category is not always the category that generates the highest revenue.

### Customer Behaviour

- Member customers generated more revenue than Normal customers.
- Member customers made more purchases than Normal customers.
- Member customers contributed the highest VAT payments.

These findings suggest that membership programs can play an important role in increasing customer value and revenue generation.

### Sales Trends

- January generated the highest revenue and the highest Cost of Goods Sold (COGS).
- Most sales occurred during the Evening period.
- Most customer ratings were also submitted during the Evening period.

This suggests that customer activity was generally highest later in the day.

### Customer Satisfaction

- Monday recorded the highest average customer rating.
- Branch A achieved its highest average rating on Friday.
- Branch B achieved its highest average rating on Monday.
- Branch C achieved its highest average rating on Friday.

These findings indicate that customer satisfaction patterns vary slightly across branches and across different days of the week.

---

# SQL Concepts Demonstrated

This project demonstrates the practical application of several SQL concepts used in real-world data analysis projects.

### Database Management

- CREATE SCHEMA
- USE
- CREATE TABLE
- ALTER TABLE

### Data Definition Language (DDL)

- Creating databases
- Creating tables
- Adding new columns
- Defining constraints

### Aggregate Functions

- COUNT()
- SUM()
- AVG()
- ROUND()

### Conditional Logic

- CASE Statements

### Date Functions

- DAYNAME()
- MONTHNAME()
- MONTH()

### Filtering and Sorting

- WHERE
- ORDER BY
- LIMIT

### Grouping Operations

- GROUP BY
- DISTINCT

### Common Table Expressions (CTEs)

```sql
WITH product_line_remark_cte AS
(
    SELECT product_line,
           AVG(total) avg_total_sales
    FROM sales
    GROUP BY product_line
)
```

### Subqueries

```sql
SELECT AVG(total)
FROM sales;
```

### Window Functions

```sql
RANK() OVER
(
    PARTITION BY gender
    ORDER BY COUNT(*) DESC
)
```

### Feature Engineering

- Time of Day Classification
- Day Name Extraction
- Month Name Extraction

---

# Business Recommendations

Based on the findings from this analysis, the following recommendations may be considered:

### Expand High-Performing Product Categories

Food and Beverages generated the highest revenue and received the highest customer ratings. The business may benefit from expanding offerings within this category and ensuring product availability remains consistent.

### Strengthen Membership Programs

Member customers generated more revenue, made more purchases, and contributed more VAT than Normal customers.

Introducing additional membership incentives may encourage more customers to join the program and increase overall customer lifetime value.

### Leverage Evening Sales Activity

The majority of sales and customer ratings occurred during the Evening period.

The business could consider scheduling promotional campaigns, staffing resources, and marketing activities around peak Evening shopping hours.

### Learn from High-Performing Branches

Branch C consistently demonstrated strong performance across multiple metrics.

Management may benefit from identifying operational practices that contribute to Branch C's success and applying those practices to other branches where appropriate.

---

# Conclusion

This project successfully analysed Walmart sales data using SQL to uncover insights related to branch performance, customer behaviour, product performance, and revenue generation.

The analysis began with data wrangling and feature engineering before progressing into a comprehensive Exploratory Data Analysis phase covering generic, product-related, sales-related, and customer-related business questions.

The findings revealed meaningful patterns regarding customer purchasing behaviour, branch performance, payment preferences, product profitability, and customer satisfaction.

Through this project, SQL was used not only as a querying tool but also as a business intelligence tool capable of transforming raw transactional data into actionable insights that can support data-driven decision-making.

---


🛒📊💾