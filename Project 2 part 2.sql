--phần 1
Create view vw_ecommerce_analyst as (
WITH monthly_revenue AS (
  SELECT
    FORMAT_TIMESTAMP('%Y-%m', created_at) AS month,
    SUM(sale_price) AS monthly_rev,
    COUNT(order_id) AS monthly_order
  FROM
    bigquery-public-data.thelook_ecommerce.order_items
  GROUP BY
    month
),
lagged_revenue AS (
  SELECT
    month,
    monthly_rev,
    monthly_order,
    LAG(monthly_rev) OVER (ORDER BY month) AS premon_rev,
    LAG(monthly_order) OVER (ORDER BY month) AS premon_order
  FROM
    monthly_revenue
),
t AS (
  SELECT
    month,
    CASE 
      WHEN premon_rev IS NULL THEN 100
      ELSE ((monthly_rev - premon_rev) / premon_rev) * 100
    END AS revenue_growth,
    CASE 
      WHEN premon_order IS NULL THEN 100
      ELSE ((monthly_order - premon_order) / premon_order) * 100
    END AS order_growth
  FROM
    lagged_revenue
)
SELECT 
  t.month, 
  t.revenue_growth,
  t.order_growth,
  EXTRACT(YEAR FROM c.created_at) AS year,
  b.category AS product_category,
  SUM(d.sale_price) OVER (PARTITION BY t.month ORDER BY t.month) AS TPV,
  COUNT(d.order_id) OVER (PARTITION BY t.month ORDER BY t.month) AS TPO,
  SUM(b.cost) OVER (PARTITION BY t.month ORDER BY t.month) AS total_cost,
  SUM(d.sale_price) OVER (PARTITION BY t.month ORDER BY t.month) - 
  SUM(b.cost) OVER (PARTITION BY t.month ORDER BY t.month) AS total_profit,
  SUM(d.sale_price) OVER (PARTITION BY t.month ORDER BY t.month) / 
  SUM(b.cost) OVER (PARTITION BY t.month ORDER BY t.month) AS profit_to_cost_ratio
FROM 
  t
JOIN 
  bigquery-public-data.thelook_ecommerce.orders AS c
ON 
  FORMAT_TIMESTAMP('%Y-%m', c.created_at) = t.month
JOIN 
  bigquery-public-data.thelook_ecommerce.order_items AS d
ON 
  d.order_id = c.order_id
JOIN 
  bigquery-public-data.thelook_ecommerce.products AS b
ON 
  b.id = d.product_id
ORDER BY 
  t.month)

--phần 2
with cte as 
(Select User_id, 
FORMAT_TIMESTAMP('%Y-%m', first_purchase_date) as cohort_date,
Created_at,
(extract(year from Created_at)-extract(year from first_purchase_date))*12 + (extract(month from created_at)-extract(month from first_purchase_date)) +1 as index
From (Select user_id,
min(created_at) over(partition by user_id) as first_purchase_date,
created_at 
from 
bigquery-public-data.thelook_ecommerce.order_items) z),
data_Customer_cohort as(
Select cohort_date,index,
Count(distinct user_id) as cnt,
FROM cte
where index <=3
Group by cohort_date, index
ORDER BY 
cohort_date, 
index),
--customer_cohort
customer_cohort as (Select cohort_date,
Sum(case when index=1 then cnt else 0 end) as m1,
Sum(case when index=2 then cnt else 0 end) as m2,
Sum(case when index=3 then cnt else 0 end) as m3,
From data_customer_cohort
Group by cohort_date
order by cohort_date)
--retention_cohort
Select cohort_date,
Round(100.00*m1/m1,2)||'%' as m1,
Round(100.00*m2/m1,2)||'%' as m2,
Round(100.00*m3/m1,2)||'%' as m3
From customer_cohort
/* insight cho doanh nghiệp:
Tỉ lệ giữ chân KH đang quá kém, chỉ ở mức 3-5% ở m2 và <3% ở m3. Điều này có thể liên quan tới các vấn đề như chất lượng sản phẩm, dịch vụ sau bán hàng, CSKH...
Vì vậy, điều doanh nghiệp cần làm bây giờ là tìm hiểu, nắm bắt ý kiến và phản hồi của khách hàng; sau đó, có thể đưa ra các chiến lược liên quan tới thay đổi, tạo sự độc đáo cho sản phẩm, khuyến mãi cho KH trung thành hoặc cải thiện dịch vụ hậu mãi.*/
