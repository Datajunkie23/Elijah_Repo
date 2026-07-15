# 🏦 Bank Loan Analysis Using SQL

## 📌 Project Overview

This project presents a comprehensive analysis of bank loan data using **SQL**. The project falls within the financial domain and focuses on transforming loan data into meaningful insights about loan applications, funded amounts, repayments, interest rates, debt-to-income ratios, loan performance, borrower characteristics, and lending trends.

The analysis began with a dataset containing **38,576 loan records** and information relating to borrowers, loan amounts, interest rates, employment history, loan purposes, repayment status, home ownership, and several date-related fields.

The project involved **database creation, data preparation, data cleaning and transformation, and extensive exploratory data analysis (EDA)**. The analysis was guided by a project brief that required the calculation of key performance indicators (KPIs), Month-to-Date (MTD) and Previous-Month-to-Date (PMTD) metrics, Month-over-Month (MoM) changes, good versus bad loan performance, loan status summaries, and several detailed breakdowns of lending activity.

The main objectives of the project were to:

- Prepare and transform the loan dataset for analysis.
- Calculate key lending KPIs and evaluate their monthly changes.
- Compare good loans against bad loans using multiple performance metrics.
- Examine loan performance across different loan statuses.
- Analyze monthly lending trends and regional loan activity.
- Investigate loan distribution by term, employment length, purpose, and home ownership.
- Extract meaningful insights about borrower behaviour and the overall performance of the loan portfolio.



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

---

## 🛠️ Tools and Technologies Used

- **MySQL** — Used for database creation, data cleaning, transformation, and exploratory data analysis.
- **MySQL Workbench** — Used as the SQL development environment for writing and executing queries.


---

##  Dataset Overview

The dataset was provided as a CSV file named `financial_loan.csv`. It contained **38,576 individual loan records** and a wide range of information relating to loan applicants, loan characteristics, repayment activity, and borrower financial profiles.

Some of the fields in the dataset included:

| Column | Description |
| --- | --- |
| `id` | Unique identifier assigned to each loan record |
| `address_state` | State associated with the loan applicant |
| `application_type` | Type of loan application |
| `emp_length` | Length of the applicant's employment |
| `emp_title` | Applicant's employment title |
| `grade` | Assigned loan grade |
| `home_ownership` | Applicant's home ownership status |
| `issue_date` | Date on which the loan was issued |
| `last_credit_pull_date` | Most recent date on which the applicant's credit information was retrieved |
| `last_payment_date` | Date of the applicant's most recent loan payment |
| `loan_status` | Current repayment status of the loan |
| `next_payment_date` | Scheduled date of the next loan payment |
| `purpose` | Stated purpose for taking the loan |
| `sub_grade` | More detailed classification within the assigned loan grade |
| `term` | Duration of the loan |
| `verification_status` | Indicates whether the applicant's financial information was verified |
| `annual_income` | Applicant's annual income |
| `dti` | Applicant's debt-to-income ratio |
| `installment` | Scheduled periodic loan repayment amount |
| `int_rate` | Interest rate applied to the loan |
| `loan_amount` | Amount of money funded for the loan |
| `total_payment` | Total amount received from the borrower |

The dataset also contained additional fields that provided further information about the applicants' credit profiles and loan characteristics.

---

## 📸 Dataset

The following screenshots show the original dataset before the data cleaning and transformation process began.

### Dataset — Part 1

![Raw Dataset 1](../SQL%20Projects%20Images/Bank%20Loan%20Project%20Images/rd1.png)

### Dataset — Part 2

![Raw Dataset 2](../SQL%20Projects%20Images/Bank%20Loan%20Project%20Images/rd2.png)

---

# Database Setup, Data Preparation and Transformation

## 🔹 Creating the Database

The first step was to create a new database called `bankloandb` to store and manage the bank loan data.

```sql
CREATE SCHEMA bankloandb;
```

The newly created database was then selected as the default database. This made it possible to execute subsequent queries without repeatedly specifying the database name.

```sql
USE bankloandb;
```

The original dataset was imported into MySQL as a table called `financial_loan`. The contents of the imported table were inspected using:

```sql
SELECT *
FROM financial_loan;
```

## 🔹 Renaming the Table

To give the table a clearer and more descriptive name, it was renamed from `financial_loan` to `bank_loan_data`.

```sql
ALTER TABLE financial_loan
RENAME TO bank_loan_data;
```

The renamed table was then queried to confirm that the operation was successful.

```sql
SELECT *
FROM bank_loan_data;
```

### 📸 Database Creation and Data Import

![Database Creation](../SQL%20Projects%20Images/Bank%20Loan%20Project%20Images/dbc1.png)


## 🔹 Inspecting the Table Structure

The structure of the `bank_loan_data` table was examined using the `DESC` statement.

```sql
DESC bank_loan_data;
```

This provided information about the columns in the table, including their names, data types, nullability, key constraints, and other structural properties.


## 🔹 Adding a Primary Key

The `id` column contained a unique identifier for each loan record and was therefore assigned as the primary key of the `bank_loan_data` table.

```sql
ALTER TABLE bank_loan_data
ADD PRIMARY KEY (id);
```

Adding the primary key ensured that every loan record could be uniquely identified and prevented duplicate values from being stored in the `id` column.

### 📸 Table Structure

![Data Cleaning](../SQL%20Projects%20Images/Bank%20Loan%20Project%20Images/dc2.png)




## 🔹 Transforming the Date-Related Columns

The dataset contained four date-related columns:

- `issue_date`
- `last_credit_pull_date`
- `last_payment_date`
- `next_payment_date`

The values in these columns were originally stored in a non-standard SQL date format. To prepare them for accurate date-based analysis, the `STR_TO_DATE()` function was used to convert the existing values into valid SQL dates using the `"%d-%m-%Y"` format.

After converting the values, each column was updated and its data type was changed to `DATE`.

---

## 🔹 Transforming the `issue_date` Column

The `issue_date` column represents the date on which each loan was issued. The existing values were first converted using `STR_TO_DATE()`.

```sql
SELECT issue_date,
       STR_TO_DATE(issue_date, "%d-%m-%Y")
FROM bank_loan_data;
```

The original values were then updated with their converted equivalents.

```sql
UPDATE bank_loan_data
SET issue_date = STR_TO_DATE(issue_date, "%d-%m-%Y");
```

Finally, the data type of the column was changed to `DATE`.

```sql
ALTER TABLE bank_loan_data
MODIFY COLUMN issue_date DATE;
```

This transformation was particularly important because the `issue_date` column was later used extensively for the **Month-to-Date (MTD), Previous-Month-to-Date (PMTD), Month-over-Month (MoM), and monthly trend analyses**.

### 📸 `issue_date` Transformation

![Issue Date Transformation](../SQL%20Projects%20Images/Bank%20Loan%20Project%20Images/issue%20date.png)

---

## 🔹 Transforming the `last_credit_pull_date` Column

The `last_credit_pull_date` column represents the most recent date on which credit information associated with a loan record was retrieved.

The same transformation process was applied:

```sql
SELECT last_credit_pull_date,
       STR_TO_DATE(last_credit_pull_date, "%d-%m-%Y")
FROM bank_loan_data;
```

The converted values were then written back into the table:

```sql
UPDATE bank_loan_data
SET last_credit_pull_date = STR_TO_DATE(last_credit_pull_date, "%d-%m-%Y");
```

The column's data type was subsequently changed to `DATE`.

```sql
ALTER TABLE bank_loan_data
MODIFY COLUMN last_credit_pull_date DATE;
```

### 📸 `last_credit_pull_date` Transformation

![Last Credit Pull Date Transformation](../SQL%20Projects%20Images/Bank%20Loan%20Project%20Images/last%20credit.png)

---

## 🔹 Transforming the `last_payment_date` Column

The `last_payment_date` column contains the date of the most recent payment associated with each loan.

The values were converted into the proper SQL date format:

```sql
SELECT last_payment_date,
       STR_TO_DATE(last_payment_date, "%d-%m-%Y")
FROM bank_loan_data;
```

The converted values were used to update the original column:

```sql
UPDATE bank_loan_data
SET last_payment_date = STR_TO_DATE(last_payment_date, "%d-%m-%Y");
```

The column was then changed to the `DATE` data type.

```sql
ALTER TABLE bank_loan_data
MODIFY COLUMN last_payment_date DATE;
```

### 📸 `last_payment_date` Transformation

![Last Payment Date Transformation](../SQL%20Projects%20Images/Bank%20Loan%20Project%20Images/last%20payment.png)
---

## 🔹 Transforming the `next_payment_date` Column

The final date-related column transformed during the data preparation stage was `next_payment_date`, which represents the scheduled date of the next loan payment where applicable.

The existing values were converted using:

```sql
SELECT next_payment_date,
       STR_TO_DATE(next_payment_date, "%d-%m-%Y")
FROM bank_loan_data;
```

The table was then updated:

```sql
UPDATE bank_loan_data
SET next_payment_date = STR_TO_DATE(next_payment_date, "%d-%m-%Y");
```

Finally, the column's data type was changed to `DATE`.

```sql
ALTER TABLE bank_loan_data
MODIFY COLUMN next_payment_date DATE;
```

### 📸 `next_payment_date` Transformation

![Next Payment Date Transformation](../SQL%20Projects%20Images/Bank%20Loan%20Project%20Images/next%20payment.png)

---

## 🔹 Data Preparation Summary

- The `bankloandb` database was created and selected as the default database.
- The original `financial_loan` table was renamed to `bank_loan_data`.
- The table structure was inspected.
- The `id` column was assigned as the primary key.
- The `issue_date` column was converted to the `DATE` data type.
- The `last_credit_pull_date` column was converted to the `DATE` data type.
- The `last_payment_date` column was converted to the `DATE` data type.
- The `next_payment_date` column was converted to the `DATE` data type.

With these transformations completed, the dataset was prepared for the exploratory data analysis and KPI calculations.

# 📊 Exploratory Data Analysis (EDA)

After completing the data preparation and transformation process, the next stage of the project was **Exploratory Data Analysis (EDA)**. 

## 🎯 EDA Structure

The analytical stage of the project was divided into four major sections:

### 1. Key Performance Indicators

Five major KPIs were calculated:

- Total Loan Applications
- Total Funded Amount
- Total Amount Received
- Average Interest Rate
- Average Debt-to-Income Ratio (DTI)

For each KPI, the analysis also included:

- **Month-to-Date (MTD)** performance for December 2021.
- **Previous-Month-to-Date (PMTD)** performance for November 2021.
- **Month-over-Month (MoM)** percentage change between November and December 2021.

### 2. Good Loan vs Bad Loan Analysis

Loans were classified based on their repayment status:

- **Good Loans:** Loans with a status of `Fully Paid` or `Current`.
- **Bad Loans:** Loans with a status of `Charged Off`.

The analysis calculated application percentages, application counts, funded amounts, and total received amounts for both categories.

### 3. Loan Status Grid View

A detailed loan status summary was created to compare the following metrics across `Fully Paid`, `Charged Off`, and `Current` loans:

- Loan Count
- Total Amount Received
- Total Funded Amount
- Average Interest Rate
- Average Debt-to-Income Ratio

Additional MTD and PMTD grid views were also created to monitor monthly funded and received amounts across each loan status.

### 4. Loan Portfolio Overview

The final stage of the analysis examined lending activity across six different dimensions:

- Monthly Trends by Issue Date
- Regional Analysis by State
- Loan Term Analysis
- Employee Length Analysis
- Loan Purpose Breakdown
- Home Ownership Analysis

Together, these analyses provided a comprehensive view of the bank's lending activity, borrower characteristics, repayment performance, and overall loan portfolio.


The first part of the EDA section focused on calculating five major **Key Performance Indicators (KPIs)** to evaluate the overall performance of the bank's loan portfolio.

The five KPIs analyzed were:

- Total Loan Applications
- Total Funded Amount
- Total Amount Received
- Average Interest Rate
- Average Debt-to-Income Ratio (DTI)

For each KPI, additional time-based metrics were calculated to compare performance between **November and December 2021**:

- **Month-to-Date (MTD):** Performance for December 2021.
- **Previous-Month-to-Date (PMTD):** Performance for November 2021.
- **Month-over-Month (MoM):** The percentage change between November and December 2021.

The `issue_date` column was used for all MTD and PMTD calculations. Since the dataset contained loan issue dates from only one unique year, **2021**, December represented the current month for the analysis, while November represented the previous month.

The following formula was used to calculate Month-over-Month percentage change:

```text
MoM % = ((MTD - PMTD) / PMTD) × 100
```

---

## 🔹 Total Loan Applications

The first KPI measured the total number of loan applications contained in the dataset.

```sql
SELECT COUNT(id) AS Total_Loan_Applications
FROM bank_loan_data;
```

The analysis returned a total of **38,576 loan applications**.

To determine the number of loan applications issued in December 2021, the following MTD query was used:

```sql
SELECT COUNT(id) AS MTD_Total_Loan_Applications
FROM bank_loan_data
WHERE MONTH(issue_date) = 12
  AND YEAR(issue_date) = 2021;
```

The **MTD Total Loan Applications** for December were **4,314**.

The PMTD calculation measured the number of loan applications issued in November 2021:

```sql
SELECT COUNT(id) AS PMTD_Total_Loan_Applications
FROM bank_loan_data
WHERE MONTH(issue_date) = 11
  AND YEAR(issue_date) = 2021;
```

The **PMTD Total Loan Applications** for November were **4,035**.

The Month-over-Month percentage change was then calculated by combining the MTD and PMTD results:

```sql
SELECT ROUND(
    ((MTD_Total_Loan_Applications - PMTD_Total_Loan_Applications)
    / PMTD_Total_Loan_Applications) * 100, 2
) AS MoM_Total_Loan_Applications
FROM (
    SELECT a.MTD_Total_Loan_Applications,
           b.PMTD_Total_Loan_Applications
    FROM (
        SELECT 1 AS keyy,
               COUNT(id) AS MTD_Total_Loan_Applications
        FROM bank_loan_data
        WHERE MONTH(issue_date) = 12
          AND YEAR(issue_date) = 2021
    ) a
    JOIN (
        SELECT 1 AS keyy,
               COUNT(id) AS PMTD_Total_Loan_Applications
        FROM bank_loan_data
        WHERE MONTH(issue_date) = 11
          AND YEAR(issue_date) = 2021
    ) b
    ON a.keyy = b.keyy
) c;
```

The number of loan applications increased by **279 applications**, from 4,035 in November to 4,314 in December. This represented a **6.91% Month-over-Month increase**.

One possible explanation for the increase could be greater borrowing activity associated with festive-period expenses, although additional data would be required to confirm the exact reason for the increase.

### 📸 Total Loan Applications

![Total Loan Applications 1](../SQL%20Projects%20Images/Bank%20Loan%20Project%20Images/tla1.png)

![Total Loan Applications 2](../SQL%20Projects%20Images/Bank%20Loan%20Project%20Images/tla2.png)

![Total Loan Applications 3](../SQL%20Projects%20Images/Bank%20Loan%20Project%20Images/tla3.png)

![Total Loan Applications 4](../SQL%20Projects%20Images/Bank%20Loan%20Project%20Images/tla4.png)

---

## 🔹 Total Funded Amount

The Total Funded Amount represents the combined value of all loans issued across the **38,576 loan applications**.

```sql
SELECT SUM(loan_amount) AS Total_Funded_Amount
FROM bank_loan_data;
```

The analysis returned a **Total Funded Amount of 435,757,075**.

The MTD Total Funded Amount for December 2021 was calculated using:

```sql
SELECT SUM(loan_amount) AS MTD_Total_Funded_Amount
FROM bank_loan_data
WHERE MONTH(issue_date) = 12
  AND YEAR(issue_date) = 2021;
```

The result was **53,981,425**.

The PMTD Total Funded Amount for November 2021 was calculated using:

```sql
SELECT SUM(loan_amount) AS PMTD_Total_Funded_Amount
FROM bank_loan_data
WHERE MONTH(issue_date) = 11
  AND YEAR(issue_date) = 2021;
```

The result was **47,754,825**.

The Month-over-Month percentage change was then calculated:

```sql
SELECT ROUND(
    ((MTD_Total_Funded_Amount - PMTD_Total_Funded_Amount)
    / PMTD_Total_Funded_Amount) * 100, 2
) AS MoM_Total_Funded_Amount
FROM (
    SELECT a.MTD_Total_Funded_Amount,
           b.PMTD_Total_Funded_Amount
    FROM (
        SELECT 1 AS keyy,
               SUM(loan_amount) AS MTD_Total_Funded_Amount
        FROM bank_loan_data
        WHERE MONTH(issue_date) = 12
          AND YEAR(issue_date) = 2021
    ) a
    JOIN (
        SELECT 1 AS keyy,
               SUM(loan_amount) AS PMTD_Total_Funded_Amount
        FROM bank_loan_data
        WHERE MONTH(issue_date) = 11
          AND YEAR(issue_date) = 2021
    ) b
    ON a.keyy = b.keyy
) c;
```

The Total Funded Amount increased from **47,754,825 in November** to **53,981,425 in December**, representing a **13.04% Month-over-Month increase**.

This indicates that the value of loans funded grew at a faster rate than the number of loan applications, which increased by 6.91% during the same period.

### 📸 Total Funded Amount

![Total Funded Amount 1](../SQL%20Projects%20Images/Bank%20Loan%20Project%20Images/tfa1.png)

![Total Funded Amount 2](../SQL%20Projects%20Images/Bank%20Loan%20Project%20Images/tfa2.png)

![Total Funded Amount 3](../SQL%20Projects%20Images/Bank%20Loan%20Project%20Images/tfa3.png)

![Total Funded Amount 4](../SQL%20Projects%20Images/Bank%20Loan%20Project%20Images/tfa4.png)

---

## 🔹 Total Amount Received

The Total Amount Received represents the cumulative amount received from borrowers across the loan portfolio.

```sql
SELECT SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data;
```

The analysis returned a **Total Amount Received of 473,070,933**.

For comparison, the overall Total Funded Amount was **435,757,075**. The difference between these two values was:

```text
473,070,933 - 435,757,075 = 37,313,858
```

This means that the cumulative amount received exceeded the amount originally funded by **37,313,858** across the entire loan portfolio.

It is important to note that this portfolio contains three different loan statuses:

- `Fully Paid` — The borrower has completed repayment of the loan.
- `Current` — The loan is still being actively repaid.
- `Charged Off` — The loan has been written off following unsuccessful repayment.

Therefore, not every loan in the dataset had completed its full repayment cycle at the time represented by the data.

The MTD Total Amount Received for December 2021 was calculated using:

```sql
SELECT SUM(total_payment) AS MTD_Total_Amount_Received
FROM bank_loan_data
WHERE MONTH(issue_date) = 12
  AND YEAR(issue_date) = 2021;
```

The result was **58,074,380**.

The PMTD Total Amount Received for November 2021 was:

```sql
SELECT SUM(total_payment) AS PMTD_Total_Amount_Received
FROM bank_loan_data
WHERE MONTH(issue_date) = 11
  AND YEAR(issue_date) = 2021;
```

The result was **50,132,030**.

The Month-over-Month percentage change was then calculated:

```sql
SELECT ROUND(
    ((MTD_Total_Payment - PMTD_Total_Payment)
    / PMTD_Total_Payment) * 100, 2
) AS MoM_Total_Payment
FROM (
    SELECT a.MTD_Total_Payment,
           b.PMTD_Total_Payment
    FROM (
        SELECT 1 AS keyy,
               SUM(total_payment) AS MTD_Total_Payment
        FROM bank_loan_data
        WHERE MONTH(issue_date) = 12
          AND YEAR(issue_date) = 2021
    ) a
    JOIN (
        SELECT 1 AS keyy,
               SUM(total_payment) AS PMTD_Total_Payment
        FROM bank_loan_data
        WHERE MONTH(issue_date) = 11
          AND YEAR(issue_date) = 2021
    ) b
    ON a.keyy = b.keyy
) c;
```

The Total Amount Received increased from **50,132,030 in November** to **58,074,380 in December**, representing a **15.84% Month-over-Month increase**.


### 📸 Total Amount Received

![Total Amount Received 1](../SQL%20Projects%20Images/Bank%20Loan%20Project%20Images/tar1.png)

![Total Amount Received 2](../SQL%20Projects%20Images/Bank%20Loan%20Project%20Images/tar2.png)

![Total Amount Received 3](../SQL%20Projects%20Images/Bank%20Loan%20Project%20Images/tar3.png)

![Total Amount Received 4](../SQL%20Projects%20Images/Bank%20Loan%20Project%20Images/tar4.png)


## 🔹 Average Interest Rate

The Average Interest Rate represents the average rate charged across all loans in the dataset.

```sql
SELECT ROUND(AVG(int_rate) * 100, 2) AS Average_Interest_Rate
FROM bank_loan_data;
```

The overall **Average Interest Rate was 12.05%**.

The MTD Average Interest Rate for December 2021 was calculated using:

```sql
SELECT CONVERT((AVG(int_rate) * 100), DECIMAL(4,2)) AS MTD_Average_Interest_Rate
FROM bank_loan_data
WHERE MONTH(issue_date) = 12
  AND YEAR(issue_date) = 2021;
```

The result was **12.36%**.

The PMTD Average Interest Rate for November 2021 was:

```sql
SELECT ROUND(AVG(int_rate) * 100, 2) AS PMTD_Average_Interest_Rate
FROM bank_loan_data
WHERE MONTH(issue_date) = 11
  AND YEAR(issue_date) = 2021;
```

The result was **11.94%**.

The Month-over-Month percentage change was then calculated:

```sql
SELECT ROUND(
    ((MTD_Average_Interest_Rate - PMTD_Average_Interest_Rate)
    / PMTD_Average_Interest_Rate) * 100, 2
) AS MOM_Average_Interest_Rate
FROM (
    SELECT a.MTD_Average_Interest_Rate,
           b.PMTD_Average_Interest_Rate
    FROM (
        SELECT 1 AS keyy,
               AVG(int_rate) AS MTD_Average_Interest_Rate
        FROM bank_loan_data
        WHERE MONTH(issue_date) = 12
          AND YEAR(issue_date) = 2021
    ) a
    JOIN (
        SELECT 1 AS keyy,
               AVG(int_rate) AS PMTD_Average_Interest_Rate
        FROM bank_loan_data
        WHERE MONTH(issue_date) = 11
          AND YEAR(issue_date) = 2021
    ) b
    ON a.keyy = b.keyy
) c;
```

The Average Interest Rate increased from **11.94% in November** to **12.36% in December**, representing a **3.47% Month-over-Month increase**.

### 📸 Average Interest Rate

![Average Interest Rate 1](../SQL%20Projects%20Images/Bank%20Loan%20Project%20Images/ai1.png)

![Average Interest Rate 1B](../SQL%20Projects%20Images/Bank%20Loan%20Project%20Images/ai1b.png)

![Average Interest Rate 3](../SQL%20Projects%20Images/Bank%20Loan%20Project%20Images/ai3.png)

![Average Interest Rate 4](../SQL%20Projects%20Images/Bank%20Loan%20Project%20Images/ai4.png)

---

## 🔹 Average Debt-to-Income Ratio (DTI)

The Debt-to-Income Ratio compares an individual's debt obligations with their income and is commonly used as an indicator of a borrower's ability to manage debt.

The general formula is:

```text
DTI = (Debt Payments / Income) × 100
```

The overall Average DTI was calculated using:

```sql
SELECT ROUND(AVG(dti) * 100, 2) AS Average_DTI
FROM bank_loan_data;
```

The analysis returned an overall **Average DTI of 13.33%**.

The MTD Average DTI for December 2021 was calculated using:

```sql
SELECT ROUND(AVG(dti) * 100, 2) AS MTD_Average_DTI
FROM bank_loan_data
WHERE MONTH(issue_date) = 12
  AND YEAR(issue_date) = 2021;
```

The result was **13.67%**.

The PMTD Average DTI for November 2021 was:

```sql
SELECT ROUND(AVG(dti) * 100, 2) AS PMTD_Average_DTI
FROM bank_loan_data
WHERE MONTH(issue_date) = 11
  AND YEAR(issue_date) = 2021;
```

The result was **13.30%**.

The Month-over-Month percentage change was then calculated:

```sql
SELECT ROUND(
    ((MTD_Average_DTI - PMTD_Average_DTI)
    / PMTD_Average_DTI) * 100, 2
) AS MOM_Average_DTI
FROM (
    SELECT a.MTD_Average_DTI,
           b.PMTD_Average_DTI
    FROM (
        SELECT 1 AS keyy,
               AVG(dti) AS MTD_Average_DTI
        FROM bank_loan_data
        WHERE MONTH(issue_date) = 12
          AND YEAR(issue_date) = 2021
    ) a
    JOIN (
        SELECT 1 AS keyy,
               AVG(dti) AS PMTD_Average_DTI
        FROM bank_loan_data
        WHERE MONTH(issue_date) = 11
          AND YEAR(issue_date) = 2021
    ) b
    ON a.keyy = b.keyy
) c;
```

The Average DTI increased from **13.30% in November** to **13.67% in December**, representing a **2.73% Month-over-Month increase**.

The relatively small difference between the November and December values shows that the average DTI remained fairly stable across both months.

### 📸 Average Debt-to-Income Ratio

![Average DTI 1](../SQL%20Projects%20Images/Bank%20Loan%20Project%20Images/dti1.png)

![Average DTI 2](../SQL%20Projects%20Images/Bank%20Loan%20Project%20Images/dti2.png)

![Average DTI 3](../SQL%20Projects%20Images/Bank%20Loan%20Project%20Images/dti3.png)

![Average DTI 4](../SQL%20Projects%20Images/Bank%20Loan%20Project%20Images/dti4.png)

---

## 🔹 Summary of the Five KPIs

The complete KPI analysis produced the following results:

| KPI | Overall Value | MTD — December | PMTD — November | MoM Change |
| --- | ---: | ---: | ---: | ---: |
| Total Loan Applications | 38,576 | 4,314 | 4,035 | 6.91% |
| Total Funded Amount | 435,757,075 | 53,981,425 | 47,754,825 | 13.04% |
| Total Amount Received | 473,070,933 | 58,074,380 | 50,132,030 | 15.84% |
| Average Interest Rate | 12.05% | 12.36% | 11.94% | 3.47% |
| Average DTI | 13.33% | 13.67% | 13.30% | 2.73% |

All five KPIs increased between November and December 2021. The **Total Amount Received recorded the largest Month-over-Month increase at 15.84%**, while the **Average DTI recorded the smallest change at 2.73%**.

After completing the KPI analysis, the project moved into a detailed comparison of **Good Loans versus Bad Loans**, using loan repayment status to evaluate the overall quality and performance of the loan portfolio.

---

# 🟢 Good Loan vs Bad Loan Analysis

The next stage of the project focused on evaluating the quality of the loan portfolio by separating loans into **Good Loans** and **Bad Loans** based on their repayment status.

The `loan_status` column contained three distinct categories:

- **Fully Paid** — The borrower has completely repaid the loan.
- **Current** — The borrower is still actively servicing and repaying the loan.
- **Charged Off** — The loan has been written off after the borrower failed to meet repayment obligations.

For this analysis:

- **Good Loans** were loans with a status of `Fully Paid` or `Current`.
- **Bad Loans** were loans with a status of `Charged Off`.

Four major metrics were calculated for both good and bad loans:

- Loan Application Percentage
- Loan Application Count
- Total Funded Amount
- Total Received Amount

---

## 🔹 Good Loan Percentage

The Good Loan Percentage represents the proportion of all loan applications classified as either `Fully Paid` or `Current`.

```sql
SELECT ROUND((good_loan_count / total_loan_count) * 100, 0)
       AS good_loan_percentage
FROM (
    WITH good_loan_cte AS (
        SELECT 1 AS keyy,
               COUNT(*) AS Good_loan_count
        FROM bank_loan_data
        WHERE loan_status IN ("fully paid", "current")
    ),
    total_loan_cte AS (
        SELECT 1 AS keyy,
               COUNT(*) AS Total_loan_count
        FROM bank_loan_data
    )
    SELECT glc.good_loan_count,
           tlc.total_loan_count
    FROM good_loan_cte glc
    JOIN total_loan_cte tlc
      ON glc.keyy = tlc.keyy
) a;
```

The analysis showed that **86% of all loan applications were classified as good loans**.

### 📸 Good Loan Percentage

![Good Loan Percentage](../SQL%20Projects%20Images/Bank%20Loan%20Project%20Images/glp.png)

---

## 🔹 Good Loan Applications

The total number of good loan applications was calculated using:

```sql
SELECT COUNT(*) AS Good_loan_applications
FROM bank_loan_data
WHERE loan_status IN ("fully paid", "current");
```

Out of **38,576 total loan applications**, **33,243 were classified as good loans**.

### 📸 Good Loan Applications

![Good Loan Applications](../SQL%20Projects%20Images/Bank%20Loan%20Project%20Images/gla.png)

---

## 🔹 Good Loan Funded Amount

The total amount funded for good loans was calculated using:

```sql
SELECT SUM(loan_amount) AS Good_loan_funded_amount
FROM bank_loan_data
WHERE loan_status IN ("fully paid", "current");
```

The **Good Loan Funded Amount was 370,224,850**.

### 📸 Good Loan Funded Amount

![Good Loan Funded Amount](../SQL%20Projects%20Images/Bank%20Loan%20Project%20Images/glfa.png)

---

## 🔹 Good Loan Total Received Amount

The total amount received from good loans was calculated using:

```sql
SELECT SUM(total_payment) AS Good_loan_received_amount
FROM bank_loan_data
WHERE loan_status IN ("fully paid", "current");
```

The **Good Loan Total Received Amount was 435,786,170**.

The difference between the amount received and the amount funded for good loans was:

```text
435,786,170 - 370,224,850 = 65,561,320
```

Therefore, the amount received from good loans exceeded the amount originally funded by **65,561,320**.

### 📸 Good Loan Total Received Amount

![Good Loan Total Received Amount](../SQL%20Projects%20Images/Bank%20Loan%20Project%20Images/gltra.png)



## 🔹 Bad Loan Percentage

Bad loans were defined as loans with a status of `Charged Off`.

The Bad Loan Percentage was calculated using:

```sql
SELECT ROUND((bad_loan_count / total_loan_count) * 100, 0)
       AS bad_loan_percentage
FROM (
    WITH bad_loan_cte AS (
        SELECT 1 AS keyy,
               COUNT(*) AS Bad_loan_count
        FROM bank_loan_data
        WHERE loan_status IN ("charged off")
    ),
    total_loan_cte AS (
        SELECT 1 AS keyy,
               COUNT(*) AS Total_loan_count
        FROM bank_loan_data
    )
    SELECT blc.bad_loan_count,
           tlc.total_loan_count
    FROM bad_loan_cte blc
    JOIN total_loan_cte tlc
      ON blc.keyy = tlc.keyy
) a;
```

The analysis showed that **14% of all loan applications were classified as bad loans**.

### 📸 Bad Loan Percentage

![Bad Loan Percentage](../SQL%20Projects%20Images/Bank%20Loan%20Project%20Images/blp.png)

---

## 🔹 Bad Loan Applications

The total number of bad loan applications was calculated using:

```sql
SELECT COUNT(*) AS Bad_loan_applications
FROM bank_loan_data
WHERE loan_status = "charged off";
```

A total of **5,333 loan applications were classified as bad loans**.

### 📸 Bad Loan Applications

![Bad Loan Applications](../SQL%20Projects%20Images/Bank%20Loan%20Project%20Images/bla.png)

---

## 🔹 Bad Loan Funded Amount

The total amount originally funded for bad loans was:

```sql
SELECT SUM(loan_amount) AS Bad_loan_funded_amount
FROM bank_loan_data
WHERE loan_status = "charged off";
```

The **Bad Loan Funded Amount was 65,532,225**.

### 📸 Bad Loan Funded Amount

![Bad Loan Funded Amount](../SQL%20Projects%20Images/Bank%20Loan%20Project%20Images/blfa.png)

---

## 🔹 Bad Loan Total Received Amount

The total amount received from bad loans was calculated using:

```sql
SELECT SUM(total_payment) AS Bad_loan_received_amount
FROM bank_loan_data
WHERE loan_status = "charged off";
```

The **Bad Loan Total Received Amount was 37,284,763**.

The difference between the amount funded and the amount received for bad loans was:

```text
65,532,225 - 37,284,763 = 28,247,462
```

Therefore, the amount received from bad loans was **28,247,462 less than the amount originally funded**.

### 📸 Bad Loan Total Received Amount

![Bad Loan Total Received Amount](../SQL%20Projects%20Images/Bank%20Loan%20Project%20Images/bltra.png)

---

## 🔹 Reconciling Good and Bad Loan Performance

One particularly important finding from the analysis was the relationship between the overall loan portfolio and the separate performance of good and bad loans.

Across the entire portfolio:

```text
Total Amount Received - Total Funded Amount

473,070,933 - 435,757,075 = 37,313,858
```

For good loans:

```text
435,786,170 - 370,224,850 = 65,561,320
```

For bad loans:

```text
65,532,225 - 37,284,763 = 28,247,462
```

Subtracting the shortfall associated with bad loans from the positive difference generated by good loans gives:

```text
65,561,320 - 28,247,462 = 37,313,858
```

This exactly matches the overall difference between the **Total Amount Received** and **Total Funded Amount** across the complete loan portfolio.

| Loan Category | Applications | Percentage | Funded Amount | Amount Received | Difference |
| --- | ---: | ---: | ---: | ---: | ---: |
| Good Loans | 33,243 | 86% | 370,224,850 | 435,786,170 | +65,561,320 |
| Bad Loans | 5,333 | 14% | 65,532,225 | 37,284,763 | -28,247,462 |
| **Overall Portfolio** | **38,576** | **100%** | **435,757,075** | **473,070,933** | **+37,313,858** |

This reconciliation demonstrates how the shortfall associated with charged-off loans reduced the positive difference generated by fully paid and current loans, ultimately resulting in an overall positive difference of **37,313,858** across the complete portfolio.


# 📋 Loan Status Grid View

After completing the **Good Loan versus Bad Loan analysis**, the next stage of the project involved creating a **Loan Status Grid View** to provide a comprehensive overview of the bank's lending operations and monitor the performance of loans across different repayment statuses.

The `loan_status` column contained three distinct categories:

- **Fully Paid** — The borrower has completely repaid the loan.
- **Charged Off** — The loan has been written off after the borrower failed to meet repayment obligations.
- **Current** — The borrower is still actively servicing and repaying the loan.

For each loan status, the following five metrics were calculated:

- Loan Count
- Total Amount Received
- Total Funded Amount
- Average Interest Rate
- Average Debt-to-Income Ratio (DTI)

---

## 🔹 Overall Loan Status Grid View

The following query was used to group the loan portfolio by `loan_status` and calculate the five major performance metrics for each category:

```sql
SELECT loan_status,
       COUNT(*) AS Loan_count,
       SUM(total_payment) AS Total_Amount_Received,
       SUM(loan_amount) AS Total_funded_amount,
       AVG(int_rate) * 100 AS Interest_rate,
       AVG(dti) * 100 AS DTI
FROM bank_loan_data
GROUP BY loan_status;
```

The analysis produced the following results:

| Loan Status | Loan Count | Total Amount Received | Total Funded Amount | Average Interest Rate | Average DTI |
| --- | ---: | ---: | ---: | ---: | ---: |
| Fully Paid | 32,145 | 411,586,256 | 351,358,350 | 11.64% | 13.17% |
| Charged Off | 5,333 | 37,284,763 | 65,532,225 | 13.88% | 14.00% |
| Current | 1,098 | 24,199,914 | 18,866,500 | 15.10% | 14.72% |

The grid view reveals clear differences in the performance and characteristics of the three loan statuses.

**Fully Paid loans** accounted for the overwhelming majority of the portfolio, with **32,145 loans**. These loans had a Total Funded Amount of **351,358,350** and generated a Total Amount Received of **411,586,256**, meaning the amount received exceeded the amount funded.

**Charged Off loans** accounted for **5,333 loans**. The bank funded **65,532,225** for these loans but received only **37,284,763**, highlighting the financial shortfall associated with this category.

**Current loans** accounted for **1,098 loans** and were still actively being repaid. They had the highest Average Interest Rate at approximately **15.10%** and the highest Average DTI at approximately **14.72%**.

The analysis also showed that **Fully Paid loans had the lowest Average Interest Rate and Average DTI of the three categories**, while Current loans had the highest values for both metrics.

### 📸 Overall Loan Status Grid View

![Loan Status Grid View](../SQL%20Projects%20Images/Bank%20Loan%20Project%20Images/lsgv.png)

---

## 🔹 Month-to-Date Loan Status Grid View

To further monitor the monthly performance of the loan portfolio, a **Month-to-Date (MTD) Loan Status Grid View** was created for **December 2021**.

This analysis focused on two metrics for each loan status:

- MTD Total Funded Amount
- MTD Total Received Amount

The following query was used:

```sql
SELECT loan_status,
       SUM(loan_amount) AS MTD_Total_funded_amount,
       SUM(total_payment) AS MTD_Total_received_amount
FROM bank_loan_data
WHERE MONTH(issue_date) = 12
GROUP BY loan_status;
```

The analysis produced the following results:

| Loan Status | MTD Total Funded Amount | MTD Total Received Amount |
| --- | ---: | ---: |
| Fully Paid | 41,302,025 | 47,815,851 |
| Charged Off | 8,732,775 | 5,324,211 |
| Current | 3,946,625 | 4,934,318 |

For **Fully Paid loans**, the MTD Total Amount Received of **47,815,851** exceeded the MTD Total Funded Amount of **41,302,025**.

For **Charged Off loans**, the bank funded **8,732,775** but received only **5,324,211**, resulting in a shortfall within this category.

For **Current loans**, the MTD Total Amount Received was **4,934,318**, compared with an MTD Total Funded Amount of **3,946,625**.

### 📸 MTD Loan Status Grid View

![MTD Loan Status Grid View](../SQL%20Projects%20Images/Bank%20Loan%20Project%20Images/mtdls.png)

---

## 🔹 Previous-Month-to-Date Loan Status Grid View

A **Previous-Month-to-Date (PMTD) Loan Status Grid View** was also created for **November 2021**. This made it possible to compare the funded and received amounts across each loan status between November and December.

The following query was used:

```sql
SELECT loan_status,
       SUM(loan_amount) AS PMTD_Total_funded_amount,
       SUM(total_payment) AS PMTD_Total_received_amount
FROM bank_loan_data
WHERE MONTH(issue_date) = 11
GROUP BY loan_status;
```

The analysis produced the following results:

| Loan Status | PMTD Total Funded Amount | PMTD Total Received Amount |
| --- | ---: | ---: |
| Fully Paid | 37,375,675 | 42,420,451 |
| Charged Off | 7,511,175 | 3,994,065 |
| Current | 2,867,975 | 3,717,514 |

For **Fully Paid loans**, the Total Funded Amount increased from **37,375,675 in November** to **41,302,025 in December**, while the Total Amount Received increased from **42,420,451** to **47,815,851**.

For **Charged Off loans**, the Total Funded Amount increased from **7,511,175 in November** to **8,732,775 in December**, while the Total Amount Received increased from **3,994,065** to **5,324,211**.

For **Current loans**, the Total Funded Amount increased from **2,867,975 in November** to **3,946,625 in December**, while the Total Amount Received increased from **3,717,514** to **4,934,318**.

### 📸 PMTD Loan Status Grid View

![PMTD Loan Status Grid View](../SQL%20Projects%20Images/Bank%20Loan%20Project%20Images/pmtdls.png)

---

## 🔹 MTD vs PMTD Loan Status Comparison

Comparing the November and December grid views shows that both the **Total Funded Amount** and **Total Received Amount** increased across all three loan statuses.

| Loan Status | PMTD Funded Amount | MTD Funded Amount | PMTD Received Amount | MTD Received Amount |
| --- | ---: | ---: | ---: | ---: |
| Fully Paid | 37,375,675 | 41,302,025 | 42,420,451 | 47,815,851 |
| Charged Off | 7,511,175 | 8,732,775 | 3,994,065 | 5,324,211 |
| Current | 2,867,975 | 3,946,625 | 3,717,514 | 4,934,318 |

The largest absolute values in both months were associated with **Fully Paid loans**, reflecting their dominant share of the overall loan portfolio.

The analysis also consistently showed a substantial difference between the funded and received amounts for **Charged Off loans**, demonstrating the financial impact of unsuccessful loan repayment.

Overall, the Loan Status Grid View provided a detailed perspective on how the loan portfolio performed across different repayment categories and allowed monthly changes in funding and repayment activity to be monitored more closely.

# 🌐 Loan Portfolio Overview Analysis

The final stage of the exploratory data analysis focused on examining the bank's lending activity across several different dimensions. Three major metrics were calculated for each category:

- **Total Loan Applications (TLA)**
- **Total Funded Amount (TFA)**
- **Total Received Amount (TRA)**

The analysis was conducted across six different areas:

- Monthly Trends by Issue Date
- Regional Analysis by State
- Loan Term Analysis
- Employee Length Analysis
- Loan Purpose Breakdown
- Home Ownership Analysis

These analyses provided a broader view of the bank's loan portfolio by revealing how loan applications, funded amounts, and received amounts were distributed across time, geographical locations, loan terms, borrower employment history, loan purposes, and home ownership categories.

---

## 🔹 Monthly Trends by Issue Date

The first analysis examined how loan applications, funded amounts, and received amounts changed throughout the months of **2021**.

The `MONTH()` and `MONTHNAME()` functions were used to extract the month number and month name from the `issue_date` column.

```sql
SELECT MONTH(issue_date) AS `Month`,
       MONTHNAME(issue_date) AS month_name,
       COUNT(*) AS Total_loan_applications,
       SUM(loan_amount) AS Total_funded_amount,
       SUM(total_payment) AS Total_received_amount
FROM bank_loan_data
GROUP BY MONTH(issue_date), MONTHNAME(issue_date)
ORDER BY 1 ASC;
```

The analysis produced the following results:

| Month | Month Name | Total Loan Applications | Total Funded Amount | Total Received Amount |
| ---: | --- | ---: | ---: | ---: |
| 1 | January | 2,332 | 25,031,650 | 27,578,836 |
| 2 | February | 2,279 | 24,647,825 | 27,717,745 |
| 3 | March | 2,627 | 28,875,700 | 32,264,400 |
| 4 | April | 2,755 | 29,800,800 | 32,495,533 |
| 5 | May | 2,911 | 31,738,350 | 33,750,523 |
| 6 | June | 3,184 | 34,161,475 | 36,164,533 |
| 7 | July | 3,366 | 35,813,900 | 38,827,220 |
| 8 | August | 3,441 | 38,149,600 | 42,682,218 |
| 9 | September | 3,536 | 40,907,725 | 43,983,948 |
| 10 | October | 3,796 | 44,893,800 | 49,399,567 |
| 11 | November | 4,035 | 47,754,825 | 50,132,030 |
| 12 | December | 4,314 | 53,981,425 | 58,074,380 |

The results show a generally upward trend in lending activity throughout the year. Although loan applications decreased slightly from **2,332 in January to 2,279 in February**, they increased consistently from March onwards and reached their highest level in **December with 4,314 applications**.

December also recorded the highest **Total Funded Amount of 53,981,425** and the highest **Total Received Amount of 58,074,380**.

This demonstrates significant growth in lending activity over the course of 2021, with the strongest performance recorded toward the end of the year.

### 📸 Monthly Trends by Issue Date

![Monthly Trends by Issue Date](../SQL%20Projects%20Images/Bank%20Loan%20Project%20Images/mtid.png)

---

## 🔹 Regional Analysis by State

The next analysis examined the geographical distribution of loan activity across different states.

For each state, the following metrics were calculated:

- Total Loan Applications
- Total Funded Amount
- Total Received Amount

```sql
SELECT address_state,
       COUNT(*) AS Total_loan_applications,
       SUM(loan_amount) AS Total_funded_amount,
       SUM(total_payment) AS Total_received_amount
FROM bank_loan_data
GROUP BY address_state
ORDER BY 2 DESC;
```

After sorting the results by Total Loan Applications in descending order, the top five states were:

| Rank | State | Total Loan Applications |
| ---: | --- | ---: |
| 1 | California | 6,894 |
| 2 | New York | 3,701 |
| 3 | Florida | 2,773 |
| 4 | Texas | 2,664 |
| 5 | New Jersey | 1,822 |

**California recorded the highest number of loan applications with 6,894**, considerably more than any other state in the dataset. New York followed with 3,701 applications, while Florida, Texas, and New Jersey completed the top five.

One possible explanation for the high number of loan applications in states such as California, New York, and Florida could be their large populations and relatively high living costs. However, additional demographic and economic data would be required to determine the exact factors responsible for these geographical differences.

### 📸 Regional Analysis by State

![Regional Analysis by State](../SQL%20Projects%20Images/Bank%20Loan%20Project%20Images/ras.png)

---

## 🔹 Loan Term Analysis

The `term` column represents the duration over which a borrower is expected to repay a loan.

The dataset contained two distinct loan terms:

- **36 months** — 3 years
- **60 months** — 5 years

The following query was used to calculate the three major metrics for each loan term:

```sql
SELECT term,
       COUNT(*) AS Total_loan_applications,
       SUM(loan_amount) AS Total_funded_amount,
       SUM(total_payment) AS Total_received_amount
FROM bank_loan_data
GROUP BY term
ORDER BY 2 DESC;
```

The results were:

| Loan Term | Total Loan Applications | Total Funded Amount | Total Received Amount |
| --- | ---: | ---: | ---: |
| 36 months | 28,237 | 273,041,225 | 294,709,458 |
| 60 months | 10,339 | 162,715,850 | 178,361,475 |

The majority of loans had a **36-month term**, accounting for **28,237 of the 38,576 total loan applications**. In comparison, 10,339 loans had a 60-month repayment period.

The 36-month category also accounted for the majority of the Total Funded Amount and Total Received Amount, which is consistent with its significantly larger number of loan applications.

The dataset alone does not establish why borrowers or lenders selected one term over the other. Possible factors could include the loan amount, borrower preference, repayment affordability, or lending criteria.

### 📸 Loan Term Analysis

![Loan Term Analysis](../SQL%20Projects%20Images/Bank%20Loan%20Project%20Images/lta.png)

---

## 🔹 Employee Length Analysis

The `emp_length` column represents the length of time an applicant had been employed. Employment length ranged from **less than one year to more than ten years**.

The following query was used to analyze loan activity by employment length:

```sql
SELECT emp_length,
       COUNT(*) AS Total_loan_applications,
       SUM(loan_amount) AS Total_funded_amount,
       SUM(total_payment) AS Total_received_amount
FROM bank_loan_data
GROUP BY emp_length
ORDER BY 3 DESC;
```

The results were:

| Employment Length | Total Loan Applications | Total Funded Amount | Total Received Amount |
| --- | ---: | ---: | ---: |
| 10+ years | 8,870 | 116,115,950 | 125,871,616 |
| 2 years | 4,382 | 44,967,975 | 49,206,961 |
| < 1 year | 4,575 | 44,210,625 | 47,545,011 |
| 3 years | 4,088 | 43,937,850 | 47,551,832 |
| 4 years | 3,428 | 37,600,375 | 40,964,850 |
| 5 years | 3,273 | 36,973,625 | 40,397,571 |
| 1 year | 3,229 | 32,883,125 | 35,498,348 |
| 6 years | 2,228 | 25,612,650 | 27,908,658 |
| 7 years | 1,772 | 20,811,725 | 22,584,136 |
| 8 years | 1,476 | 17,558,950 | 19,025,777 |
| 9 years | 1,255 | 15,084,225 | 16,516,173 |

Applicants with **10+ years of employment experience** clearly stood out across all three metrics. This group recorded:

- **8,870 loan applications**
- **116,115,950 in Total Funded Amount**
- **125,871,616 in Total Received Amount**

The difference between this group and the other employment-length categories was substantial. For example, the next-highest Total Funded Amount was **44,967,975 for applicants with two years of employment**, compared with 116,115,950 for those with 10+ years.

A major contributing factor is likely the significantly larger number of loan applications in the `10+ years` category. However, the results also show that long-term employees represented a particularly significant segment of the bank's overall loan portfolio.

### 📸 Employee Length Analysis

![Employee Length Analysis](../SQL%20Projects%20Images/Bank%20Loan%20Project%20Images/ela.png)

---


## 🔹 Loan Purpose Breakdown

The next analysis examined the reasons borrowers gave for taking out loans.

```sql
SELECT purpose,
       COUNT(*) AS Total_loan_applications,
       SUM(loan_amount) AS Total_funded_amount,
       SUM(total_payment) AS Total_received_amount
FROM bank_loan_data
GROUP BY purpose
ORDER BY 2 DESC;
```

The analysis produced the following results:

| Loan Purpose | Total Loan Applications | Total Funded Amount | Total Received Amount |
| --- | ---: | ---: | ---: |
| Debt Consolidation | 18,214 | 232,459,675 | 253,801,871 |
| Credit Card | 4,998 | 58,885,175 | 65,214,084 |
| Other | 3,824 | 31,155,750 | 33,289,676 |
| Home Improvement | 2,876 | 33,350,775 | 36,380,930 |
| Major Purchase | 2,110 | 17,251,600 | 18,676,927 |
| Small Business | 1,776 | 24,123,100 | 23,814,817 |
| Car | 1,497 | 10,223,575 | 11,324,914 |
| Wedding | 928 | 9,225,800 | 10,266,856 |
| Medical | 667 | 5,533,225 | 5,851,372 |
| Moving | 559 | 3,748,125 | 3,999,899 |
| House | 366 | 4,824,925 | 5,185,538 |
| Vacation | 352 | 1,967,950 | 2,116,738 |
| Educational | 315 | 2,161,650 | 2,248,380 |
| Renewable Energy | 94 | 845,750 | 898,931 |

**Debt consolidation was by far the most common loan purpose**, accounting for **18,214 applications**, almost half of all 38,576 loan applications in the dataset.

Debt consolidation also accounted for the highest Total Funded Amount at **232,459,675** and the highest Total Received Amount at **253,801,871**.

The second-most common purpose was **Credit Card**, with 4,998 applications, followed by **Other**, **Home Improvement**, and **Major Purchase**.

An interesting similarity emerged between the overall Loan Purpose Breakdown and the additional analysis of applicants with 10+ years of employment. In both analyses, **Debt Consolidation and Credit Card were the two most common loan purposes**.

### 📸 Loan Purpose Breakdown

![Loan Purpose Breakdown](../SQL%20Projects%20Images/Bank%20Loan%20Project%20Images/lpb.png)

---

## 🔹 Home Ownership Analysis

The final analysis in the project examined lending activity according to applicants' home ownership status.

The following query was used:

```sql
SELECT home_ownership,
       COUNT(*) AS Total_loan_applications,
       SUM(loan_amount) AS Total_funded_amount,
       SUM(total_payment) AS Total_received_amount
FROM bank_loan_data
GROUP BY home_ownership
ORDER BY 3 DESC;
```

The dataset contained five home ownership categories:

- Rent
- Mortgage
- Own
- Other
- None

The majority of loan applicants were renters, with **18,439 applications**, followed closely by applicants with mortgages, who accounted for **17,198 applications**.

Applicants who owned their homes accounted for **2,838 applications**, while the `Other` and `None` categories contained only **98 and 3 applications**, respectively.

Despite renters having the highest number of loan applications, applicants with a **mortgage recorded the highest Total Funded Amount at 219,329,150**.

This means that mortgage holders received a larger total value of loans despite submitting fewer applications than renters. The result could indicate differences in the average size of loans issued across the home ownership categories, although further analysis would be needed to determine the exact cause.

### 📸 Home Ownership Analysis

![Home Ownership Analysis](../SQL%20Projects%20Images/Bank%20Loan%20Project%20Images/hoa.png)

---

## 🔹 Overview Analysis Summary

The six overview analyses revealed several important patterns across the loan portfolio:

- Lending activity generally increased throughout 2021, with December recording the highest number of applications, Total Funded Amount, and Total Received Amount.
- California had the highest number of loan applications among all states.
- The majority of borrowers selected a 36-month loan term rather than a 60-month term.
- Applicants with 10+ years of employment recorded the highest number of loan applications and the largest Total Funded and Received Amounts.
- Debt consolidation was overwhelmingly the most common reason for taking out a loan.
- Renters submitted the most loan applications, but mortgage holders accounted for the highest Total Funded Amount.

Together, these findings provided a comprehensive view of the bank's lending activity across time, location, loan duration, employment history, loan purpose, and home ownership status.

# 🔍 Key Insights and Findings

The Bank Loan Analysis project revealed several important patterns relating to lending activity, loan performance, borrower characteristics, and repayment behaviour.

The key findings from the analysis include:

- A total of **38,576 loan applications** were recorded, with a combined **Total Funded Amount of 435,757,075** and a **Total Amount Received of 473,070,933**.

- The Total Amount Received exceeded the Total Funded Amount by **37,313,858** across the complete loan portfolio.

- All five major KPIs increased between November and December 2021:
  - Total Loan Applications increased by **6.91%**.
  - Total Funded Amount increased by **13.04%**.
  - Total Amount Received increased by **15.84%**.
  - Average Interest Rate increased by **3.47%**.
  - Average DTI increased by **2.73%**.

- **86% of all loan applications were classified as good loans**, representing **33,243 applications**, while **14% were classified as bad loans**, representing **5,333 applications**.

- Good loans generated a positive difference of **65,561,320** between the Total Amount Received and Total Funded Amount, while bad loans recorded a shortfall of **28,247,462**.

- After accounting for the shortfall associated with bad loans, the resulting difference was **37,313,858**, exactly matching the overall difference between the Total Amount Received and Total Funded Amount across the entire portfolio.

- **Fully Paid loans dominated the portfolio**, accounting for **32,145 of the 38,576 total loan applications**.

- Current loans recorded the highest **Average Interest Rate of approximately 15.10%** and the highest **Average DTI of approximately 14.72%**.

- Lending activity generally increased throughout 2021, with **December recording the highest number of loan applications, Total Funded Amount, and Total Received Amount**.

- **California recorded the highest number of loan applications**, with a total of **6,894 applications**.

- The majority of borrowers selected a **36-month loan term**, accounting for **28,237 applications**, compared with 10,339 applications for the 60-month term.

- Applicants with **10+ years of employment** represented the largest employment-length category, with **8,870 loan applications**, a Total Funded Amount of **116,115,950**, and a Total Received Amount of **125,871,616**.

- Further investigation into applicants with 10+ years of employment showed that their five most common loan purposes were **Debt Consolidation, Credit Card, Home Improvement, Other, and Major Purchase**.

- **Debt Consolidation was the most common loan purpose overall**, accounting for **18,214 applications**, almost half of all loan applications in the dataset.

- Although renters submitted the highest number of loan applications, applicants with a **mortgage recorded the highest Total Funded Amount of 219,329,150**.

---

# 💡 SQL Concepts and Techniques Demonstrated

This project involved the practical application of several SQL concepts and techniques, including:

- Database and schema creation
- Table renaming
- Primary key creation
- Table structure inspection
- Data type transformation
- Date conversion using `STR_TO_DATE()`
- Date functions including `MONTH()`, `MONTHNAME()`, and `YEAR()`
- Aggregate functions including `COUNT()`, `SUM()`, and `AVG()`
- Data filtering using `WHERE`
- Conditional filtering using `IN`
- Data grouping using `GROUP BY`
- Result sorting using `ORDER BY`
- Common Table Expressions (CTEs)
- Subqueries and derived tables
- SQL joins
- Numeric formatting using `ROUND()` and `CONVERT()`

---

# 📝 Conclusion

This project provided a comprehensive analysis of a bank loan portfolio containing **38,576 loan records**. Using SQL, the dataset was prepared and transformed before an extensive exploratory data analysis was conducted to evaluate lending activity, loan performance, repayment behaviour, and borrower characteristics.

The analysis began with five KPIs: **Total Loan Applications, Total Funded Amount, Total Amount Received, Average Interest Rate, and Average Debt-to-Income Ratio**. MTD, PMTD, and MoM calculations were also performed to compare lending performance between November and December 2021.

The project then evaluated the quality of the loan portfolio by separating loans into good and bad categories. The results showed that **86% of applications were classified as good loans**, while 14% were classified as bad loans. A detailed reconciliation also demonstrated how the positive difference generated by good loans was reduced by the shortfall associated with charged-off loans, resulting in an overall difference of **37,313,858** between the Total Amount Received and Total Funded Amount.

The Loan Status Grid View provided additional insight into the performance of `Fully Paid`, `Charged Off`, and `Current` loans, while the final overview analysis examined lending activity across months, states, loan terms, employment lengths, loan purposes, and home ownership categories.

Overall, the project demonstrated how SQL can be used not only to clean and transform financial data, but also to answer business questions, calculate performance indicators, identify trends, compare loan quality, and extract meaningful insights from a large lending dataset.

---

🏦