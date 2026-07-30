# 👥 Human Resources Employee Distribution Analysis Using SQL and Power BI

## 📌 Project Overview

This project focuses on analyzing a human resources dataset containing employee demographic, employment, departmental, and location information. The project combines **SQL** for data cleaning, transformation, and exploratory data analysis with **Power BI** for data visualization and reporting.

The results of the analyses were exported as **CSV files** and subsequently imported into Power BI through Power Query's folder import functionality. The results were visualized in the final two-page Power BI report, titled **HR Employee Distribution Report**.

The project followed an end-to-end analytical workflow:

**HR Dataset → SQL Data Cleaning & Transformation → Exploratory Data Analysis with SQL → Exported SQL Query Results → Power Query Folder Import → Power BI Report**

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

## 🛠️ Tools Used

- **MySQL** — Database creation, data cleaning, data transformation, and exploratory data analysis.
- **MySQL Workbench** — Writing and executing SQL queries and exporting query results.
- **Power Query** — Importing the folder containing the exported SQL query results.
- **Power BI** — Creating the two-page employee distribution report.

---

## 📂 Dataset Overview

The project used a dataset containing employee records across different departments, job titles, demographic groups, work locations, cities, and states.

The main fields in the dataset included:

- `id`
- `first_name`
- `last_name`
- `birthdate`
- `gender`
- `race`
- `department`
- `jobtitle`
- `location`
- `hire_date`
- `termdate`
- `location_city`
- `location_state`

### 📸 Dataset — Part 1

![raw data 1](../SQL%20Projects%20Images/Human%20Resources%20Project%20Images/raw%20data%201.png)


### 📸 Dataset — Part 2

![raw data 2](../SQL%20Projects%20Images/Human%20Resources%20Project%20Images/raw%20data%202.png)

The dataset required several cleaning and transformation steps before analysis. These included correcting the employee ID column, converting inconsistent date formats, transforming termination dates, calculating employee ages, and removing records with invalid age values.

---

## 🎯 Project Objectives

The main objectives of this project were to:

- Clean and transform employee data using SQL.
- Explore employee demographics across gender, race, and age groups.
- Analyze the distribution of employees across departments, job titles, work arrangements, cities, and states.
- Calculate the average employment length of terminated employees.
- Identify departmental turnover rates and tenure patterns.
- Examine how the company's employee count changed over time based on hires and terminations.
- Export SQL analysis results and use them as data sources for a two-page Power BI report.
- Present important workforce insights through clear and effective visualizations.

---
# Data Cleaning and Transformation

After importing the dataset into MySQL using the **Table Data Import Wizard**, the table was renamed from `human resources` to `hr` to make it easier to reference throughout the project.

```sql
-- Creating the database
CREATE SCHEMA projects;

-- Making the database the default database
USE projects;

-- Renaming the table
ALTER TABLE `human resources` RENAME TO hr;
```

### 📸 Database Creation and Table Setup

![db creation](../SQL%20Projects%20Images/Human%20Resources%20Project%20Images/db%20creation.png)

The dataset contained several issues that needed to be addressed before performing exploratory data analysis. These included an incorrectly encoded employee ID column name, inconsistent date formats, termination dates stored as datetime text, blank termination values, and invalid employee ages.

---

## 🔹 Cleaning the Employee ID Column

The original employee ID column appeared as `ï»¿id`, caused by an encoding artifact in the imported CSV file. It was renamed to `emp_id`, and its data type was changed to `VARCHAR(20)`.

```sql
ALTER TABLE hr RENAME COLUMN ï»¿id TO emp_id;

ALTER TABLE hr MODIFY COLUMN emp_id VARCHAR(20);
```

### 📸 Employee ID Column Cleaning

![empid1](../SQL%20Projects%20Images/Human%20Resources%20Project%20Images/empid1.png)

![empid2](../SQL%20Projects%20Images/Human%20Resources%20Project%20Images/empid2.png)

---

## 🔹 Transforming the Birth Date Column

The `birthdate` column was originally stored as text and contained two different date formats:

- `DD-MM-YYYY`
- `MM/DD/YYYY`

The `STR_TO_DATE()` function was used to convert both formats into valid SQL dates before changing the column's data type from text to `DATE`.

```sql
UPDATE hr
SET birthdate = STR_TO_DATE(birthdate, "%d-%m-%Y")
WHERE birthdate LIKE "%-%";

UPDATE hr
SET birthdate = STR_TO_DATE(birthdate, "%m/%d/%Y")
WHERE birthdate LIKE "%/%";

ALTER TABLE hr MODIFY COLUMN birthdate DATE;
```

### 📸 Birth Date Transformation
![bd1](../SQL%20Projects%20Images/Human%20Resources%20Project%20Images/bd1.png)

![bd2](../SQL%20Projects%20Images/Human%20Resources%20Project%20Images/bd2.png)

---

## 🔹 Transforming the Hire Date Column

The `hire_date` column had the same issue as the `birthdate` column, with dates stored in two different text formats. The same transformation process was therefore applied.

```sql
UPDATE hr
SET hire_date = STR_TO_DATE(hire_date, "%d-%m-%Y")
WHERE hire_date LIKE "%-%";

UPDATE hr
SET hire_date = STR_TO_DATE(hire_date, "%m/%d/%Y")
WHERE hire_date LIKE "%/%";

ALTER TABLE hr MODIFY COLUMN hire_date DATE;
```

### 📸 Hire Date Transformation

![hd1](../SQL%20Projects%20Images/Human%20Resources%20Project%20Images/hd1.png)

![hd2](../SQL%20Projects%20Images/Human%20Resources%20Project%20Images/hd2.png)

---

## 🔹 Cleaning the Termination Date Column

The `termdate` column required additional transformation because populated records were stored as datetime strings containing a `UTC` suffix, while employees without termination dates had blank values.

For example:

```text
2025-05-15 06:10:15 UTC
```

The `STR_TO_DATE()` function was first used to convert the text into a valid datetime value, while the `DATE()` function extracted only the date portion.

```sql
UPDATE hr
SET termdate = DATE(STR_TO_DATE(termdate, "%Y-%m-%d %H:%i:%s UTC"))
WHERE termdate IS NOT NULL
AND termdate <> "";
```

Blank and null termination dates were then populated with `0000-00-00` to represent employees without a recorded termination date.

```sql
UPDATE hr
SET termdate = "0000-00-00"
WHERE termdate IS NULL
OR termdate = "";
```

The SQL mode was temporarily adjusted to allow zero-date values before converting the column to the `DATE` data type.

```sql
SET sql_mode = "no_engine_substitution,no_zero_in_date";

ALTER TABLE hr MODIFY COLUMN termdate DATE NULL;
```

### 📸 Termination Date Transformation

![td1](../SQL%20Projects%20Images/Human%20Resources%20Project%20Images/td1.png)

![td2](../SQL%20Projects%20Images/Human%20Resources%20Project%20Images/td2.png)

---

## 🔹 Calculating Employee Ages

An `Age` column was added to the `hr` table, and each employee's age was calculated using the difference between the current year and birth year.

```sql
ALTER TABLE hr ADD COLUMN Age INT;

UPDATE hr
SET age = YEAR(CURRENT_DATE) - YEAR(birthdate);
```

After calculating employee ages, some records contained age values below 18, including negative values. Since these represented invalid records for the employee analysis, they were removed from the dataset.

```sql
DELETE FROM hr
WHERE age < 18;
```

### 📸 Employee Age Calculation and Invalid Record Removal

![age1](../SQL%20Projects%20Images/Human%20Resources%20Project%20Images/age1.png)

![age2](../SQL%20Projects%20Images/Human%20Resources%20Project%20Images/age2.png)

---

## 📌 Data Cleaning Summary

The data cleaning and transformation process successfully:

- Renamed the incorrectly encoded employee ID column.
- Changed the employee ID data type to `VARCHAR(20)`.
- Standardized two different date formats in the `birthdate` column.
- Standardized two different date formats in the `hire_date` column.
- Converted termination datetime strings into valid SQL dates.
- Handled blank and null termination dates.
- Added and calculated employee ages.
- Removed records containing invalid employee ages below 18.

After completing these transformations, the dataset was ready for **Exploratory Data Analysis (EDA)**.

# 📊 Exploratory Data Analysis

After completing the data cleaning and transformation process, the next stage of the project was **Exploratory Data Analysis (EDA)**. This section focused on understanding the company's workforce demographics, including gender, race, age distribution, work location, and the average length of employment for terminated employees.

For analyses involving active employees, records with a termination date of `0000-00-00` were used.

---

## 🔍 Key Analytical Questions

The SQL exploratory data analysis focused on answering the following questions:

1. What is the gender breakdown of employees in the company?
2. What is the race and ethnicity breakdown of employees?
3. What is the age distribution of employees?
4. How many employees work at headquarters versus remote locations?
5. What is the average length of employment for employees who have been terminated?
6. How does gender distribution vary across departments and job titles?
7. What is the distribution of job titles across the company?
8. Which department has the highest turnover rate?
9. How are employees distributed across locations by city and state?
10. How has the company's employee count changed over time based on hire and termination dates?
11. What is the average tenure distribution across departments?


## ⚠️ Important Note on SQL Mode

During the data cleaning process, blank and null values in the `termdate` column were replaced with `0000-00-00` to represent employees without a recorded termination date. Since MySQL may reject zero-date values depending on the active SQL mode, the following statement should be executed before running the EDA queries:

```sql
SET sql_mode = "no_engine_substitution,no_zero_in_date";
```

This ensures that queries using `termdate = "0000-00-00"` to identify active employees can run without errors.


## 🔹 Gender Distribution

The first analysis examined the gender breakdown of active employees in the company.

```sql
SELECT gender,
       COUNT(emp_id) AS employee_count
FROM hr
WHERE termdate = "0000-00-00"
GROUP BY gender;
```

The analysis showed that the company had:

- **8,911 male employees**
- **8,090 female employees**
- **481 non-conforming employees**

Male employees represented the largest gender group in the organization, followed by female employees and then non-conforming employees.

### 📸 Gender Distribution

![gend](../SQL%20Projects%20Images/Human%20Resources%20Project%20Images/gend.png)

---

## 🔹 Race and Ethnicity Distribution

The next analysis examined the racial and ethnic composition of the company's active workforce.

```sql
SELECT race,
       COUNT(emp_id) AS employee_count
FROM hr
WHERE termdate = "0000-00-00"
GROUP BY race
ORDER BY employee_count DESC;
```

**White employees** formed the largest racial group within the organization. This was followed by employees identified as **Two or More Races** with approximately **2,867 employees**, while **Black or African American employees** ranked third with approximately **2,840 employees**.

The smallest group was **Native Hawaiian or Other Pacific Islander**, with approximately **952 employees**.

Overall, the results showed that the organization's workforce consisted of employees from several racial and ethnic backgrounds.

### 📸 Race and Ethnicity Distribution

![race distribution](../SQL%20Projects%20Images/Human%20Resources%20Project%20Images/race%20distribution.png)

---

## 🔹 Age Distribution

To understand the age composition of the workforce, active employees were divided into five age groups:

- `18-24`
- `25-34`
- `35-44`
- `45-54`
- `55-64`

A `CASE` statement was used to classify each employee into the appropriate age group.

```sql
SELECT
    CASE
        WHEN age BETWEEN 18 AND 24 THEN "18-24"
        WHEN age BETWEEN 25 AND 34 THEN "25-34"
        WHEN age BETWEEN 35 AND 44 THEN "35-44"
        WHEN age BETWEEN 45 AND 54 THEN "45-54"
        WHEN age BETWEEN 55 AND 64 THEN "55-64"
    END AS age_group,
    COUNT(emp_id) AS employee_count
FROM hr
WHERE termdate = "0000-00-00"
GROUP BY age_group
ORDER BY age_group;
```

The results showed the following distribution:

| Age Group | Employee Count |
|-----------|---------------:|
| 18-24 | 331 |
| 25-34 | 4,941 |
| 35-44 | 5,085 |
| 45-54 | 4,838 |
| 55-64 | 2,287 |

The **35-44 age group** contained the highest number of employees, closely followed by the **25-34** and **45-54** groups. In contrast, employees between **18 and 24 years old** represented the smallest age group, with only 331 employees.

This could suggest that the organization employs relatively few people at the earliest stage of their careers, although additional recruitment data would be required to determine the exact reason for this pattern.

### 📸 Age Distribution

![age distribution](../SQL%20Projects%20Images/Human%20Resources%20Project%20Images/age%20distribution.png)
---

## 🔹 Gender Distribution Across Age Groups

The age analysis was extended further by examining the distribution of gender within each age group.

```sql
SELECT
    CASE
        WHEN age BETWEEN 18 AND 24 THEN "18-24"
        WHEN age BETWEEN 25 AND 34 THEN "25-34"
        WHEN age BETWEEN 35 AND 44 THEN "35-44"
        WHEN age BETWEEN 45 AND 54 THEN "45-54"
        WHEN age BETWEEN 55 AND 64 THEN "55-64"
    END AS age_group,
    gender,
    COUNT(emp_id) AS employee_count
FROM hr
WHERE termdate = "0000-00-00"
GROUP BY age_group, gender
ORDER BY age_group, employee_count DESC;
```

### 📸 Gender Distribution Across Age Groups

![aggd](../SQL%20Projects%20Images/Human%20Resources%20Project%20Images/aggd.png)

This provided a more detailed view of the company's workforce by showing how male, female, and non-conforming employees were distributed across the different age groups.

---

## 🔹 Headquarters vs Remote Employees

The next analysis examined how many active employees worked at the company's headquarters compared with remote locations.

```sql
SELECT DISTINCT location,
       COUNT(emp_id) OVER(PARTITION BY location) AS employee_count
FROM hr
WHERE termdate = "0000-00-00";
```

The results showed:

| Work Location | Employee Count |
|---------------|---------------:|
| Headquarters | 13,107 |
| Remote | 4,375 |

Approximately **75% of active employees worked at headquarters**, while the remaining **25% worked remotely**.

Further examination of the data showed that many remote employees were located outside the company's headquarters city of **Cleveland, Ohio**. However, remote work was not limited exclusively to employees outside Cleveland, as approximately **151 employees based in Cleveland also worked remotely**.

### 📸 Headquarters vs Remote Employees

![location](../SQL%20Projects%20Images/Human%20Resources%20Project%20Images/location.png)

---

## 🔹 Average Length of Employment for Terminated Employees

The dataset contained some termination dates that were in the future. To avoid including employees who had not yet been terminated as of the analysis date, only records where the termination date was less than or equal to the current date were included.

A Common Table Expression (CTE) was used to calculate the length of employment for each terminated employee before determining the overall average.

```sql
WITH average_employment_years_cte AS
(
    SELECT termdate,
           hire_date,
           DATEDIFF(termdate, hire_date) / 365 AS length_of_employment_in_years
    FROM
    (
        SELECT *
        FROM hr
        WHERE termdate NOT LIKE "%0000-00%"
          AND termdate <= CURRENT_DATE
    ) a
)

SELECT ROUND(AVG(length_of_employment_in_years), 0)
       AS average_employment_years
FROM average_employment_years_cte;
```

The analysis showed that employees who had been terminated worked at the company for an average of approximately **8 years** before leaving.

This suggests a relatively substantial average employment duration among terminated employees, although additional information about employee satisfaction, voluntary resignations, and reasons for termination would be needed to evaluate overall workforce stability.

### 📸 Average Length of Employment

![ale](../SQL%20Projects%20Images/Human%20Resources%20Project%20Images/ale.png)
---

The demographic and workforce distribution analysis provided a clearer understanding of the company's active employees, including their gender, race, age, work arrangements, and employment duration.


---

## 🔹 Gender Distribution Across Departments and Job Titles

This analysis examined how gender distribution varied across different departments and job titles within the organization.

### Gender Distribution by Department

A window function was used to count active employees by gender within each department.

```sql
SELECT DISTINCT department,
       gender,
       COUNT(emp_id) OVER(PARTITION BY department, gender) AS employee_count
FROM hr
WHERE termdate = "0000-00-00"
ORDER BY department, employee_count DESC;
```

The results showed that male employees formed the largest gender group in most departments. However, female employees had a higher representation in departments such as **Marketing** and **Research and Development**, while the **Auditing** department had an almost equal distribution between male and female employees.

### 📸 Gender Distribution by Department

![gdd](../SQL%20Projects%20Images/Human%20Resources%20Project%20Images/gdd.png)

### Gender Distribution by Job Title

The analysis was also extended to individual job titles.

```sql
SELECT DISTINCT jobtitle,
       gender,
       COUNT(emp_id) OVER(PARTITION BY jobtitle, gender) AS employee_count
FROM hr
WHERE termdate = "0000-00-00"
ORDER BY jobtitle, employee_count DESC;
```

This provided a more detailed view of gender representation across specific roles within the company.

### 📸 Gender Distribution by Job Title

![jjj](../SQL%20Projects%20Images/Human%20Resources%20Project%20Images/jjj.png)

---

## 🔹 Job Title Distribution

The next analysis examined how active employees were distributed across the various job titles in the organization.

```sql
SELECT jobtitle,
       COUNT(emp_id) AS employee_count
FROM hr
WHERE termdate = "0000-00-00"
GROUP BY jobtitle
ORDER BY employee_count DESC;
```

The five most common job titles were:

| Job Title | Employee Count |
|---|---:|
| Research Assistant II | 608 |
| Business Analyst | 552 |
| Human Resources Analyst II | 477 |
| Research Assistant I | 408 |
| Account Executive | 386 |

**Research Assistant II** was the most common job title in the organization, followed by **Business Analyst** and **Human Resources Analyst II**.

Although the result of this analysis was exported to a CSV file and imported into Power BI, it was **not included as a visual in the final two-page report**.

### 📸 Job Title Distribution

![job distribution](../SQL%20Projects%20Images/Human%20Resources%20Project%20Images/job%20distribution.png)

---

## 🔹 Departmental Turnover Rate

The next question was to identify which department had the highest turnover rate.

For this analysis, the turnover rate was calculated as:

**Turnover Rate = Number of Terminated Employees in a Department ÷ Total Number of Employees in that Department**

Only employees whose termination dates were less than or equal to the current date were counted as terminated employees, preventing future termination dates from affecting the analysis.

```sql
WITH turnover_cte AS
(
    SELECT a.*,
           b.total_count
    FROM
    (
        SELECT department,
               COUNT(emp_id) AS terminated_count
        FROM
        (
            SELECT *
            FROM hr
            WHERE termdate <> "0000-00-00"
              AND termdate <= CURRENT_DATE()
        ) a
        GROUP BY department
    ) a
    INNER JOIN
    (
        SELECT department,
               COUNT(emp_id) AS total_count
        FROM hr
        GROUP BY department
    ) b
    ON a.department = b.department
)

SELECT *,
       terminated_count / total_count AS termination_rate
FROM turnover_cte
ORDER BY termination_rate DESC;
```

The analysis showed that **Auditing** had the highest turnover rate, followed by **Legal**, **Marketing**, **Product Management**, and **Support**.

This comparison helps identify departments with relatively high proportions of terminated employees. However, further information about voluntary resignations, dismissals, retirement, and other reasons for departure would be required to fully explain the differences between departments.

### 📸 Departmental Turnover Rate

![turnover rate](../SQL%20Projects%20Images/Human%20Resources%20Project%20Images/turnover%20rate.png)

---

## 🔹 Employee Distribution by Location

The geographical analysis examined how active employees were distributed across cities and states.

```sql
SELECT location,
       location_state,
       location_city,
       COUNT(emp_id) AS employee_count
FROM hr
WHERE termdate = "0000-00-00"
GROUP BY location, location_state, location_city
ORDER BY employee_count DESC;
```

The analysis was then summarized at the state level:

```sql
SELECT location_state,
       COUNT(emp_id) AS employee_count
FROM hr
WHERE termdate = "0000-00-00"
GROUP BY location_state
ORDER BY employee_count DESC;
```

The dataset contained employees across **seven states**, ranked from highest to lowest employee count as follows:

1. Ohio
2. Pennsylvania
3. Illinois
4. Michigan
5. Indiana
6. Kentucky
7. Wisconsin

**Ohio** had the highest number of employees, which aligns with the fact that the company's headquarters is located in **Cleveland, Ohio**.

### 📸 Employee Distribution by City and State

![employee distribution](../SQL%20Projects%20Images/Human%20Resources%20Project%20Images/employee%20distribution.png)

### 📸 Employee Distribution by State

![employee state](../SQL%20Projects%20Images/Human%20Resources%20Project%20Images/employee%20state.png)
---

## 🔹 Change in Employee Numbers Over Time

The next analysis examined how the company's employee count changed over time by comparing hires and terminations for each year.

For every year, the following metrics were calculated:

- Number of hires
- Number of terminations
- Net change in employees
- Net change percentage

The net change was calculated by subtracting terminations from hires, while the percentage was calculated by dividing the net change by the number of hires and multiplying by 100.

```sql
WITH net_change_cte AS
(
    SELECT a.year,
           a.hires,
           b.terminations
    FROM
    (
        SELECT YEAR(hire_date) AS year,
               COUNT(emp_id) AS hires
        FROM hr
        WHERE termdate = "0000-00-00"
        GROUP BY YEAR(hire_date)
    ) a
    INNER JOIN
    (
        SELECT YEAR(hire_date) AS year,
               COUNT(emp_id) AS terminations
        FROM hr
        WHERE termdate <> "0000-00-00"
          AND termdate <= CURDATE()
        GROUP BY YEAR(hire_date)
    ) b
    ON a.year = b.year
)

SELECT *,
       hires - terminations AS net_change,
       ROUND(((hires - terminations) / hires) * 100, 2) AS net_change_percentage
FROM net_change_cte
ORDER BY net_change DESC;
```

The analysis showed that **2018 recorded the highest net change percentage**, followed by **2016, 2017, 2019, and 2013**.

This analysis provided a historical view of workforce growth by comparing the number of employees hired with the number of employees from each hiring cohort who had been terminated by the analysis date.

### 📸 Change in Employee Numbers Over Time

![enot](../SQL%20Projects%20Images/Human%20Resources%20Project%20Images/enot.png)
---

## 🔹 Average Tenure by Department

The final EDA question examined the average number of years employees worked in each department before leaving the organization.

```sql
SELECT department,
       ROUND(AVG(DATEDIFF(termdate, hire_date) / 365), 0) AS average_tenure
FROM hr
WHERE termdate != "0000-00-00"
  AND termdate <= CURDATE()
GROUP BY department;
```

The results showed that the average tenure across all departments ranged from approximately **7 to 9 years**.

This suggests that terminated employees generally spent several years with the company before leaving, although the average varied slightly between departments.

Like the job title analysis, the `average_tenure` result was exported and imported into Power BI but **was not included as a visual in the final report**.

### 📸 Average Tenure by Department

![tenure distribution](../SQL%20Projects%20Images/Human%20Resources%20Project%20Images/tenure%20distribution.png)

---

At the end of the SQL analysis, the results of the analytical queries were exported as **CSV files** into a folder called `Exported SQL queries`. These exported results were then used as the data sources for the Power BI stage of the project.


# 📊 Power BI Report Development and Visualization

After completing the exploratory data analysis in SQL, the results of the analytical queries were exported as **CSV files** and stored in a folder called `Exported SQL queries`.

Rather than connecting Power BI directly to the original dataset, the exported SQL query results were used as the data sources for the visualization stage of the project. This created a clear workflow in which **SQL handled the data cleaning, transformation, and exploratory analysis, while Power BI was used to visually communicate the results**.

---

## 🔹 Importing the Exported SQL Query Results into Power BI

The folder containing the exported CSV files was imported into Power BI using **Power Query's folder import functionality**.

The exported files were:

- `age_group.csv`
- `age_group_gender.csv`
- `average_length_employment.csv`
- `average_tenure.csv`
- `employee_change.csv`
- `gender.csv`
- `gender_departments.csv`
- `jobtitle.csv`
- `location.csv`
- `race.csv`
- `state.csv`
- `turnover_rate.csv`

All query results were successfully imported into Power BI. However, **10 of the 12 queries were ultimately visualized in the final report**, while the `average_tenure` and `jobtitle` datasets were not included as visuals.

### 📸 Importing the Exported SQL Query Results into Power BI

![pb1](../SQL%20Projects%20Images/Human%20Resources%20Project%20Images/pb1.png)

### 📸 Imported SQL Query Result in Power BI Data View

![pb2](../SQL%20Projects%20Images/Human%20Resources%20Project%20Images/pb2.png)

The final report was titled **HR Employee Distribution Report** and consisted of **two pages**, with each page focusing on different aspects of the company's workforce.

---

## 🔹 Power BI Report — Page 1

The first page of the report provided a high-level overview of employee demographics, work arrangements, geographical distribution, employment duration, and changes in employee numbers over time.

### 📸 Power BI Report — Page 1

![pb3](../SQL%20Projects%20Images/Human%20Resources%20Project%20Images/pb3.png)


### Average Length of Employment

A **Card visual** was used to display the average length of employment for terminated employees.

The analysis showed an average employment length of approximately **8 years**.

Only employees whose termination dates had already occurred as of the analysis date were included in this calculation, preventing future termination dates from affecting the result.

### Gender Distribution

A **Stacked Column Chart** was used to visualize the gender distribution of active employees.

The results showed:

- **Male:** 8,911 employees
- **Female:** 8,090 employees
- **Non-Conforming:** 481 employees

Male employees represented the largest gender group, although the difference between male and female employee counts was relatively moderate.

### Headquarters vs Remote Employees

A **Donut Chart** was used to compare employees working at headquarters with those working remotely.

The analysis showed:

- **Headquarters:** 13,107 employees
- **Remote:** 4,375 employees

Approximately **75% of active employees worked at headquarters**, while about **25% worked remotely**.

### Change in Employee Numbers Over Time

A **Line Chart** was used to visualize the company's net change in employee numbers from **2000 to 2020**.

The chart provided a historical view of workforce changes by comparing employee hires with terminations and calculating the resulting net change for each year.

The analysis showed that **2018 recorded the highest net change percentage**, followed by **2016, 2017, 2019, and 2013**.

### Employees by State

A **Map visual** was used to display the geographical distribution of active employees across the seven states represented in the dataset.

**Ohio had the highest number of employees**, which aligns with the company's headquarters being located in Cleveland, Ohio.

The map was formatted by increasing the size of the bubbles and displaying data labels to make the geographical differences easier to interpret.

### Race Distribution

A **Clustered Column Chart** was used to visualize the racial and ethnic distribution of active employees.

**White employees** represented the largest racial group, while **Native Hawaiian or Other Pacific Islander employees** formed the smallest group.

The visual provided a clear comparison of employee representation across the different racial and ethnic categories in the dataset.


---

## 🔹 Power BI Report — Page 2

The second page of the report focused on age demographics, departmental gender distribution, and turnover rates.

### 📸 Power BI Report — Page 2

![pb4](../SQL%20Projects%20Images/Human%20Resources%20Project%20Images/pb4.png)



### Age Distribution by Gender

A **Clustered Column Chart** was used to compare gender distribution across the five employee age groups:

- 18-24
- 25-34
- 35-44
- 45-54
- 55-64

The visual showed how male, female, and non-conforming employees were distributed across each age category.

### Age Group Distribution

A **Stacked Column Chart** was used to visualize the overall distribution of active employees across the five age groups.

The age groups were deliberately sorted in ascending order to ensure that the x-axis followed a logical progression from **18-24 through 55-64**, rather than displaying the categories in an arbitrary order.

The **35-44 age group** contained the largest number of employees, while the **18-24 age group** had the smallest representation.

### Turnover Rate by Department

A **Table visual** was used to present departmental turnover rates.

The analysis showed that **Auditing had the highest turnover rate**, followed by **Legal, Marketing, Product Management, and Support**.

The table made it possible to compare the number of terminated employees, total employee count, and termination rate across departments.

### Gender Distribution by Department

A **Clustered Column Chart** was used to compare male, female, and non-conforming employee counts across departments.

Male employees formed the largest gender group in most departments, while female employees had higher representation in departments such as **Marketing** and **Research and Development**. The **Auditing** department had an almost equal distribution of male and female employees.



---

## 🔹 Report Formatting and Design

Each visual in the Power BI report was formatted to improve clarity and presentation. The formatting included:

- Customizing chart titles.
- Changing column and chart colors.
- Renaming displayed fields and column headers.
- Adding data labels where appropriate.
- Hiding unnecessary values from selected visuals.
- Increasing bubble sizes on the map visual.
- Organizing visuals across two separate report pages to prevent overcrowding.

The final **HR Employee Distribution Report** transformed the SQL analysis into a clear visual summary of the company's workforce demographics, geographical distribution, employee trends, employment duration, and departmental turnover.

# 💡 Key Insights, SQL Concepts Demonstrated and Conclusion

## 🔹 Key Insights

The analysis of the human resources dataset revealed several important insights about the company's workforce:

- **Male employees formed the largest gender group**, with 8,911 active employees, followed by 8,090 female employees and 481 non-conforming employees.

- **White employees represented the largest racial group** in the organization, while Native Hawaiian or Other Pacific Islander employees had the smallest representation.

- The **35-44 age group had the highest number of employees**, with 5,085 employees, closely followed by the 25-34 age group with 4,941 employees and the 45-54 age group with 4,838 employees.

- Only **331 active employees were between 18 and 24 years old**, making this the least represented age group in the organization. This could suggest that the company employs relatively few people at the earliest stages of their careers, although additional recruitment data would be needed to determine the exact reason.

- Approximately **75% of active employees worked at headquarters**, while about 25% worked remotely. Although many remote employees were located outside Cleveland, approximately 151 employees based in Cleveland also worked remotely.

- Employees who had already been terminated as of the analysis date had worked at the company for an average of approximately **8 years** before leaving.

- **Research Assistant II** was the most common job title, with 608 active employees, followed by Business Analyst with 552 employees and Human Resources Analyst II with 477 employees.

- **Auditing recorded the highest departmental turnover rate**, followed by Legal, Marketing, Product Management, and Support. Additional information about the reasons for employee departures would be required to fully explain these differences.

- Employees were distributed across **seven states**, with Ohio having the largest workforce. This aligns with the company's headquarters being located in Cleveland, Ohio.

- The workforce change analysis showed that **2018 recorded the highest net change percentage**, followed by 2016, 2017, 2019, and 2013.

- The average tenure of terminated employees across departments ranged from approximately **7 to 9 years**, showing relatively small differences in average employment duration between departments.

---

## 🔹 SQL Concepts Demonstrated

Throughout the project, several SQL concepts and techniques were applied, including:

- Database creation with `CREATE SCHEMA`
- Selecting a default database with `USE`
- Table renaming with `ALTER TABLE`
- Column renaming and data type modification
- Data cleaning and transformation
- `UPDATE` and `DELETE` statements
- Date conversion with `STR_TO_DATE()`
- Date extraction with `DATE()`
- Date calculations with `DATEDIFF()`
- `CURRENT_DATE()` and `CURDATE()`
- Conditional logic with `CASE`
- Aggregate functions such as `COUNT()` and `AVG()`
- `GROUP BY`
- `ORDER BY`
- `DISTINCT`
- Common Table Expressions (CTEs)
- Inner joins
- Nested subqueries
- Window functions using `OVER()` and `PARTITION BY`
- Mathematical calculations for turnover rates and workforce changes

---

## 🔹 Power BI Skills Demonstrated

The visualization stage of the project also demonstrated practical Power BI and Power Query skills, including:

- Importing multiple CSV files through Power Query's folder import functionality.
- Working with multiple exported SQL query results as separate tables.
- Creating a two-page Power BI report.
- Using card, stacked column, clustered column, donut, line, map, and table visuals.
- Sorting categorical age groups into a logical ascending order.
- Adding and formatting data labels.
- Customizing chart titles and displayed field names.
- Adjusting map bubble sizes.
- Formatting chart colors and visual elements.
- Organizing multiple visuals across separate report pages for clarity.

---

## 🔹 Conclusion

This project demonstrates an end-to-end data analytics workflow that combines **SQL and Power BI** to transform raw employee data into meaningful workforce insights.

The project began with a CSV dataset containing employee demographic, employment, departmental, and geographical information. SQL was used to clean inconsistent date formats, transform termination dates, calculate employee ages, remove invalid records, and answer analytical questions covering employee demographics, workforce distribution, turnover, geographical location, employment duration, and changes in employee numbers over time.

The results of the SQL analysis were exported as **CSV files** and imported into Power BI through Power Query's folder import functionality. The exported queries were then used to create a two-page **HR Employee Distribution Report**, transforming the SQL findings into clear and visually accessible insights.

Overall, the project demonstrates the ability to move beyond isolated SQL queries or standalone visualizations by connecting multiple stages of the analytical process: **data preparation, SQL-based analysis, result exportation, Power Query data import, and Power BI reporting**.

---


👥📊💻