-- Creating the database/schema
create database pizzeria;

-- Using the "pizzeria" database as the default database
use pizzeria;

-- Creating the orders table
create table orders(row_id int primary key,order_id varchar(10),created_at datetime,item_name varchar(50),item_category varchar(50),
item_size varchar(20), item_price decimal(5,2),quantity int,customer_firstname varchar(50),customer_lastname varchar(50),
delivery boolean,delivery_address1 varchar(200),delivery_address2 varchar(200),delivery_city varchar(50),delivery_zipcode varchar(20));
select * from orders;
desc orders;

-- Creating the customers table
create table customers(customer_id int not null,customer_first_name varchar(50),customer_last_name varchar(50));
-- Adding a primary key to the customers table
alter table customers modify column customer_id int not null unique;
select * from customers;
describe customers;
-- Adding a new column (cust_id) to the orders table
alter table orders add column cust_id int;
-- Adding a foreign key (cust_id) to the orders table
alter table orders add foreign key (cust_id) references customers(customer_id);
-- Deleting the customer-columns from the orders table due to normalization
alter table orders drop column customer_firstname, drop column customer_lastname;

-- Creating the address table
create table address(address_id int,delivery_address1 varchar(200),delivery_address2 varchar(200),delivery_city varchar(50),
delivery_zipcode varchar(20));
select * from address;
desc address;
-- Adding a primary key to the address table
alter table address add primary key(address_id);
-- Adding a new column (add_id) to the orders table
alter table orders add column add_id int;
-- Adding a foreign key (add_id) on the orders table
alter table orders add foreign key (add_id) references address(address_id);
-- Deleting address-related columns from the orders table due to normalization
alter table orders drop column delivery_address1,drop column delivery_address2,drop column delivery_city,drop column delivery_zipcode;

-- Creating the item table
create table item(item_id varchar(10) primary key,item_sku varchar(20),item_name varchar(100),item_category varchar(100),item_size varchar(10),
item_price decimal(5,2));
select * from item;
desc item;
-- Adding a new column (item_id) to the orders table
alter table orders add column item_id varchar(10);
-- Adding a foreign key to the orders table
alter table orders add foreign key(item_id) references item(item_id);
-- Deleting item-related columns from the orders table due to normalization
alter table orders drop column item_name, drop column item_category, drop column item_size, drop column item_price;

-- Creating the recipe table
create table recipe (row_id int primary key,recipe_id varchar(20),ing_id varchar(10),quantity int);
select * from recipe;
desc recipe;
-- Adding a unique key to the item_sku column 
alter table item modify column item_sku varchar(20) unique;
-- Adding a foreign key (recipe_id) on the recipe table
alter table recipe add foreign key (recipe_id) references item(item_sku);

-- Creating the ingredient table
create table ingredient(ing_id varchar(10) primary key, ing_name varchar(200),ing_weight int, ing_measurements varchar(20), ing_price decimal(5,2));
select * from ingredient;
desc ingredient;
-- Adding a foreign key (ing_id) to the recipe table
alter table recipe add foreign key (ing_id) references ingredient(ing_id);

-- Creating the inventory table
create table inventory(inv_id int primary key,item_id varchar(10),quantity int);
select * from inventory;
desc inventory;
-- Adding a unique key to the (item_id) column in the inventory table
alter table inventory modify column item_id varchar(10) unique; 
-- Adding a foreign key (ing_id) on the recipe table
alter table recipe add foreign key (ing_id) references inventory(item_id); 

-- Creating the rota table
create table rota(row_id int primary key, rota_id varchar(20),date datetime,shift_id varchar(20), staff_id varchar(20));
select * from rota;
desc rota;
-- Adding a unique key to the (created_at) column in the orders table 
alter table orders modify column created_at datetime unique;
-- Adding a foreign key to the (date) column in the rota table
alter table rota add foreign key (date) references orders(created_at); 

-- Creating the staff table
create table staff(staff_id varchar(20) primary key,first_name varchar(50),last_name varchar(50),position varchar(100),
hourly_rate decimal(5,2));
select * from staff;
desc staff;
-- Adding a foreign key (staff_id) to the rota table
alter table rota add foreign key(staff_id) references staff(staff_id);

-- Creating a shift table
create table shift(shift_id varchar(20) not null unique,day_of_week varchar(10),start_time time,end_time time);
select * from shift;
describe shift;
-- Adding a foreign key (shift_id) to the rota table 
alter table rota add foreign key (shift_id) references shift(shift_id);

-- End of Project 