--ex1
with a as (SELECT 
    EXTRACT(YEAR FROM transaction_date) AS yr,
    product_id,
    spend AS curr_year_spend,
    LAG(spend) OVER (
      PARTITION BY product_id 
      ORDER BY 
        product_id, 
        EXTRACT(YEAR FROM transaction_date)) AS prev_year_spend 
  FROM user_transactions)
  Select yr,product_id, curr_year_spend,prev_year_spend,
  Round(100*(curr_year_spend-prev_year_spend)/prev_year_spend,2)
  As yoy_rate
  From a
--ex2
with a as (select card_name, issue_year,issue_month,issued_amount,
Rank () over( partition by card_name order by issue_year,issue_month) as rnk 
From monthly_cards_issued)
Select card_name,issued_amount from a  
where rnk=1
Order by issued_amount desc
--ex3
with a as (select user_id,spend,transaction_date,
Rank()over(partition by user_id order by user_id, transaction_date) as rnk
From transactions)
Select user_id,spend,transaction_date from a 
where rnk = 3
--ex4
with a as (
select user_id,transaction_date,
Rank() over (partition by user_id order by transaction_date desc) as rank1,
Count(product_id) over (partition by user_id order by transaction_date desc) as purchase_count
from user_transactions)
Select distinct transaction_date,user_id,purchase_count
From a 
where rank1 =1
--ex5
with a as (select user_id,tweet_Date,tweet_count,
lag(tweet_count) over (partition by user_id order by user_id, tweet_date) as lag1,
lag(tweet_count,2) over (partition by user_id order by user_id, tweet_date) as lag2
From tweets)
Select user_id,tweet_date,
Case 
when lag1 is null and lag2 is null then round(cast (tweet_count as decimal)/1,2)
when lag2 is null then round(cast ((tweet_count+lag1) as decimal)/2,2)
else round(cast((tweet_count+lag1+lag2)as decimal)/3,2) END from a
--ex6:
WITH a AS (
    SELECT
        transaction_id,
        merchant_id, 
        credit_card_id, 
        amount, 
        transaction_timestamp,
        LEAD(transaction_timestamp) OVER (
            PARTITION BY merchant_id, credit_card_id, amount 
            ORDER BY transaction_timestamp
        ) as after_timestamp,
        60 * EXTRACT(hour FROM LEAD(transaction_timestamp) OVER (
            PARTITION BY merchant_id, credit_card_id, amount 
            ORDER BY transaction_timestamp
        )) + EXTRACT(minute FROM LEAD(transaction_timestamp) OVER (
            PARTITION BY merchant_id, credit_card_id, amount 
            ORDER BY transaction_timestamp
        )) -
        (60 * EXTRACT(hour FROM transaction_timestamp) + EXTRACT(minute FROM transaction_timestamp)) AS difference
    FROM transactions)
SELECT COUNT(merchant_id) AS payment_count
FROM a
WHERE difference <= 10
--ex7
  with x as (Select category,product,sum(spend) as total_spend,
Rank() over (partition by category order by sum(spend) desc) as rank1
From product_spend
where extract (year from transaction_date) = '2022'
Group by category,product)
Select category,product,total_spend from x
where rank1<=2
--ex8
with x as (SELECT 
  artists.artist_name,
  DENSE_RANK() OVER (
    ORDER BY COUNT(songs.song_id) DESC) AS artist_rank
FROM artists
INNER JOIN songs
  ON artists.artist_id = songs.artist_id
INNER JOIN global_song_rank AS ranking
  ON songs.song_id = ranking.song_id
WHERE ranking.rank <= 10
GROUP BY artists.artist_name)
Select artist_name,artist_rank
From x 
where artist_rank <=5
