--ex1 select * from public.sales_dataset_rfm_prj
Select sum(sales), productline,year_id,dealsize
from public.sales_dataset_rfm_prj
Group by productline,year_id,dealsize
Order by productline, year_id, dealsize
--ex2
select month_id,max(revenue), max(order_number) 
from (Select sum(sales) as revenue, count(ordernumber) as order_number, 
month_id
from public.sales_dataset_rfm_prj
Group by month_id
Order by month_id) a
group by month_id
--ex3
select productline, month_id, revenue,order_number from (select productline, month_id,sum(sales) as revenue,count(ordernumber) as order_number
from public.sales_dataset_rfm_prj
Group by productline, month_id) a
where month_id = 11
Order by productline, month_id
--ex4 Đâu là sản phẩm có doanh thu tốt nhất ở UK mỗi năm? Xếp hạng các các doanh thu đó theo từng năm
select year_id,country,productline,revenue,rank from (select year_id,country,productline,sum(sales) as revenue, 
rank () over(partition by year_id,country order by sum(sales) desc) as rank
From public.sales_dataset_rfm_prj
Group by country, year_id, productline) a
where country = 'UK'
And rank = 1
--ex5 Ai là khách hàng tốt nhất, phân tích dựa vào RFM (sử dụng lại bảng customer_segment ở buổi học 23)
create table segment
(segment varchar,
	Score varchar)

with a as (
Select distinct customername, current_date - max(orderdate) as  R,
Count(distinct ordernumber) as F,
Sum(sales) as M
From public.sales_dataset_rfm_prj
Group by customername),
rfm_score as (
Select customername,
Ntile(5) over(order by R desc) as r_score,
Ntile(5) over(order by F) as f_score,
Ntile(5) over(order by m) as m_score
From a),
rfm_final as (
Select customername,
cast (r_score as varchar) || cast (f_score as varchar) || cast( m_score as varchar) as rfm_score
From rfm_score)

Select a.customername, b.segment,a.rfm_score
From
Rfm_final a
Join segment b on a.rfm_score = b.score
where b.segment = 'Champions' 
