-- Creating a Database
create schema census;

-- Making the database a default database
use census;

select * from dataset1;
select * from dataset2;

-- Renaming the tables  
alter table dataset1 rename to population_data;
alter table dataset2 rename to newpopulation_data;

-- Describing the tables
desc population_data;
desc newpopulation_data;

-- Data Cleaning 
-- Removing "," from the population column 
select population,replace(population,",","") from newpopulation_data;
update newpopulation_data set population=replace(population,",","");

-- Changing the datatype of the "population" column
alter table newpopulation_data modify column population int;

-- Removing "," from the area_km2 column
select area_km2,replace(area_km2,",","") from newpopulation_data;
update newpopulation_data set area_km2= replace(area_km2,",","");

-- Changing the datatype of the "area_km2" column
alter table newpopulation_data modify column area_km2 int;

-- Removing "%" from the growth column 
select growth,replace(growth,"%","") from population_data;
update population_data set growth=replace(growth,"%","");

-- changing the datatype of the growth column  
alter table population_data modify column growth float;

-- Exploratory Data Analysis
-- Total number of records
select count(*) Total_Records from population_data; 
select count(*) Record_count from newpopulation_data;

-- Selecting records from specific states
select * from population_data where state in ("jharkhand","bihar") order by state;

-- Total Population of India
select sum(population) Total_population from newpopulation_data;

-- Average growth rate
select round(avg(growth),2) average_growth from population_data;

-- Average growth by state
select state,round(avg(growth),2) Average_growth_by_state from population_data group by state order by 2 desc;

-- Average Sex Ratio by State
select state, round(avg(sex_ratio),0) average_sex_ratio_by_state from population_data group by state order by average_sex_ratio_by_state desc;

-- States with an average literacy ratio greater than 90
select state,round(avg(literacy),0) average_literacy_ratio_by_state from population_data group by state having 
average_literacy_ratio_by_state>90 order by 2 desc;

-- Top 3 states with highest average_growth
select state,round(avg(growth),0) average_growth from population_data group by state order by average_growth desc limit 3;

-- States with the least average sex ratio 
select state,round(avg(sex_ratio),0) average_sex_ratio_by_state from population_data group by state order by average_sex_ratio_by_state 
asc limit 3;

-- Three States with the highest and lowest average literacy rate
select * from
(select state,round(avg(literacy)) average_literacy_by_state from population_data group by state order by average_literacy_by_state desc limit 3)a
union all 
select * from 
(select state,round(avg(literacy)) average_literacy_by_state from population_data group by state  order by average_literacy_by_state  limit 3)b;

-- States starting with Letter "A"
select distinct state from population_data where state like "a%" or state like "b%" order by 1;

-- States starting with Letter "A" or ending with letter "M"
select distinct state from population_data where state like "a%" and state like "%m";

-- Male and Female count by districts
 select state,district,male_count,round((population-male_count)) female_count from
(select district,state,population,round((population/(sex_ratio+1))) male_count from
(select pd.district,pd.state,pd.sex_ratio/1000 sex_ratio,npd.population from population_data pd inner join newpopulation_data npd on 
pd.district=npd.district)a)b order by state;

-- Male and Female count by state
select state,sum(male_count) Males,sum(female_count) Females from 
(select state,male_count,(population-male_count) as female_count from
(select state,population,round((population/(sex_ratio+1))) male_count from 
(select pd.state,pd.sex_ratio/1000 sex_ratio,npd.population from population_data pd inner join newpopulation_data npd on 
pd.district=npd.district)a)b)c group by state order by 3 desc;

-- Literacy rate by Districts
with literacy_ratio_cte as 
(select pd.district,pd.state,pd.literacy/100 literacy_ratio,npd.population from population_data pd join newpopulation_data npd on 
pd.district=npd.district)
select state,district,round(literacy_ratio*population)literate_people, round((1-literacy_ratio)*population) 
Illitrate_people from literacy_ratio_cte order by state;

-- Literacy rate by State 
select state,sum(literate_people) Total_Literates,sum(illitrate_people) Total_Illitrates from 
(with literacy_ratio_cte as 
(select pd.district,pd.state,pd.literacy/100 literacy_ratio,npd.population from population_data pd join newpopulation_data npd on 
pd.district=npd.district)
select state,round(literacy_ratio*population)literate_people, round((1-literacy_ratio)*population) 
Illitrate_people from literacy_ratio_cte  order by state)a group by state order by 2 desc;

-- Population in the previous census by districts
select state,district,round((population/(1+growth))) previous_census_population,population as current_census_population from
(select pd.district,pd.state,pd.growth/100 as growth,npd.population from population_data pd join newpopulation_data npd on pd.district=
npd.district)a order by 1;

-- Population in the previous census by state
select state,sum(previous_census_population) Previous_census_population,sum(current_census_population) current_census_population from 
(select state,district,round((population/(1+growth))) previous_census_population,population as current_census_population from
(select pd.district,pd.state,pd.growth/100 as growth,npd.population from population_data pd join newpopulation_data npd on pd.district=
npd.district)a order by 1)a group by state order by 2 desc;

-- Total Indian Population in Previous Census and Current Census
select sum(previous_census_population) previous_census_population, sum(current_census_population) current_census_population from 
(select state,sum(previous_census_population) Previous_census_population,sum(current_census_population) current_census_population from 
(select state,district,round((population/(1+growth))) previous_census_population,population as current_census_population from
(select pd.district,pd.state,pd.growth/100 as growth,npd.population from population_data pd join newpopulation_data npd on pd.district=
npd.district)a order by 1)a group by state order by 1)b;

-- Land per capita analysis  
select round((total_land_area_km2/previous_census_population),4) previous_census_land_per_capita,total_land_area_km2/current_census_population
current_census_land_per_capita from 
(select a.Total_land_area_km2,c.previous_census_population,c.current_census_population from 
(select 1 keyy,sum(area_km2) Total_land_area_km2 from newpopulation_data)a join
(select 1 keyy ,sum(previous_census_population) previous_census_population, sum(current_census_population) current_census_population from 
(select state,sum(previous_census_population) Previous_census_population,sum(current_census_population) current_census_population from 
(select state,district,round((population/(1+growth))) previous_census_population,population as current_census_population from
(select pd.district,pd.state,pd.growth/100 as growth,npd.population from population_data pd join newpopulation_data npd on pd.district=
npd.district)a order by 1)a group by state order by 1)b)c on a.keyy=c.keyy)d;

-- Three districts with highest literacy rate in each state
with literacy_cte as 
(select state,district,literacy,rank()over(partition by state order by literacy desc)literacy_rank from population_data)
select * from literacy_cte where literacy_rank<=3;

-- End of Project 
 





