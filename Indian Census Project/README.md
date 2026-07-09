# Indian Census Analysis Using SQL

## Project Overview

This project explores the **2011 Indian Census** dataset using SQL to uncover meaningful demographic insights across different states and districts in India. The analysis covers population growth, literacy, sex ratio, population distribution, previous census estimation, land per capita analysis, and several other demographic indicators.

Unlike many SQL projects that focus only on querying existing data, this project also demonstrates how SQL can be used to derive entirely new metrics by combining multiple datasets and applying mathematical formulas. Throughout the project, advanced SQL techniques such as joins, Common Table Expressions (CTEs), subqueries, window functions, and aggregate functions were used to transform raw census data into meaningful analytical insights.

---

## Project Objectives

The objectives of this project were to:

- Explore India's 2011 census data using SQL.
- Clean and transform raw census datasets for analysis.
- Analyze population growth, literacy rate, and sex ratio across different states.
- Estimate the male and female population using the available census information.
- Calculate literate and illiterate populations across districts and states.
- Estimate India's previous census population using population growth data.
- Perform land per capita analysis using total land area and population.
- Demonstrate practical SQL techniques for solving real-world analytical problems.

---

## Dataset Description

This project uses **two separate datasets**, each containing different demographic information.

### Dataset 1 — `population_data`

This dataset contains district-level demographic indicators, including:

- District
- State
- Growth
- Sex Ratio
- Literacy Rate

📸 **Raw Dataset 1**

![raw dataset 1](../SQL%20Projects%20Images/Indian%20Census%20Project%20Images/raw%20dataset%201.png)

---

### Dataset 2 — `newpopulation_data`

This dataset contains population and geographical information, including:

- District
- State
- Area (km²)
- Population

📸 **Raw Dataset 2**

![raw dataset 2](../SQL%20Projects%20Images/Indian%20Census%20Project%20Images/raw%20dataset%202.png)

---

Using two different datasets made the project significantly more analytical, as several calculations required information from both tables. SQL joins were used extensively throughout the project to combine these datasets before performing advanced demographic analysis.

---

## Database Setup

The project began by creating a dedicated SQL database named **`census`**, after which it was set as the default database.

The imported tables were originally named **`dataset1`** and **`dataset2`**, so they were renamed to **`population_data`** and **`newpopulation_data`** to improve readability and maintain consistency throughout the project.

After renaming the tables, both datasets were described using SQL to inspect their column structures and verify their datatypes before beginning the cleaning process.

```sql
-- Creating a Database
CREATE SCHEMA census;

-- Making the database the default database
USE census;

-- Renaming the imported tables
ALTER TABLE dataset1 RENAME TO population_data;
ALTER TABLE dataset2 RENAME TO newpopulation_data;

-- Viewing table structures
DESC population_data;
DESC newpopulation_data;
```

📸 **Database Creation**

![database creation 1](../SQL%20Projects%20Images/Indian%20Census%20Project%20Images/database%20creation%201.png)

![database creation 2](../SQL%20Projects%20Images/Indian%20Census%20Project%20Images/database%20creation%202.png)

---

## Data Cleaning

Before performing the analysis, several columns contained non-numeric characters that prevented SQL from recognizing them as numeric datatypes.

Three columns required cleaning:

- `Population`
- `Area_km2`
- `Growth`

The `REPLACE()` function was used to remove commas from the **Population** and **Area_km2** columns, while the percentage symbol (`%`) was removed from the **Growth** column.

After cleaning the values, the affected columns were converted from **TEXT** to their appropriate numeric datatypes using the `ALTER TABLE` and `MODIFY COLUMN` statements.

This preparation ensured that all subsequent calculations and statistical analyses could be performed accurately.

```sql
SELECT population,
       REPLACE(population, ',', '')
FROM newpopulation_data;

UPDATE newpopulation_data
SET population = REPLACE(population, ',', '');

ALTER TABLE newpopulation_data
MODIFY COLUMN population INT;
```

📸 **Data Cleaning**

![cleaning 1](../SQL%20Projects%20Images/Indian%20Census%20Project%20Images/cleaning%201.png)

![cleaning 2](../SQL%20Projects%20Images/Indian%20Census%20Project%20Images/cleaning%202.png)

![cleaning 3](../SQL%20Projects%20Images/Indian%20Census%20Project%20Images/cleaning%203.png)

![cleaning 4](../SQL%20Projects%20Images/Indian%20Census%20Project%20Images/cleaning%204.png)

# Exploratory Data Analysis (EDA)

After preparing and cleaning both datasets, the next stage of the project was **Exploratory Data Analysis (EDA)**. The analysis began with fundamental demographic statistics before progressing to more advanced calculations involving joins, Common Table Expressions (CTEs), subqueries, and mathematical derivations.

The initial analyses focused on understanding India's population distribution, growth patterns, literacy levels, and sex ratios across different states.

---

# Total Number of Records

The first step was to verify that both datasets contained the same number of records.

```sql
SELECT COUNT(*) AS Total_Records
FROM population_data;

SELECT COUNT(*) AS Record_Count
FROM newpopulation_data;
```

📸 **Total Records**

![record count](../SQL%20Projects%20Images/Indian%20Census%20Project%20Images/record%20count.png)

![hhh](../SQL%20Projects%20Images/Indian%20Census%20Project%20Images/hhh.png)

Both datasets contained **640 records**, confirming that the two tables could be joined reliably using their common fields.

---

# Records from Specific States

To verify the quality of the data and demonstrate data filtering, records belonging to specific states were retrieved.

```sql
SELECT *
FROM population_data
WHERE state IN ('Jharkhand','Bihar')
ORDER BY state;
```

📸 **Specific States**

![specific states](../SQL%20Projects%20Images/Indian%20Census%20Project%20Images/specific%20states.png)

This query demonstrates how SQL filtering can be used to retrieve records belonging to selected states for further analysis.

---

# Total Population of India

The total population of India was calculated by summing the population values from the **newpopulation_data** table.

```sql
SELECT SUM(population) AS Total_Population
FROM newpopulation_data;
```

📸 **Total Population**

![total population](../SQL%20Projects%20Images/Indian%20Census%20Project%20Images/total%20population.png)


The analysis showed that India's total population in the **2011 Census** was approximately **1.21 billion** people.

---

# Average Population Growth

The average population growth across all districts was calculated using the **AVG()** aggregate function.

```sql
SELECT ROUND(AVG(growth),2) AS Average_Growth
FROM population_data;
```

📸 **Average Growth**

![average growth](../SQL%20Projects%20Images/Indian%20Census%20Project%20Images/average%20growth.png)

The average population growth recorded across the dataset was **19.25%**, indicating significant population growth between census periods.

---

# Average Growth by State

Population growth was then analysed at the state level to identify regions experiencing the fastest and slowest growth.

```sql
SELECT state,
       ROUND(AVG(growth),2) AS Average_Growth_By_State
FROM population_data
GROUP BY state
ORDER BY Average_Growth_By_State DESC;
```

📸 **Average Growth by State**

![state growth](../SQL%20Projects%20Images/Indian%20Census%20Project%20Images/state%20growth.png)


The analysis revealed noticeable differences in growth rates across states. **Nagaland** recorded the highest average growth, while **Andaman and Nicobar Islands** recorded one of the lowest average growth rates.

Population growth can be influenced by several factors, including birth rates, death rates, and migration patterns, making this analysis useful for understanding regional demographic changes.

---

# Average Sex Ratio by State

The average sex ratio was calculated for every state to examine the balance between male and female populations.

```sql
SELECT state,
       ROUND(AVG(sex_ratio),0) AS Average_Sex_Ratio
FROM population_data
GROUP BY state
ORDER BY Average_Sex_Ratio DESC;
```

📸 **Average Sex Ratio**

![average sex](../SQL%20Projects%20Images/Indian%20Census%20Project%20Images/average%20sex.png)


In the Indian census, a sex ratio of **1000** generally represents a balanced population.

- Values **above 1000** indicate more females than males.
- Values **below 1000** indicate more males than females.

The analysis showed that **Kerala** recorded the highest average sex ratio, indicating a higher female population relative to males.

---

# Literacy Analysis

The literacy rate was analysed to identify states with highly educated populations.

```sql
SELECT state,
       ROUND(AVG(literacy),0) AS Average_Literacy
FROM population_data
GROUP BY state
HAVING Average_Literacy > 90
ORDER BY Average_Literacy DESC;
```

📸 **Average Literacy**

![greater literacy ratio](../SQL%20Projects%20Images/Indian%20Census%20Project%20Images/greater%20literacy%20ratio.png)


Only **Kerala** and **Lakshadweep** recorded an average literacy rate above **90%**, highlighting their strong educational outcomes relative to other states.

---

# Top and Bottom Performing States

Several additional analyses were performed to compare states based on different demographic indicators.

These included:

- Top 3 states with the highest average growth rate.
- Bottom 3 states with the lowest average sex ratio.
- Top 3 and bottom 3 states by average literacy rate using the **UNION ALL** operator.

📸 **Top & Bottom States**

![state literacy](../SQL%20Projects%20Images/Indian%20Census%20Project%20Images/state%20literacy.png)

These comparisons make it easier to identify demographic differences across India's states and highlight regions that stand out in terms of growth, literacy, and gender distribution.

---

# Pattern Matching with SQL

The project also demonstrated SQL pattern matching using the **LIKE** operator.

Examples included:

- States beginning with the letters **A** or **B**.
- States beginning with **A** and ending with **M**.

```sql
SELECT DISTINCT state
FROM population_data
WHERE state LIKE 'a%'
   OR state LIKE 'b%';

SELECT DISTINCT state
FROM population_data
WHERE state LIKE 'a%'
  AND state LIKE '%m';
```

📸 **Pattern Matching**

![pattern match 1](../SQL%20Projects%20Images/Indian%20Census%20Project%20Images/pattern%20match%201.png)


![pattern match 2](../SQL%20Projects%20Images/Indian%20Census%20Project%20Images/pattern%20match%202.png)

Although simple, these queries demonstrate how SQL pattern matching can be used to filter textual data efficiently.

# Male & Female Population Analysis

One of the most interesting challenges in this project was that the datasets contained **population** and **sex ratio**, but they did **not** contain separate columns for the number of males and females.

To solve this problem, both datasets were combined using a SQL **JOIN**, after which mathematical formulas were derived to estimate the male and female population for every district and state.

This demonstrates how SQL can be used not only to analyse existing data but also to derive entirely new metrics from available information.

---

# Male & Female Population by District

To estimate the male and female population for each district, the following information was required:

- State
- District
- Sex Ratio
- Population

Since these columns were spread across two different tables, an **INNER JOIN** was performed before carrying out the calculations.

### Formula Derivation

![formula 1](../SQL%20Projects%20Images/Indian%20Census%20Project%20Images/formula%201.png)

The formulas above were then implemented in SQL.


```sql
SELECT state,
       district,
       male_count,
       ROUND(population - male_count) AS female_count
FROM
(
SELECT district,
       state,
       population,
       ROUND(population/(sex_ratio+1)) AS male_count
FROM
(
SELECT pd.district,
       pd.state,
       pd.sex_ratio/1000 AS sex_ratio,
       npd.population
FROM population_data pd
INNER JOIN newpopulation_data npd
ON pd.district=npd.district
)a
)b
ORDER BY state;
```

📸 **Male & Female Population by District**

![population by district](../SQL%20Projects%20Images/Indian%20Census%20Project%20Images/population%20by%20district.png)


The final result estimated the male and female population for every district while keeping districts from the same state grouped together for easier interpretation.

---

# Male & Female Population by State

The same approach was extended to calculate the total male and female population for each state.

Instead of displaying district-level results, the calculated values were aggregated using the **SUM()** function to produce state-level totals.

```sql
SELECT state,
       SUM(male_count) AS Males,
       SUM(female_count) AS Females
FROM
(
SELECT state,
       male_count,
       (population-male_count) AS female_count
FROM
(
SELECT state,
       population,
       ROUND(population/(sex_ratio+1)) AS male_count
FROM
(
SELECT pd.state,
       pd.sex_ratio/1000 AS sex_ratio,
       npd.population
FROM population_data pd
INNER JOIN newpopulation_data npd
ON pd.district=npd.district
)a
)b
)c
GROUP BY state
ORDER BY Males DESC;
```

📸 **Male & Female Population by State**

![population by state](../SQL%20Projects%20Images/Indian%20Census%20Project%20Images/population%20by%20state.png)



The analysis showed that **Uttar Pradesh** recorded the highest estimated male population and also the highest estimated female population, reflecting its position as India's most populous state in the 2011 census.

This analysis demonstrates how SQL joins, mathematical derivations, nested subqueries, and aggregate functions can be combined to estimate demographic information that was not explicitly available in the original datasets.

# Literacy Analysis

The datasets contained the **literacy rate** for each district but did not provide the actual number of **literate** and **illiterate** people.

To estimate these figures, data from both tables had to be combined using a SQL **JOIN** before applying mathematical formulas. This section demonstrates how SQL can be used to transform percentages into meaningful population estimates.

---

# Literacy by District

To calculate the total number of literate and illiterate people for each district, the following fields were required:

- State
- District
- Literacy Rate
- Population

Since these columns existed across two different tables, they were first combined using a SQL **JOIN**.

### Formula Derivation

The literacy rate represents the proportion of literate people within a district's population.

Therefore,

![formula 2](../SQL%20Projects%20Images/Indian%20Census%20Project%20Images/formula%202.png)







These formulas were implemented using a Common Table Expression (CTE).

```sql
WITH literacy_ratio_cte AS
(
SELECT pd.district,
       pd.state,
       pd.literacy/100 AS literacy_ratio,
       npd.population
FROM population_data pd
JOIN newpopulation_data npd
ON pd.district=npd.district
)

SELECT state,
       district,
       ROUND(literacy_ratio*population) AS literate_people,
       ROUND((1-literacy_ratio)*population) AS illiterate_people
FROM literacy_ratio_cte
ORDER BY state;
```

📸 **Literacy by District**

![literacy by district](../SQL%20Projects%20Images/Indian%20Census%20Project%20Images/literacy%20by%20district.png)

The results estimated the number of literate and illiterate residents for every district while keeping districts from the same state grouped together for easier interpretation.

---

# Literacy by State

The same methodology was then extended to the state level.

Instead of analysing individual districts, the calculated values were aggregated using the **SUM()** function to estimate the total number of literate and illiterate people in each state.

```sql
SELECT state,
       SUM(literate_people) AS Total_Literates,
       SUM(illiterate_people) AS Total_Illiterates
FROM
(
WITH literacy_ratio_cte AS
(
SELECT pd.district,
       pd.state,
       pd.literacy/100 AS literacy_ratio,
       npd.population
FROM population_data pd
JOIN newpopulation_data npd
ON pd.district=npd.district
)

SELECT state,
       ROUND(literacy_ratio*population) AS literate_people,
       ROUND((1-literacy_ratio)*population) AS illiterate_people
FROM literacy_ratio_cte
)a
GROUP BY state
ORDER BY Total_Literates DESC;
```

📸 **Literacy by State**

![literacy by state](../SQL%20Projects%20Images/Indian%20Census%20Project%20Images/literacy%20by%20state.png)

The analysis revealed that **Uttar Pradesh** had the highest estimated number of literate residents. This is largely influenced by the state's large population, making it the leading contributor to India's total literate population despite variations in literacy percentages across states.

This section demonstrates the practical use of **CTEs, joins, aggregate functions, mathematical calculations, and subqueries** to derive valuable demographic insights that were not directly available in the original datasets.

# Previous Census & Land Per Capita Analysis

One of the most advanced sections of this project was estimating India's **previous census population**. The dataset only contained the population recorded during the **2011 Census**, so the population from the previous census had to be estimated mathematically using the available population growth data.

This section combines SQL joins, subqueries, aggregate functions, and mathematical calculations to reconstruct historical population figures and perform land per capita analysis.

---

# Previous Census Population by District

The datasets did not contain the population recorded during the previous census. To estimate it, the following fields were required:

- State
- District
- Population
- Growth Rate

Since these columns were stored across two different tables, they were first combined using an **INNER JOIN**.

### Formula Derivation

The relationship between the previous census population and the current population can be expressed as:

![formula 3](../SQL%20Projects%20Images/Indian%20Census%20Project%20Images/formula%203.png)

This formula was implemented in SQL to estimate the population recorded during the previous census for every district.

```sql
SELECT state,
       district,
       ROUND(population/(1+growth)) AS previous_census_population,
       population AS current_census_population
FROM
(
SELECT pd.district,
       pd.state,
       pd.growth/100 AS growth,
       npd.population
FROM population_data pd
JOIN newpopulation_data npd
ON pd.district=npd.district
)a
ORDER BY state;
```

📸 **Previous Census by District**

![previous census district](../SQL%20Projects%20Images/Indian%20Census%20Project%20Images/previous%20census%20districts.png)

The analysis estimated both the previous and current census population for every district, making it possible to compare demographic changes over time.

Interestingly, while most districts experienced population growth, a small number recorded a decline between census periods, highlighting regional demographic variations.

---

# Previous Census Population by State

The district-level calculations were then aggregated to estimate the previous and current census populations for each state.

```sql
SELECT state,
       SUM(previous_census_population) AS Previous_Census_Population,
       SUM(current_census_population) AS Current_Census_Population
FROM (...)
GROUP BY state
ORDER BY Previous_Census_Population DESC;
```

📸 **Previous Census by State**

![previous census state](../SQL%20Projects%20Images/Indian%20Census%20Project%20Images/previous%20census%20state.png)

The results showed that **Uttar Pradesh** had the highest estimated population in both the previous and current census, reflecting its position as India's most populous state.

---

# India's Population Growth Between Census Years

The same calculation was extended to estimate India's total population across both census periods.

```sql
SELECT SUM(previous_census_population) AS Previous_Census_Population,
       SUM(current_census_population) AS Current_Census_Population
FROM (...);
```

📸 **India Population Comparison**

![census comparison](../SQL%20Projects%20Images/Indian%20Census%20Project%20Images/census%20comparison.png)

The analysis estimated India's population at approximately:

- **Previous Census:** 1.01 Billion
- **Current Census (2011):** 1.19 Billion

This represents an increase of approximately **179 million people** between the two census periods, illustrating the significant population growth experienced over the decade.

---

# Land Per Capita Analysis

This section examined how much land would theoretically be available per person if India's total land area were distributed evenly across its population.

The calculation combined:

- Total land area
- Previous census population
- Current census population

```sql
SELECT
ROUND((total_land_area_km2/previous_census_population),4) AS previous_census_land_per_capita,
(total_land_area_km2/current_census_population) AS current_census_land_per_capita
FROM (...);
```

📸 **Land Per Capita Analysis**
![capita analysis](../SQL%20Projects%20Images/Indian%20Census%20Project%20Images/capita%20analysis.png)


The analysis showed that land available per person decreased from the previous census to the 2011 census. As population increases while total land area remains unchanged, the amount of land available per individual naturally declines.

This section demonstrates how SQL can be used not only to analyse existing datasets but also to reconstruct historical information and generate meaningful demographic indicators through mathematical modelling.

# Top 3 Districts by Literacy Rate in Each State

The final analysis in this project focused on identifying the **three most literate districts within every state**. Unlike the previous analyses, this task required ranking districts independently inside each state rather than across the entire dataset.

To achieve this, a **Common Table Expression (CTE)** and the **`RANK()` window function** were used. The `PARTITION BY` clause grouped the districts by state, while the ranking was assigned based on the literacy rate in descending order.

```sql
WITH literacy_cte AS
(
SELECT state,
       district,
       literacy,
       RANK() OVER(PARTITION BY state ORDER BY literacy DESC) AS literacy_rank
FROM population_data
)

SELECT *
FROM literacy_cte
WHERE literacy_rank <= 3;
```

📸 **Top 3 Districts by Literacy Rate**

![hlr](../SQL%20Projects%20Images/Indian%20Census%20Project%20Images/hlr.png)


![hlr2](../SQL%20Projects%20Images/Indian%20Census%20Project%20Images/hlr2.png)


This analysis identified the three districts with the highest literacy rate within each state, making it easier to compare educational performance at a district level while ensuring every state was represented fairly.

---

# Key Insights

Some of the major insights obtained from this analysis include:

- India's population in the 2011 census was approximately **1.21 billion** people.
- The average population growth across districts was approximately **19.25%**.
- **Kerala** recorded the highest average sex ratio among all states.
- Only **Kerala** and **Lakshadweep** recorded an average literacy rate above **90%**.
- **Uttar Pradesh** had the largest estimated male population, female population, and literate population.
- India's population increased by approximately **179 million** people between the previous census and the 2011 census.
- Land available per person decreased as the country's population continued to grow.
- Window functions made it possible to rank districts independently within each state based on literacy rate.

---

# SQL Concepts Demonstrated

Throughout this project, the following SQL concepts were applied:

- Database Creation
- Table Renaming
- Data Cleaning
- `UPDATE`
- `ALTER TABLE`
- `MODIFY COLUMN`
- `REPLACE()`
- Aggregate Functions (`SUM`, `AVG`, `COUNT`)
- `GROUP BY`
- `ORDER BY`
- `HAVING`
- `DISTINCT`
- `LIKE`
- `LIMIT`
- `INNER JOIN`
- Common Table Expressions (CTEs)
- Nested Subqueries
- `UNION ALL`
- Mathematical Derivations
- Window Functions (`RANK()`)

---

# Conclusion

This project demonstrates how SQL can be used to transform raw census data into meaningful demographic insights. Starting with two independent datasets, the project involved cleaning inconsistent data, combining tables through joins, deriving new demographic metrics, reconstructing historical population estimates, and performing advanced analytical calculations.

Beyond answering standard SQL queries, the project showcases the ability to solve real-world analytical problems by combining SQL with mathematical reasoning. It highlights practical applications of joins, CTEs, subqueries, aggregate functions, and window functions to extract insights that were not explicitly available in the original datasets.

Overall, this project strengthened my understanding of data cleaning, demographic analysis, and advanced SQL techniques while demonstrating how SQL can be used as a powerful tool for solving complex analytical problems.


---


📊💻