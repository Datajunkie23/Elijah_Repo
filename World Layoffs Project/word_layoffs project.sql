-- Data cleaning project
-- 1)Removing Duplicates
-- 2)Standardizing Data
-- 3)Examining Null values and blank values
-- 4)Removing unnecessary columns and rows 

-- Creating a schema/database
create schema world_layoffs;

-- Making the schema a default schema
use world_layoffs;

-- Viewing the tables in the database 
show tables;

-- Creating a duplicate table
create table layoffs_staging select * from layoffs;
select * from layoffs_staging;

-- Checking for duplicates
select * from 
(select *,row_number()over(partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions)
row_num from layoffs_staging)a where row_num>1;

-- Importing the data from the above subquery into a new table
create table layoffs_staging2 select * from
(select *,row_number()over(partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions)
row_num from layoffs_staging)a;

-- Deleting duplicate records from the table
delete from layoffs_staging2 where row_num>1;

-- Deleting the first layoffs_staging table
drop table layoffs_staging;

-- Renaming the layoffs_staging2 table to layoffs_staging
alter table layoffs_staging2 rename to layoffs_staging;

-- Confirming if there are still duplicates in the table
select * from layoffs_staging where row_num>1;

-- Standardizing data
-- Removing whitespaces (trimming) from the company column 
select company,trim(company) from layoffs_staging;

-- Updating the company column in the layoffs_staging table
update layoffs_staging set company=trim(company);

-- Exploring the industry column 
select distinct industry from layoffs_staging order by 1;

-- Looking for records containing "crypto"
select * from layoffs_staging where industry like "%crypto%";

-- Updating wrong records
update layoffs_staging set industry="Crypto" where industry in ("CryptoCurrency","Crypto Currency");

-- Exploring the Location column 
select distinct location from layoffs_staging;

-- Exploring the Country column
select distinct country from layoffs_staging order by 1 asc;

-- Correcting wrong values in the country column
update layoffs_staging set country="United States" where country like "%United Sta%";

-- Changing the values in the date column from a text format to a date format
select date,str_to_date(date,"%m/%d/%Y") from layoffs_staging;

-- Updating the values in the date column
update layoffs_staging set `date`=str_to_date(date,"%m/%d/%Y");

-- Changing the datatype of the date column from text to date
alter table layoffs_staging modify column `date` date null;

-- Checking for Null values and blank values in the "industry" column 
select * from layoffs_staging where industry is null or industry in ("");

-- Updating blank industry values with correct industry values
select * from layoffs_staging where company="airbnb";
update layoffs_staging set industry="Travel" where company in ("airbnb");

select * from layoffs_staging where company="carvana";
update layoffs_staging set industry="Transportation" where company="Carvana";

select * from layoffs_staging where company="Juul";
update layoffs_staging set industry="Consumer" where company in ("Juul");

-- Removing unnecessary columns are rows																																									
-- Exploring the total_laid_off and Percentage_laid_off column 
select * from layoffs_staging where total_laid_off is null and percentage_laid_off is null;

-- Deleting rows where total_laid_off is null and percentage_laid_off is null
delete from layoffs_staging where total_laid_off is null and percentage_laid_off is null;

-- Deleting the row number column that was created
alter table layoffs_staging drop column row_num;


-- Exploratoty Data Analysis
select * from layoffs_staging;

-- Checking out the maximum number of layoffs
select * from layoffs_staging where total_laid_off=(select max(total_laid_off) from layoffs_staging);

-- Total_layoffs by company
select company,sum(total_laid_off) total_layoffs from layoffs_staging group by company order by total_layoffs desc;

-- checking date range
select min(date),max(date) from layoffs_staging;

-- Total_layoffs by industry
select industry,sum(total_laid_off) from layoffs_staging group by industry order by 2 desc;

-- Total layoffs by country
select distinct country,sum(total_laid_off)over(partition by country) Total_layoffs from layoffs_staging order by  total_layoffs desc;

-- Total layoffs by year
select year(date) year, sum(total_laid_off) total_layoffs from layoffs_staging group by year order by  total_layoffs desc;

-- Total layoffs by stage
select distinct stage, sum(total_laid_off)over(partition by stage) Total_layoffs from layoffs_staging order by total_layoffs desc;

-- Total layoffs by year-months
select *,sum(total_layoffs)over(order by date) rolling_total from
(select distinct substr(date,1,7) date ,sum(total_laid_off)over(partition by substr(date,1,7)) total_layoffs from layoffs_staging where
date is not null)a;

-- Total layoffs by year
select * from 
(select company,date,total_layoffs,dense_rank()over(partition by date order by total_layoffs desc) ranking from
(select distinct company,year(date) as date,sum(total_laid_off)over(partition by company,year(date)) total_layoffs from layoffs_staging
where date is not null )a)b where ranking<=5;

--  End of Project








