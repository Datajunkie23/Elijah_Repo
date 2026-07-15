-- Creating a Database 
create schema bankloandb;

-- Making the database a default database
use bankloandb;
select * from financial_loan;

-- Renaming the table from "financial_loan" to "bank_loan_data"
alter table financial_loan rename to bank_loan_data;
select * from bank_loan_data;

-- Describing the "bank_loan_data" Table 
desc bank_loan_data;

-- Adding a primary key to the "bank_loan_data" table
alter table bank_loan_data add primary key (id);

-- Transforming all the date-related columns 
-- Transforming the "issue_date" column 
select issue_date,str_to_date(issue_date,"%d-%m-%Y") from bank_loan_data;
update bank_loan_data set issue_date=str_to_date(issue_date,"%d-%m-%Y");
alter table bank_loan_data modify column issue_date date;

-- Transforming   the "last_credit_pull_date" column
select last_credit_pull_date,str_to_date(last_credit_pull_date,"%d-%m-%Y") from bank_loan_data;
update bank_loan_data set last_credit_pull_date=str_to_date(last_credit_pull_date,"%d-%m-%Y");
alter table bank_loan_data modify column last_credit_pull_date date;

-- Transforming the "last_payment_date" column  
select last_payment_date,str_to_date(last_payment_date,"%d-%m-%Y") from bank_loan_data;
update bank_loan_data set last_payment_date=str_to_date(last_payment_date,"%d-%m-%Y");
alter table bank_loan_data modify column last_payment_date date;

-- Transforming the "next_payment_date" column 
select next_payment_date,str_to_date(next_payment_date,"%d-%m-%Y") from bank_loan_data;
update bank_loan_data set next_payment_date=str_to_date(next_payment_date,"%d-%m-%Y");
alter table bank_loan_data modify column next_payment_date date;

-- Expolratory Data Analysis (EDA)
/*All Month-to-Date (MTD) calculations in the "KPI" section were done for the Month of "December" while Previous-Month-to-Date (PMTD) 
calculations in the "KPI" section were done for the Month of "November" and the date column used for these calculations was the "issue_date" 
column and the "issue_date" column had only one unique year which was 2021.*/

-- Key Performance Indicators
-- Total Loan Applications
select count(id) Total_Loan_Applications from bank_loan_data; 
-- Month to Date (MTD) Total Loan Applications
select count(id) MTD_Total_Loan_Applications from bank_loan_data where month(issue_date)=12 and year(issue_date)=2021;
 -- Previous Month to Date Total Loan Applications
 select count(id) PMTD_Total_Loan_Applications from bank_loan_data where month(issue_date)=11 and year(issue_date)=2021;
-- Month over Month (MoM) Total Loan Applications
select round(((MTD_Total_Loan_Applications-PMTD_Total_Loan_Applications)/PMTD_Total_Loan_Applications)*100,2) MoM_Total_Loan_Applications from 
(select a.MTD_Total_Loan_Applications, b.PMTD_Total_Loan_Applications from 
(select 1 as keyy,count(id) MTD_Total_Loan_Applications from bank_loan_data where month(issue_date)=12 and year(issue_date)=2021)a join
(select 1 as keyy,count(id) PMTD_Total_Loan_Applications from bank_loan_data where month(issue_date)=11 and year(issue_date)=2021)b
on a.keyy=b.keyy)c;

-- Total Funded Amount
select * from bank_loan_data;
select sum(loan_amount) Total_Funded_Amount from bank_loan_data; 
-- Month to Date (MTD) Total Funded Amount
select sum(loan_amount) MTD_Total_Funded_Amount from bank_loan_data where month(issue_date)=12 and year(issue_date)=2021;
-- Previous Month to Date (PMTD) Total Funded Amount
select sum(loan_amount) PMTD_Total_Funded_Amount from bank_loan_data where month(issue_date)=11 and year(issue_date)=2021;  
-- MoM Total Funded Amount
select round(((MTD_Total_Funded_Amount-PMTD_Total_Funded_Amount)/PMTD_Total_Funded_Amount)*100,2) MoM_Total_Funded_Amount from 
(select a.MTD_Total_Funded_Amount, b.PMTD_Total_Funded_Amount from 
(select 1 as keyy,sum(loan_amount) MTD_Total_Funded_Amount from bank_loan_data where month(issue_date)=12 and year(issue_date)=2021)a join
(select 1 as keyy,sum(loan_amount) PMTD_Total_Funded_Amount from bank_loan_data where month(issue_date)=11 and year(issue_date)=2021)b
on a.keyy=b.keyy)c;

-- Total Amount Received 
select * from bank_loan_data;
select sum(total_payment) Total_Amount_Received from bank_loan_data; 
-- MTD Total Amount Received 
select sum(total_payment) MTD_Total_Amount_Received from bank_loan_data where month(issue_date)=12 and year(issue_date)=2021; 
-- PMTD Total Amount Received 
select sum(total_payment) PMTD_Total_Amount_Received from bank_loan_data where month(issue_date)=11 and year(issue_date)=2021;
-- MoM Total Amount Received 
select round(((MTD_Total_Payment-PMTD_Total_Payment)/PMTD_Total_Payment)*100,2) MoM_Total_Payment from 
(select a.MTD_Total_Payment, b.PMTD_Total_Payment from 
(select 1 as keyy,sum(total_payment) MTD_Total_Payment from bank_loan_data where month(issue_date)=12 and year(issue_date)=2021)a join
(select 1 as keyy,sum(total_payment) PMTD_Total_Payment from bank_loan_data where month(issue_date)=11 and year(issue_date)=2021)b
on a.keyy=b.keyy)c;

-- Average Interest Rate
select * from bank_loan_data;
select round(avg(int_rate) * 100,2)  Average_Interest_Rate from bank_loan_data;
-- MTD Average Interest Rate
select convert((avg(int_rate)*100),decimal(4,2)) MTD_Average_Interest_Rate from bank_loan_data where month(issue_date)=12 and 
year(issue_date)=2021;
-- PMTD Average Interest Rate 
 select round(avg(int_rate)*100,2) PMTD_Average_Interest_Rate from bank_loan_data where month(issue_date)=11 and year(issue_date)=2021;
 -- MOM Average Interest Rate 
select round(((MTD_Average_Interest_Rate-PMTD_Average_Interest_Rate)/PMTD_Average_Interest_Rate)*100,2) MOM_Average_Interest_Rate from 
(select a.MTD_Average_Interest_Rate, b.PMTD_Average_Interest_Rate from 
(select 1 as keyy,avg(int_rate) MTD_Average_Interest_Rate from bank_loan_data where month(issue_date)=12 and year(issue_date)=2021)a join
(select 1 as keyy,avg(int_rate) PMTD_Average_Interest_Rate from bank_loan_data where month(issue_date)=11 and year(issue_date)=2021)b
on a.keyy=b.keyy)c;

-- Averge Debt to Income Ratio (DTI) 
 select round(avg(dti)*100,2) Average_DTI from bank_loan_data;
 -- MTD Average Debt to Income Ratio
 select round(avg(dti)*100,2) MTD_Average_DTI from bank_loan_data where month(issue_date)=12 and year(issue_date)=2021;
-- PMTD Average Debt to Income Ratio
select round(avg(dti)*100,2) PMTD_Average_DTI from bank_loan_data where month(issue_date)=11 and year(issue_date)=2021;
-- MOM Average Debt to Income Ratio 
select round(((MTD_Average_DTI-PMTD_Average_DTI)/PMTD_Average_DTI)*100,2) MOM_Average_DTI from 
(select a.MTD_Average_DTI, b.PMTD_Average_DTI from 
(select 1 as keyy,avg(dti) MTD_Average_DTI from bank_loan_data where month(issue_date)=12 and year(issue_date)=2021)a join
(select 1 as keyy,avg(dti) PMTD_Average_DTI from bank_loan_data where month(issue_date)=11 and year(issue_date)=2021)b
on a.keyy=b.keyy)c;



-- Good Loan versus Bad Loan Key Performance Indicators
-- Good Loan Percentage 
select round((good_loan_count/total_loan_count)*100,0) good_loan_percentage from 
(with good_loan_cte as 
(select 1 as keyy,count(*) Good_loan_count from bank_loan_data where loan_status in ("fully paid", "current")),
total_loan_cte as 
(select 1 as keyy, count(*) Total_loan_count from bank_loan_data)
select glc.good_loan_count,tlc.total_loan_count from good_loan_cte glc join total_loan_cte tlc on glc.keyy=tlc.keyy)a;

-- Good Loan Applications
select count(*) Good_loan_applications from bank_loan_data where loan_status in ("fully paid", "current");

-- Good Loan Funded Amount 
select sum(loan_amount) Good_loan_funded_amount from bank_loan_data where loan_status in ("fully paid","current");

-- Good Loan Total Received Amount
select sum(total_payment) Good_loan_received_amount from bank_loan_data where loan_status in ("fully paid","current");

-- Bad Loan Percentage
select round((bad_loan_count/total_loan_count)*100,0) bad_loan_percentage from 
(with bad_loan_cte as 
(select 1 as keyy,count(*) Bad_loan_count from bank_loan_data where loan_status in ("charged off")),
total_loan_cte as 
(select 1 as keyy, count(*) Total_loan_count from bank_loan_data)
select blc.bad_loan_count,tlc.total_loan_count from bad_loan_cte blc join total_loan_cte tlc on blc.keyy=tlc.keyy)a;

-- Bad Loan Applications
select count(*) Bad_loan_applications from bank_loan_data where loan_status="charged off";

-- Bad loan funded amount
select * from bank_loan_data;
select sum(loan_amount) Bad_loan_funded_amount from bank_loan_data where loan_status="charged off"; 

-- Bad Loan Total Received Amount
select sum(total_payment) Bad_loan_received_amount from bank_loan_data where loan_status="charged off";

-- Loan Status grid view
select loan_status,count(*) Loan_count,sum(total_payment) Total_Amount_Received, sum(loan_amount) Total_funded_amount,
avg(int_rate)*100 Interest_rate,avg(dti)*100 DTI from bank_loan_data group by loan_status;
-- MTD Loan Status grid view
select * from bank_loan_data;
select loan_status,sum(loan_amount) MTD_Total_funded_amount, sum(total_payment) MTD_Total_received_amount from bank_loan_data 
where month(issue_date)=12 group by loan_status;
-- PMTD Loan status grid view
 select loan_status,sum(loan_amount) PMTD_Total_funded_amount, sum(total_payment) PMTD_Total_received_amount from bank_loan_data 
where month(issue_date)=11 group by loan_status;

-- Overview
-- Monthly Trends by Issue Date 
select month(issue_date) `Month`,monthname(issue_date) month_name,count(*) Total_loan_applications,sum(loan_amount) Total_funded_amount,
sum(total_payment) Total_received_amount from bank_loan_data group by month(issue_date),monthname(issue_date)  order by 1 asc;

-- Regional Analysis by state
select * from bank_loan_data;
select address_state,count(*) Total_loan_applications, sum(loan_amount) Total_funded_amount,sum(total_payment) Total_received_amount 
from bank_loan_data group by address_state order by 2 desc;

-- Loan Term Analysis
select term,count(*) Total_loan_applications, sum(loan_amount) Total_funded_amount,sum(total_payment) Total_received_amount from 
bank_loan_data group by term order by 2 desc;

-- Employee Length Analysis
select emp_length,count(*) Total_loan_applications, sum(loan_amount) Total_funded_amount,sum(total_payment) Total_received_amount 
from bank_loan_data group by emp_length order by 3 desc;

-- Loan purpose breakdown
select purpose,count(*) Total_loan_applications, sum(loan_amount) Total_funded_amount, sum(total_payment) Total_received_amount from 
bank_loan_data  group by purpose order by 2 desc;

-- Home ownership Analysis
select * from bank_loan_data;
select home_ownership, count(*) Total_loan_applications,sum(loan_amount) Total_funded_amount,sum(total_payment) Total_received_amount from 
bank_loan_data group by  home_ownership order by 3 desc;

-- End of Project 