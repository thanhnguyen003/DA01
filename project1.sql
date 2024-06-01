--ex1
Alter table public.sales_dataset_rfm_prj
Alter column ordernumber type numeric 
using (trim(ordernumber)::numeric)
Alter table public.sales_dataset_rfm_prj
Alter column quantityordered type numeric 
using (trim(quantityordered)::numeric)
Alter table public.sales_dataset_rfm_prj
Alter column priceeach type numeric 
using (trim(priceeach)::numeric)
Alter table public.sales_dataset_rfm_prj
Alter column priceeach type numeric 
using (trim(priceeach)::numeric)
Alter table public.sales_dataset_rfm_prj
Alter column orderlinenumber type numeric 
using (trim(orderlinenumber)::numeric)
Alter table public.sales_dataset_rfm_prj
Alter column sales type numeric 
using (trim(sales)::numeric)
Alter table public.sales_dataset_rfm_prj
Alter column orderdate type date 
using (trim(orderdate)::date)
Alter table public.sales_dataset_rfm_prj
Alter column msrp type numeric 
using (trim(msrp)::numeric);

--ex2
SELECT * FROM public.sales_dataset_rfm_prj
WHERE ORDERNUMBER IS NULL
OR QUANTITYORDERED IS NULL
OR PRICEEACH IS NULL
OR ORDERLINENUMBER IS NULL
OR SALES IS NULL
OR ORDERDATE IS NULL

--ex3
Alter table public.sales_dataset_rfm_prj
Add column contactlastname varchar
Alter table public.sales_dataset_rfm_prj
Add column contactfirstname varchar

Update public.sales_dataset_rfm_prj
Set contactfirstname = upper(left(sales_dataset_rfm_prj.contactfullname,1))||
substring(public.sales_dataset_rfm_prj.contactfullname from 2 for position('-' in sales_dataset_rfm_prj.contactfullname)-2)
	
Update public.sales_dataset_rfm_prj
Set contactlastname = upper(right(left(contactfullname,
position('-' in contactfullname)+1),1))
|| substring (contactfullname
from position ('-' in contactfullname)+2 
for length(contactfullname)-length(contactfirstname))

--ex4
Alter table public.sales_dataset_rfm_prj
Add column QTR_ID numeric
Alter table public.sales_dataset_rfm_prj
Add column month_id numeric
Alter table public.sales_dataset_rfm_prj
Add column year_id numeric

Update sales_dataset_rfm_prj
Set qtr_id= case
when extract(month from orderdate) between 1 and 3
Then 1
when extract(month from orderdate) between 4 and 6
Then 2
when extract(month from orderdate) between 7 and 9
Then 3
Else 4 end

Update sales_dataset_rfm_prj
Set month_id= extract (month from orderdate)
Update sales_dataset_rfm_prj
Set year_id= extract (year from orderdate)
--ex5
	--cách 1
with z as (Select quantityordered, 
(select avg(quantityordered) from sales_dataset_rfm_prj) as avg, 
(select stddev(quantityordered) from sales_dataset_rfm_prj) as stddev
from sales_dataset_rfm_prj)
Select quantityordered, (quantityordered-avg)/stddev as z_score
From z
where abs((quantityordered-avg)/stddev))>2
	--cách 2
with x as (select Q1-1.5*IQR as min_value, Q3+1.5*IQR as max_value
from
(Select percentile_cont(0.25) 
within group (order by quantityordered) as Q1,
percentile_cont(0.75) 
within group (order by quantityordered) as Q3,
percentile_cont(0.75) 
within group (order by quantityordered) -
percentile_cont(0.25) 
within group (order by quantityordered) as IQR
From sales_dataset_rfm_prj))
Select * from sales_dataset_rfm_prj
where quantityordered < (select min_value from x)
Or quantityordered > (select max_value from x)
