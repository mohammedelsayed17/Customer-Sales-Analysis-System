select * 
from [supermarket_sales - Sheet1]
----------- sales analysis----------
 --- total sales and profit by branch
 select branch ,sum(total) as total_sales , sum (gross_income) as total_profit 
 from [supermarket_sales - Sheet1]
 group by Branch 
 order by total_profit
 ---- total sales and profit by city 
 select city ,sum(Total) as total_sales ,sum(gross_income) as total_profit
 from [supermarket_sales - Sheet1]
 group by City
 order by total_profit
 ---- total sales and profit by product line 
 select Product_line,sum(Total) as total_sales,sum(gross_income) as total_profit 
 from [supermarket_sales - Sheet1]
 group by Product_line
 order by total_profit desc
 ----- Identify the most profitable product lines----
 select Product_line,sum(gross_income) as total_profit 
 from [supermarket_sales - Sheet1]
 group by Product_line
 order by total_profit desc

 ------------- coustomer analysis ------------
 --- total spending by customar type and gender 
 select Customer_type,Gender,sum(Total) as total_spending
 from [supermarket_sales - Sheet1]
 group by Customer_type,Gender
 order by Customer_type,Gender 
 --- average spending by customer type and gender-----
 select Customer_type,Gender,avg(Total) as average_total 
 from [supermarket_sales - Sheet1]
 group by Customer_type,Gender
 order by average_total desc
 ---- number of transaction by customer type and gender ----
 select Customer_type,Gender,COUNT(*)	as transaction_count
 from [supermarket_sales - Sheet1]
 group by Customer_type,Gender
 order by Customer_type,Gender
 ----maximum and minimum spending by customer and gender 
 select Customer_type,gender, max(total) as maximum,min(total) as minmum
 from [supermarket_sales - Sheet1]
 group by Customer_type,gender 
 order by Customer_type,gender 
 ---- invoice id where the minimum spending transaction ---- 
 select Invoice_ID
 from [supermarket_sales - Sheet1]
where Total= (select min(Total) from [supermarket_sales - Sheet1])
----spending distribution -----
select Customer_type,gender,
PERCENTILE_CONT(0.9)  within group (ORDER BY total) over (partition by customer_type )AS percentile_90
from [supermarket_sales - Sheet1]
order by Customer_type
----time based analysis -----
select Customer_type,gender ,
year(date ) as year,
MONTH(date)as month ,
sum(total) as total_spending 
from [supermarket_sales - Sheet1]
group by year(date) ,month(Date), Customer_type,Gender
order by total_spending desc
----- analysis total spending based on date(month) 
select month(Date),sum(total) as total_spending
from [supermarket_sales - Sheet1]
group by  MONTH(Date)
order by total_spending desc
---- analysis product line and total spending based on month 
select  Product_line,month(Date),sum(total) as total_spending
from [supermarket_sales - Sheet1]
group by Product_line, MONTH(Date)
order by MONTH(Date),total_spending desc
-------- rating --------
--- to get maximum and minimum and average of rating 
select min(Rating)as minimum ,max(Rating) as maximum,
Avg(Rating) as average_rating,COUNT(*) as total_rating
from [supermarket_sales - Sheet1]
----- get branch of the rating 10 
select Branch,City
from [supermarket_sales - Sheet1]
where Rating=10

---- relation between rating and frequnce of rating 
select Rating,count(*) as frequency
from [supermarket_sales - Sheet1]
group by Rating
order by frequency desc
---- date and time ------
---calculate daily total sales--
select Date as sales_date,sum(Total) as daily_sales
from [supermarket_sales - Sheet1]
group by Date
order by daily_sales desc
----Determine how sales are distributed across the days of the week
select DATENAME(WEEKDAY,Date)as day_of_week ,sum(total) as total_sales
from [supermarket_sales - Sheet1]
group by DATENAME(WEEKDAY,Date)
order by total_sales desc
------Analyze Sales by Time-----
select DATEPART(HOUR,Time) as sales_houre,sum(Total)as total_sales
from [supermarket_sales - Sheet1]
group by DATEPART(HOUR,Time)
order by sales_houre,total_sales desc
------ Basic Distribution of Payment Methods-----
select Payment,count(*) as transaction_count,sum(Total) astotal_sales,
ROUND(avg(total),2) asaverage_transaction_value 
from [supermarket_sales - Sheet1]
group by Payment
order by transaction_count desc
----- Analyze Payment Methods by Customer Type---
select Customer_type,Payment,count(*) as transaction_count,sum(Total) as total_sales
from [supermarket_sales - Sheet1]
group by Customer_type,Payment
order by Customer_type,transaction_count
------ Analyze Payment Methods by Gender---
select Gender,Payment,COUNT(*) as count_transaction,sum(total) as total_sales 
from [supermarket_sales - Sheet1]
group by Gender,Payment
order by Gender,count_transaction desc 
-----------Evaluate how payment method usage changes during the day --------
select Payment,DATENAME(HOUR,Time)as hour_of_day,sum(total)as total_sales
from [supermarket_sales - Sheet1]
group by Payment,DATENAME(HOUR,Time)
order by total_sales desc
--Correlation with Transaction Value: Check if high-value transactions are associated with specific payment methods
select Payment,round(AVG(Total),2) as avg_transaction_value 
from [supermarket_sales - Sheet1]
group by Payment
order by avg_transaction_value DESC
-----Evaluate Average Transaction Size and Profitability
select AVG(Total) as avg_transaction_size,AVG(gross_income) as avg_profitiablity
from [supermarket_sales - Sheet1]