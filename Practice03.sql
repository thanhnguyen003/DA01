--ex1
Select name from STUDENTS
where marks > 75
Order by right(name,3), Id
--ex2
select user_id, concat(left(upper(name),1),right(lower(name),length(name)-1)) as name from Users
--ex3
SELECT manufacturer,
concat('$',ROUND(sum(total_sales)/1000000),' ','million')
as sales FROM pharmacy_sales
Group by manufacturer
Order by sum(total_sales) DESC
--ex4
select extract(month from submit_date) as mth, product_id as product,
round(Avg(stars),2) as avg_stars from reviews 
Group by extract(month from submit_date), product_id
Order by extract(month from submit_date), product_id
--ex5
Select sender_id, count(message_id) as message_count from messages
where extract(Month from sent_date) ='08'and extract(year from sent_date) = '2022'
Group by sender_id
Order by count(message_id) DESC
Limit 2
--ex6
Select tweet_id from Tweets
where length(content) >15
--ex8
select count(id) from employees
where extract (year from joining_date)='2022' 
and extract(month from joining_date) between 01 and 07
--ex9
select position(right(left(first_name,5),1)in first_name) from worker
where first_name = 'Amitah'
--ex10
select substring(title from (length(winery)+2) for 4), title from winemag_p2
where country = 'Macedonia'
