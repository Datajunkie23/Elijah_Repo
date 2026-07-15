-- Creating the database
create schema projects;

-- Making the database a default database
use projects;

select *  from `human resources`;
desc `human resources`;

-- Renaming the table 
alter table `human resources` rename to hr;
select * from hr;

-- Data cleaning
-- Renaming the "id" column 
alter table hr rename column ï»¿id to emp_id;
desc hr;
-- Changing the datatype of the "emp_id" column 
alter table hr modify column emp_id varchar(20);

-- Transforming the "birthdate" column 
select birthdate,month(birthdate) from hr where birthdate like "%-%";
select birthdate,str_to_date(birthdate,"%d-%m-%Y") from hr where birthdate like "%-%";
update hr set birthdate=str_to_date(birthdate,"%d-%m-%Y") where birthdate like "%-%";
select birthdate,str_to_date(birthdate,"%m/%d/%Y") from hr where birthdate like "%/%";
update hr set birthdate=str_to_date(birthdate,"%m/%d/%Y") where birthdate like "%/%";
-- Changing the datatype of the "birthdate" column from "text" to "date" 
alter table hr modify column birthdate date;

-- Transforming the "hire_date" column 
select hire_date,str_to_date(hire_date,"%d-%m-%Y") from hr where hire_date like "%-%";
update hr set hire_date=str_to_date(hire_date,"%d-%m-%Y")  where hire_date like "%-%";
select hire_date,str_to_date(hire_date,"%m/%d/%Y") from hr where hire_date like "%/%";
update hr set hire_date=str_to_date(hire_date,"%m/%d/%Y") where hire_date like "%/%";
-- Changing the datatype of the "hire_date" column from "text" to "date"
alter table hr modify column hire_date date;

-- Transforming the "termdate" column 
-- Extracting the "date" part of the "datetime" value in the "termdate" column 
select termdate,date(str_to_date(termdate,"%Y-%m-%d %H:%i:%s UTC")) from hr where termdate is not null and termdate!="";
-- Updating the values in the "termdate" column
update hr set termdate=date(str_to_date(termdate,"%Y-%m-%d %H:%i:%s UTC")) where termdate is not null and termdate <>"";
-- Populating blank values in the "termdate" column 
update hr set termdate="0000-00-00" where termdate is null or termdate="";
-- Temporarily adjusted SQL mode to allow zero-date values
select @@sql_mode;
set sql_mode="no_engine_substitution,no_zero_in_date";
-- Changing the datatype of the "termdate" column from "text" to "date" 
alter table hr modify column termdate date null;

-- Adding an age column to the hr table
alter table hr add column Age int;
-- Calculating employees age by using sql date functions 
select birthdate,year(current_date())-year(birthdate) from hr;
-- Updating the hr table with employees age 
update hr set age=year(current_date)-year(birthdate);

-- Deleting records from the hr table where employess age is less than 18 
delete from hr where age<18;
select * from hr where age<18;

-- Exploratory Data Analysis(EDA)
-- What is the gender breakdown of employees in the company?
select * from hr where termdate="0000-00-00";
select gender,count(emp_id) employee_count from hr where termdate="0000-00-00" group by gender;  

-- What is the race/ethnicity breakdown of employees in the company?
select  race,count(emp_id) employee_count from hr where termdate="0000-00-00" group by race order by employee_count desc;

-- What is the age distribution of employees in the company?
select min(age) minimum_age,max(age) maximum_age from hr where termdate="0000-00-00";
select case when age between 18 and 24 then "18-24" when age between 25 and 34 then "25-34" when age between 35 and 44 then "35-44"
when age between 45 and 54 then "45-54" when age between 55 and 64 then "55-64" end age_group ,count(emp_id) employee_count from hr 
where termdate="0000-00-00" group by age_group order by age_group,employee_count desc;

-- Gender distribution across age groups
select case when age between 18 and 24 then "18-24" when age between 25 and 34 then "25-34" when age between 35 and 44 then "35-44"
when age between 45 and 54 then "45-54" when age between 55 and 64 then "55-64" end age_group,gender,count(emp_id) employee_count from hr 
where termdate="0000-00-00" group by age_group,gender order by age_group,employee_count desc;

-- How many employees work at headquarters versus remote locations? 
select distinct location from hr where termdate="0000-00-00";
select distinct location,count(emp_id)over(partition by location) employee_count from hr where termdate="0000-00-00";

-- What is the average length of employment for employees who have been terminated?
with average_employment_years_cte as
(select termdate,hire_date,(datediff(termdate,hire_date))/365 length_of_employment_in_years from
(select * from hr where termdate not like "%0000-00%" and termdate<=current_date)a)
select round(avg(length_of_employment_in_years),0) average_employment_years from average_employment_years_cte;

-- How does gender distribution vary across departments and job titles?
-- Gender distribution across departments 
select distinct department,gender,count(emp_id)over(partition by department,gender) employee_count from hr where termdate="0000-00-00" 
order by department,employee_count desc;

-- gender distribution across job titles 
select distinct jobtitle,gender,count(emp_id)over(partition by jobtitle,gender) employee_count from hr where termdate="0000-00-00" 
order by jobtitle,employee_count desc;

-- What is the distribution of job titles across the company? 
select jobtitle,count(emp_id) employee_count from hr  where termdate="0000-00-00" group by jobtitle order by employee_count desc;

--  Which department has the highest turnover rate?
with turnover_cte as
(select a.*,b.total_count from
(select department,count(emp_id) terminated_count from
(select * from hr where termdate <>"0000-00-00" and termdate <= current_date())a group by department order by terminated_count desc)a
inner join
(select department,count(emp_id) total_count from hr group by department)b on a.department=b.department)
select *,terminated_count/total_count as termination_rate from turnover_cte order by 4 desc;

-- What is the distribution of employees across locations by city and state?
select * from hr;
select location,location_state,location_city,count(emp_id) employee_count from hr where termdate="0000-00-00" group by 
location,location_state,location_city order by employee_count desc;

-- Distribution of employees across locations by state
select location_state,count(emp_id) employee_count from hr where termdate="0000-00-00" group by location_state order by 2 desc;

-- How has the company's employee count changed over time based on hire dates and term dates?
with net_change_cte as 
(select a.year,a.hires,b.terminations from
(select  year(hire_date) year,count(emp_id) hires from hr where termdate="0000-00-00"  group by year(hire_date) order by 1)a
inner join
(select year(hire_date) year,count(emp_id) terminations from hr where termdate<>"0000-00-00" and termdate<=curdate() group by year(hire_date) 
order by 1)b on a.year=b.year)
select *,hires-terminations as net_change,round((((hires-terminations)/(hires))*100),2) net_change_percentage  from net_change_cte order by 
4 desc;

-- What is the tenure distribution of each department?
select department,round(avg(datediff(termdate,hire_date)/365),0) average_tenure from hr where termdate !="0000-00-00" and 
termdate<=curdate() group by department; 

-- End of Project 
