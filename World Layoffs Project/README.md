# 🌍 World Layoffs Data Cleaning & Exploratory Data Analysis Using SQL

## Project Overview

This project focuses on cleaning and analyzing a global layoffs dataset using MySQL. The dataset contains information about company layoffs across different countries, industries, funding stages, and time periods.

The project was divided into two major phases:

1. Data Cleaning
2. Exploratory Data Analysis (EDA)

The primary objective of this project was to transform raw layoffs data into a clean and reliable dataset before exploring patterns and trends in layoffs across companies, industries, countries, and years.

---

## Dataset Information

The dataset was imported into MySQL without any modifications.

The table contained information such as:

- Company
- Location
- Industry
- Total Laid Off
- Percentage Laid Off
- Date
- Funding Stage
- Country
- Funds Raised (Millions)

The dataset contained a total of **2,361 records** and was imported into a table called **layoffs**.

### Raw Dataset
![Layoffs Raw Dataset](../SQL%20Projects%20Images/World%20Layoffs%20Project%20Images/Raw%20Dataset.png)
---

# Phase 1: Data Cleaning

Before beginning the cleaning process, a new schema called **world_layoffs** was created to store the project data.

```sql
CREATE SCHEMA world_layoffs;

USE world_layoffs;
```

The data cleaning process was divided into four major steps:

1. Removing Duplicates
2. Standardizing Data
3. Handling Null and Blank Values
4. Removing Unnecessary Rows and Columns

Before performing any cleaning operations, a staging table was created from the original dataset. This ensured that the original raw data remained untouched throughout the cleaning process.

```sql
CREATE TABLE layoffs_staging
SELECT *
FROM layoffs;
```

---

## Step 1: Removing Duplicate Records

The dataset did not contain a unique identifier column, making duplicate detection more challenging.

To identify duplicate records, a **ROW_NUMBER() Window Function** was used alongside the **PARTITION BY** clause.

The query assigned a row number to records sharing identical values across all columns.

```sql
SELECT *
FROM
(
SELECT *,
ROW_NUMBER() OVER
(
PARTITION BY company,
location,
industry,
total_laid_off,
percentage_laid_off,
date,
stage,
country,
funds_raised_millions
) AS row_num
FROM layoffs_staging
) a
WHERE row_num > 1;
```

### Duplicate Detection Result

> ![Duplicate Detection Result](../SQL%20Projects%20Images/World%20Layoffs%20Project%20Images/Duplicate%20Detection%20Result.png)

After identifying duplicate records, a second staging table was created to store the updated dataset along with the generated row numbers.

```sql
CREATE TABLE layoffs_staging2
SELECT *
FROM
(
SELECT *,
ROW_NUMBER() OVER
(
PARTITION BY company,
location,
industry,
total_laid_off,
percentage_laid_off,
date,
stage,
country,
funds_raised_millions
) AS row_num
FROM layoffs_staging
) a;
```

Duplicate records were then removed from the dataset.

```sql
DELETE
FROM layoffs_staging2
WHERE row_num > 1;
```

After deleting the duplicate records:

- The original staging table was dropped.
- The updated staging table was renamed.
- A validation check was performed to confirm that no duplicate records remained.

```sql
DROP TABLE layoffs_staging;

ALTER TABLE layoffs_staging2
RENAME TO layoffs_staging;
```

### Duplicate Removal Validation

```sql
SELECT *
FROM layoffs_staging
WHERE row_num > 1;
```

### Validation Result

> ![Duplicate Removal Validation](../SQL%20Projects%20Images/World%20Layoffs%20Project%20Images/Duplicate%20Removal%20Validation.png)

The validation query returned no records, confirming that all duplicate entries had been successfully removed from the dataset.

---
## Step 2: Standardizing Data

After removing duplicate records, the next step in the data cleaning process was standardizing the dataset.

The objective of this step was to ensure consistency across the data by correcting formatting issues, standardizing text values, and converting data types where necessary.

The following columns were reviewed during this process:

- Company
- Industry
- Location
- Country
- Date

---

### Standardizing the Company Column

The first issue identified was the presence of leading and trailing whitespaces in some company names.

To identify these records, the **TRIM()** function was used.

```sql
SELECT
company,
TRIM(company)
FROM layoffs_staging;
```

After confirming the presence of unnecessary whitespaces, the company column was updated using the TRIM() function.

```sql
UPDATE layoffs_staging
SET company = TRIM(company);
```

### Company Standardization Result

> ![Company Standardization Result](../SQL%20Projects%20Images/World%20Layoffs%20Project%20Images/Company%20Standardization%20Result.png)

Removing unnecessary whitespaces ensured that company names were stored consistently throughout the dataset.

---

### Standardizing the Industry Column

The next column reviewed was the **industry** column.

During exploration of the data, it was discovered that some industry values referred to the same industry but were stored using different spellings.

To identify these records, the LIKE clause was used.

```sql
SELECT *
FROM layoffs_staging
WHERE industry LIKE '%crypto%';
```

The query revealed multiple variations of the same industry, including:

- CryptoCurrency
- Crypto Currency
### Identifying Industry Inconsistencies

![Industry Standardization Result](../SQL%20Projects%20Images/World%20Layoffs%20Project%20Images/Industry%20Standardization%20Result.png)




Since both values represented the same industry, they were standardized to a single value:

```sql
UPDATE layoffs_staging
SET industry = 'Crypto'
WHERE industry IN
(
'CryptoCurrency',
'Crypto Currency'
);
```

### Industry Standardization Result

> ![Industry Standardization Result](../SQL%20Projects%20Images/World%20Layoffs%20Project%20Images/Industry%20Standardization%20Result2.png)



---

### Exploring the Location Column

The location column was reviewed to check for inconsistencies.

```sql
SELECT DISTINCT location
FROM layoffs_staging;
```

No significant issues requiring correction were identified within the location column.

---

### Standardizing the Country Column

The next column reviewed was the **country** column.

During exploration, inconsistencies were identified in some country values.

To identify the affected records, the DISTINCT clause was used.

```sql
SELECT DISTINCT country
FROM layoffs_staging
ORDER BY 1 ASC;
```
### Identifying Country Inconsistencies
![Country Standardization Result](../SQL%20Projects%20Images/World%20Layoffs%20Project%20Images/Country%20Standardization%20Result.png)

After identifying the inconsistencies, an update statement was used to standardize the country values.

```sql
UPDATE layoffs_staging
SET country = 'United States'
WHERE country LIKE '%United Sta%';
```

### Country Standardization Result

![Country Standardization Result](../SQL%20Projects%20Images/World%20Layoffs%20Project%20Images/Country%20Standardization%20Result2.png)

This ensured that all records belonging to the United States were stored under a single standardized value.

---

### Standardizing the Date Column

While reviewing the dataset, it was observed that the date column had been imported as a text field.

Before any time-based analysis could be performed, the date values needed to be converted into a proper SQL date format.

To accomplish this, the **STR_TO_DATE()** function was used.

```sql
SELECT
date,
STR_TO_DATE(date,'%m/%d/%Y')
FROM layoffs_staging;
```
### Converting the Date Values to SQL Date Format

![Date Conversion Result 1](../SQL%20Projects%20Images/World%20Layoffs%20Project%20Images/Date1.png)

The converted values were then written back to the table.

```sql
UPDATE layoffs_staging
SET date = STR_TO_DATE(date,'%m/%d/%Y');
```
After converting the values, the data type of the column was changed from text to date.

```sql
ALTER TABLE layoffs_staging
MODIFY COLUMN date DATE NULL;
```

### Changing the Datatype of the Date Column
![Date Conversion Result 2](../SQL%20Projects%20Images/World%20Layoffs%20Project%20Images/Date2.png)


Converting the column to a proper SQL date format enabled the use of date functions and ensured accurate time-based analysis during the Exploratory Data Analysis phase.

---

### Summary of Standardization Activities

The standardization process involved:

- Removing unnecessary whitespaces from company names.
- Standardizing industry classifications.
- Correcting inconsistent country values.
- Converting the date column from text to a SQL date format.

These transformations improved the overall quality, consistency, and reliability of the dataset and prepared it for further cleaning and analysis.

---
# Step 3: Handling Null and Blank Values

After standardizing the dataset, the next phase of the cleaning process focused on identifying and resolving null values and blank values.

Missing values can negatively impact analysis results and lead to inaccurate conclusions. Therefore, it was important to investigate the dataset thoroughly and resolve any missing information where possible.

The industry column was selected for investigation because some records contained either null values or blank values.

The following query was used to identify the affected records:

```sql
SELECT *
FROM layoffs_staging
WHERE industry IS NULL
OR industry IN ('');
```

### Null and Blank Value Investigation
![Null and Blank Values](../SQL%20Projects%20Images/World%20Layoffs%20Project%20Images/Null%20and%20Blank.png)

After identifying the affected records, the next step was to determine whether the missing industry values could be recovered.

The company names associated with the missing records were examined and compared against other records belonging to the same companies within the dataset.

---

## Recovering Missing Industry Values

### Airbnb

The first company investigated was Airbnb.

```sql
SELECT *
FROM layoffs_staging
WHERE company = 'airbnb';
```

Upon reviewing the available records, it was observed that other Airbnb records already contained a valid industry classification.

The missing industry value was therefore updated accordingly.

```sql
UPDATE layoffs_staging
SET industry = 'Travel'
WHERE company = 'airbnb';
```

### Airbnb Update Result

![BNB Update](../SQL%20Projects%20Images/World%20Layoffs%20Project%20Images/BNB%20Update.png)
---

### Carvana

The next company investigated was Carvana.

```sql
SELECT *
FROM layoffs_staging
WHERE company = 'Carvana';
```
Other Carvana records within the dataset contained valid industry information.

The missing industry value was therefore updated.

```sql
UPDATE layoffs_staging
SET industry = 'Transportation'
WHERE company = 'Carvana';
```

### Carvana Update Result
![Carvana Update](../SQL%20Projects%20Images/World%20Layoffs%20Project%20Images/Carvana%20Update.png)
---

### Juul

The next company investigated was Juul.

```sql
SELECT *
FROM layoffs_staging
WHERE company = 'Juul';
```

After reviewing the available records, the missing industry value was recovered and updated.

```sql
UPDATE layoffs_staging
SET industry = 'Consumer'
WHERE company = 'Juul';
```

### Juul Update Result

![Juul Update](../SQL%20Projects%20Images/World%20Layoffs%20Project%20Images/Juul%20Update.png)

---

### Remaining Missing Values

Most of the missing industry values were successfully recovered by comparing records belonging to the same company.

However, one record could not be completed because no additional company records existed within the dataset that could be used as a reference.

As a result, that particular missing value was left unchanged.

---

# Step 4: Removing Unnecessary Rows and Columns

After resolving the missing values, the final stage of the data cleaning process involved removing unnecessary records and columns.

---

## Removing Unnecessary Rows

The dataset contained records where both:

- Total Laid Off
- Percentage Laid Off

were missing.

Since these records contained no meaningful layoff information, they were considered unsuitable for analysis.

The following query was used to identify these records:

```sql
SELECT *
FROM layoffs_staging
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;
```

### Records Identified for Removal
![Null Values](../SQL%20Projects%20Images/World%20Layoffs%20Project%20Images/Null%20Values.png)

The identified records were then removed from the dataset.

```sql
DELETE
FROM layoffs_staging
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;
```

### Row Deletion Result
![Removed Nulls](../SQL%20Projects%20Images/World%20Layoffs%20Project%20Images/Removed%20Nulls.png)

Removing these records ensured that every remaining record contained useful layoff information.

---

## Removing Unnecessary Columns

During the duplicate removal process, a helper column called **row_num** was created using the ROW_NUMBER() window function.

This column served its purpose during the duplicate detection stage and was no longer required after the cleaning process was completed.

The column was removed using the following query:

```sql
ALTER TABLE layoffs_staging
DROP COLUMN row_num;
```

### Column Removal Result

![Removed Column](../SQL%20Projects%20Images/World%20Layoffs%20Project%20Images/Removed%20Column.png)

## Final Cleaned Dataset

At this stage:

- Duplicate records had been removed.
- Industry values had been standardized.
- Country values had been standardized.
- Company names had been cleaned.
- Date values had been converted to a proper SQL date format.
- Missing values had been investigated and resolved where possible.
- Unnecessary rows had been removed.
- Temporary helper columns had been removed.

The dataset was now clean, consistent, and ready for analysis.

### Final Cleaned Dataset

![Removed Column](../SQL%20Projects%20Images/World%20Layoffs%20Project%20Images/Removed%20Column.png)

---

## Data Cleaning Summary

The data cleaning phase involved four major activities:

1. Removing Duplicate Records
2. Standardizing Data
3. Handling Null and Blank Values
4. Removing Unnecessary Rows and Columns

These steps improved the quality, consistency, and reliability of the dataset and prepared it for the Exploratory Data Analysis phase of the project.

---

# Phase 2: Exploratory Data Analysis (EDA)

With the dataset successfully cleaned and validated, the next phase of the project focused on exploring the data to uncover trends, patterns, and insights related to layoffs across different companies, industries, countries, and time periods.

The objective of this phase was to answer key business questions and better understand how layoffs were distributed across the global workforce.

---
## Maximum Number of Layoffs Recorded

The first analysis performed during the Exploratory Data Analysis phase was to identify the highest number of layoffs recorded in a single event.

The objective of this analysis was to determine which company recorded the largest workforce reduction within the dataset.

The following query was used:

```sql
SELECT *
FROM layoffs_staging
WHERE total_laid_off =
(
SELECT MAX(total_laid_off)
FROM layoffs_staging
);
```

### Query Result

![Max Layoffs](../SQL%20Projects%20Images/World%20Layoffs%20Project%20Images/Max%20layoffs.png)


### Key Insight

The analysis revealed that **Google** recorded the highest single layoff event in the dataset, laying off approximately **12,000 employees**.

It should also be noted that Google was in the **Post-IPO** stage at the time of the layoffs.

One interesting observation from this analysis is that some of the world's largest and most established organizations were responsible for some of the largest workforce reductions during the period under review.

---
## Total Layoffs by Company

The next analysis focused on identifying the companies responsible for the highest number of layoffs.

The following query was used:

```sql
SELECT
company,
SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging
GROUP BY company
ORDER BY total_layoffs DESC;
```

### Query Result

![Layoffs](../SQL%20Projects%20Images/World%20Layoffs%20Project%20Images/Layoffs.png)

### Key Findings

The companies with the highest layoffs included:

| Company | Total Layoffs |
|----------|-------------:|
| Amazon | 18,150 |
| Google | 12,000 |
| Meta | 11,000 |
| Salesforce | 10,090 |
| Microsoft | 10,000 |

### Key Insights

Several of the world's largest technology companies appeared at the top of the list.

This suggests that large organizations were not immune to workforce reductions despite their market dominance and financial resources.

The analysis demonstrates how economic uncertainty can impact businesses regardless of company size.

Another observation is that many of these organizations operate within the technology sector, indicating that the technology industry experienced significant restructuring during the period covered by the dataset.

---

## Date Range Analysis

Before continuing with further analysis, it was important to understand the time period covered by the dataset.

The following query was used:

```sql
SELECT
MIN(date),
MAX(date)
FROM layoffs_staging;
```

### Query Result
![Date Range](../SQL%20Projects%20Images/World%20Layoffs%20Project%20Images/Date%20Range.png)

### Key Findings

The dataset covers the period between:

- **11 March 2020**
- **6 March 2023**

### Key Insight

This date range covers a significant portion of the COVID-19 pandemic period and its aftermath.

As a result, many of the layoffs captured in the dataset may have been influenced by:

- Economic uncertainty
- Market slowdowns
- Business restructuring
- Post-pandemic workforce adjustments

Understanding the date range provides important context for interpreting the remaining analysis.

---

## Total Layoffs by Industry

The next analysis focused on identifying which industries were most affected by layoffs.

The following query was used:

```sql
SELECT
industry,
SUM(total_laid_off)
FROM layoffs_staging
GROUP BY industry
ORDER BY 2 DESC;
```

### Query Result

![Industry Layoffs](../SQL%20Projects%20Images/World%20Layoffs%20Project%20Images/Industry%20layoffs.png)

----

### Key Findings

The most affected industries included:

| Industry | Total Layoffs |
|-----------|-------------:|
| Consumer | 45,182 |
| Retail | 43,613 |
| Others | ... |

The least affected industries included:

| Industry | Total Layoffs |
|-----------|-------------:|
| FinTech | 215 |
| Manufacturing | 20 |

### Key Insights

The Consumer and Retail industries experienced the highest number of layoffs during the period under review.

This may be linked to changes in consumer spending patterns, supply chain disruptions, and broader economic challenges.

On the other hand, Manufacturing and FinTech recorded significantly lower layoff figures.

The relatively low layoffs observed within Manufacturing may indicate continued operational demand despite economic uncertainty.

The analysis highlights how different industries were affected in varying ways by global economic conditions.

---
## Total Layoffs by Country

After analyzing layoffs across industries, the next step was to identify the countries that were most affected by layoffs.

The following query was used:

```sql
SELECT DISTINCT
country,
SUM(total_laid_off) OVER(PARTITION BY country) AS total_layoffs
FROM layoffs_staging
ORDER BY total_layoffs DESC;
```

### Query Result

![Country Layoffs](../SQL%20Projects%20Images/World%20Layoffs%20Project%20Images/Country%20layoffs.png)

### Key Findings

The countries with the highest number of layoffs included:

| Country | Total Layoffs |
|----------|-------------:|
| United States | 256,559 |
| India | 35,993 |
| Netherlands | 17,220 |
| Others | ... |

### Key Insights

The United States recorded the highest number of layoffs by a significant margin.

Several factors may have contributed to this:

- The United States contains a large concentration of technology companies.
- Many of the companies included in the dataset are headquartered in the United States.
- The technology sector experienced substantial restructuring during the period covered by the dataset.

India recorded the second-highest number of layoffs, highlighting that workforce reductions were not limited to North America.

The analysis demonstrates the global nature of workforce reductions during the period under review.

---

## Total Layoffs by Year

The next analysis focused on understanding how layoffs changed over time.

Instead of analyzing layoffs at the daily level, yearly analysis was performed because it provides a clearer view of long-term trends.

The following query was used:

```sql
SELECT
YEAR(date) AS year,
SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging
GROUP BY year
ORDER BY total_layoffs DESC;
```

### Query Result

![Yearly Layoffs](../SQL%20Projects%20Images/World%20Layoffs%20Project%20Images/Yearly%20layoffs.png)


### Key Findings

| Year | Total Layoffs |
|------|-------------:|
| 2022 | 160,661 |
| 2023 | 125,677 |
| 2020 | ... |
| 2021 | ... |

### Key Insights

The year **2022** recorded the highest number of layoffs in the dataset.

One particularly interesting observation is that **2023 recorded approximately 125,677 layoffs despite the dataset only extending to March 2023**.

This means that within roughly the first quarter of 2023, global layoffs had already reached a level close to the total layoffs observed during some full years.

This finding highlights the severity of workforce reductions occurring during that period.

The analysis suggests that layoffs accelerated significantly during 2022 and continued at a high pace into early 2023.

---

## Total Layoffs by Company Stage

The next analysis examined layoffs across different company funding stages.

The objective was to determine whether layoffs were concentrated among startups, private companies, or publicly traded organizations.

The following query was used:

```sql
SELECT DISTINCT
stage,
SUM(total_laid_off) OVER(PARTITION BY stage) AS total_layoffs
FROM layoffs_staging
ORDER BY total_layoffs DESC;
```

### Query Result

![Layoffs Staging](../SQL%20Projects%20Images/World%20Layoffs%20Project%20Images/Layoffs%20staging.png)

### Key Findings

The analysis showed that companies in the **Post-IPO** stage recorded the highest number of layoffs.

### Key Insights

A Post-IPO company is a company that has already gone public and is listed on a stock exchange.

The fact that Post-IPO companies recorded the highest layoffs is particularly interesting because these organizations are typically:

- Larger in size
- More mature
- Better funded
- More established

Examples of companies within this category include major technology firms that announced significant workforce reductions during the period covered by the dataset.

The analysis demonstrates that workforce reductions affected both startups and established public companies.

---

## Comparing Layoffs Across Time

Combining the findings from the previous analyses reveals several interesting patterns:

- Large technology companies accounted for a significant share of layoffs.
- The United States recorded the highest layoff figures globally.
- The Consumer and Retail industries experienced substantial workforce reductions.
- Publicly traded companies recorded the highest layoff totals.
- Layoffs accelerated significantly during 2022 and remained elevated during early 2023.

These findings suggest that workforce reductions were influenced by broad economic conditions rather than problems isolated to a single company, industry, or country.

---

## Transition to Trend Analysis

While yearly analysis provides useful insights into overall layoff activity, it does not reveal how layoffs evolved from month to month.

To better understand the progression of layoffs over time, the next analysis focuses on:

- Total layoffs by year-month
- Rolling monthly layoffs
- Long-term layoff trends

These analyses provide a clearer picture of how workforce reductions evolved throughout the period covered by the dataset.

---
## Rolling Monthly Layoffs

To better visualize the progression of layoffs over time, a rolling total analysis was performed.

The objective of this analysis was to calculate a cumulative total of layoffs from month to month.

The following query was used:

```sql
SELECT *,
SUM(total_layoffs) OVER(ORDER BY date) AS rolling_total
FROM
(
SELECT DISTINCT
SUBSTR(date,1,7) AS date,
SUM(total_laid_off) OVER(PARTITION BY SUBSTR(date,1,7)) AS total_layoffs
FROM layoffs_staging
WHERE date IS NOT NULL
) a;
```

### Query Result
![Layoffs Year-Month](../SQL%20Projects%20Images/World%20Layoffs%20Project%20Images/Layoffs%20year-month.png)

### Key Insights

The rolling total analysis provides a running cumulative total of layoffs over time.

This analysis makes it easier to observe the overall trajectory of layoffs throughout the dataset.

Key observations include:

- Layoffs accumulated steadily over the period covered by the dataset.
- Certain periods experienced larger increases in layoffs than others.
- The cumulative trend highlights the scale of workforce reductions globally between 2020 and 2023.

Rolling calculations are commonly used in business intelligence and reporting because they help reveal long-term trends that may not be immediately obvious from individual monthly values.

---

## Top 5 Companies by Layoffs Per Year

The final analysis focused on identifying the companies that recorded the highest layoffs in each year.

To accomplish this, a combination of:

- Window Functions
- Aggregate Functions
- DENSE_RANK()

was used.

The following query was used:

```sql
SELECT *
FROM
(
SELECT
company,
date,
total_layoffs,
DENSE_RANK() OVER
(
PARTITION BY date
ORDER BY total_layoffs DESC
) AS ranking
FROM
(
SELECT DISTINCT
company,
YEAR(date) AS date,
SUM(total_laid_off) OVER
(
PARTITION BY company,
YEAR(date)
) AS total_layoffs
FROM layoffs_staging
WHERE date IS NOT NULL
) a
) b
WHERE ranking <= 5;
```

### Query Result
![Yearly Top 5](../SQL%20Projects%20Images/World%20Layoffs%20Project%20Images/Yearly%20Top%205.png)

### Key Insights

This analysis identified the five companies with the highest layoffs for each year in the dataset.

The use of **DENSE_RANK()** ensured that companies were ranked based on the total number of layoffs within each year.

This analysis highlights:

- Which organizations were most affected during each year.
- How workforce reductions changed among companies over time.
- The companies that consistently appeared among the highest layoff figures.

The combination of aggregation, window functions, and ranking functions demonstrates how SQL can be used to perform advanced business analysis.

---

# Key Findings

Several important insights were uncovered during this project:

### Workforce Reductions

- Google recorded the largest single layoff event with approximately 12,000 employees affected.
- Multiple companies recorded a layoff percentage of 100%, indicating complete business shutdowns.

### Company Analysis

- Amazon recorded the highest total layoffs overall.
- Other major contributors included Google, Meta, Salesforce, and Microsoft.
- Large technology companies accounted for a significant proportion of layoffs.

### Industry Analysis

- Consumer and Retail industries experienced the highest number of layoffs.
- Manufacturing and FinTech recorded the lowest layoff figures.

### Geographic Analysis

- The United States recorded the highest number of layoffs globally.
- India and the Netherlands were among the next most affected countries.

### Time Analysis

- 2022 recorded the highest number of layoffs.
- Early 2023 already showed extremely high layoff figures despite representing only part of the year.
- Rolling totals revealed the cumulative growth of layoffs throughout the period covered by the dataset.

### Company Stage Analysis

- Post-IPO companies recorded the highest number of layoffs.
- Workforce reductions affected both startups and mature public companies.

---

# SQL Concepts Demonstrated

This project demonstrates proficiency in the following SQL concepts:

### Data Definition Language (DDL)

- CREATE SCHEMA
- CREATE TABLE
- ALTER TABLE
- DROP TABLE

### Data Manipulation Language (DML)

- SELECT
- UPDATE
- DELETE

### Data Cleaning Techniques

- Duplicate Removal
- Data Standardization
- Null Value Handling
- Data Type Conversion

### Aggregate Functions

- SUM()
- MAX()
- MIN()

### Window Functions

- ROW_NUMBER()
- DENSE_RANK()
- SUM() OVER()

### String Functions

- TRIM()
- LIKE()
- SUBSTR()

### Date Functions

- STR_TO_DATE()
- YEAR()

### SQL Techniques

- Subqueries
- PARTITION BY
- ORDER BY
- GROUP BY
- DISTINCT

---

# Tools Used

- MySQL
- MySQL Workbench
- Microsoft Excel

---

# Conclusion

This project demonstrates a complete SQL workflow, beginning with raw data preparation and ending with business-focused analysis.

The project was divided into two major phases:

1. Data Cleaning
2. Exploratory Data Analysis

During the Data Cleaning phase, duplicate records were removed, data was standardized, missing values were investigated, and unnecessary records were eliminated.

During the Exploratory Data Analysis phase, SQL was used to uncover trends related to layoffs across companies, industries, countries, funding stages, and time periods.

The project demonstrates how SQL can be used not only for querying data, but also for cleaning, transforming, and analyzing real-world datasets to generate meaningful business insights.

---

🌍💾