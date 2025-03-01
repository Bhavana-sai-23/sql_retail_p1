create database sql_project_p2;

create table retail_sales(transactions_id INT PRIMARY KEY,	sale_date DATE,
sale_time TIME, --CHECK the date format in year month date to change it select the column in sql then click on %number->date and select the wanted format 
customer_id INT,
gender VARCHAR(10),	age INT,
category VARCHAR(20),
quantiy INT,
price_per_unit FLOAT,
cogs FLOAT,
total_sale FLOAT);

select * from retail_sales
LIMIT 10;

--COUNT NO OF ROWS
select count(*) from retail_sales;

--check each column if you have any null values
select * from retail_sales
where transactions_id is null;

--data cleaning
select * from retail_sales
where sale_date is null
or customer_id is null
or gender is null
or age is null
or category is null
or quantiy is null
or price_per_unit is null
or cogs is null
or total_sale is null;

--delete the null values
delete from retail_sales where
sale_date is null
or customer_id is null
or gender is null
or age is null
or category is null
or quantiy is null
or price_per_unit is null
or cogs is null
or total_sale is null;

--data exploration
--how many sales we have
select count(*) as total_sales from retail_sales;

--how many customers we have,distinct-unique value
select count( distinct customer_id) as total_sales from retail_sales;


--category
select count( distinct category) as total_sales from retail_sales;
--if you want to list the value remove count
select distinct category as total_sales from retail_sales;

--DATA ANALYSIS / BUSINESS KEY PROBLEMS OR ANSWERS
--1.write a query to retrive all columns for sales mahe on 2022-11-05
select * from retail_sales 
where sale_date='2022-11-05';


--2. write a sql query to retrive all transactions where the category is clothing and the quantity sold is more than 4 in the month of nov-2022
select category,sum(quantiy)
from retail_sales
where category='Clothing'
group by 1

Select *
from retail_sales
where category='Clothing'
and to_char(sale_date,'YYYY-MM')='2022-11'
and quantiy>='4';

--3.write a sql query to calcualte the total_sales for each category
select 
category, sum(total_sale) as net_sale,
count(*) as total_orders-- specifices the number of orders how many clothing, electonics,beauty
from retail_sales
group by 1 ;

--4. write a sql query to find the average age of customers who purchased items from the beauty category
select (age), category from retail_sales
where category ='Beauty';

--to make a suitable value use round
select round(avg(age),2) as average_age from retail_sales
where category ='Beauty';

--5.write a query to find all transactions where the total_sales is greater than 1000
select * from retail_sales 
where total_sale>1000;

--6. write a query to find the total number of transactions (transaction_id) made by each gender in each category
select category,gender, count(*) as total_trans
from retail_sales
group by 1,2
order by 1

--7. write a query to calculate the average sale for each month. Find out best selling month in each year
select* from(
select  
extract (year from sale_date) as year,
extract (month from sale_date) as month,
avg(total_sale) as total,
rank() over(partition by extract(year from sale_date) order by avg(total_sale)desc)
from retail_sales
group by 1,2) as t1
where rank=1;

select year,month, total from(
select  
extract (year from sale_date) as year,
extract (month from sale_date) as month,
avg(total_sale) as total,
rank() over(partition by extract(year from sale_date) order by avg(total_sale)desc)
from retail_sales
group by 1,2) as t1
where rank=1;

order by 1,3 ;

--8.write a query to find the top 5 customers based on the highest total sales
select customer_id,
sum(total_sale)
from retail_sales
group by 1
order by 2 desc
limit 5;


--9 write a query to find the number of unique customers who purchased items from each category
select count(distinct customer_id) as unique_id , category
from retail_sales
group by 2

--10 write a query to create each shift and number of orders (eg: morning <=12, afternoon between 12&17, evening>17)
select *,
case when extract(hour from sale_time)<12 then 'morning'
when extract(hour from sale_time) between 12 and 17 then 'afternoon'
else 'evening' end as shift
from retail_sales
