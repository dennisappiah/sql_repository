/* --- SUBQUERIES----*/
SELECT channel, AVG(events) AS average_events
FROM (
SELECT DATETRUNC(day,occurred_at) AS day,
                channel, COUNT(*) as events
         FROM dbo.web_events 
         GROUP BY 1,2
) sub
GROUP BY channel
ORDER BY 2 DESC;

/* Refactor by CTEs */
WITH events AS (
    SELECT DATETRUNC(day,occurred_at) AS day,
                channel, COUNT(*) as events
         FROM dbo.web_events 
         GROUP BY 1,2
),
SELECT channel, AVG(events) AS average_events
FROM events
GROUP BY channel
ORDER BY 2 DESC;


-- Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.
WITH t1 AS (
    select 
	s.name salesRep,
	r.name regionName, 
	SUM(o.total_amt_usd) as total_amt
from dbo.region r
inner join dbo.sales_rep s
on s.region_id = r.id
inner join dbo.accounts a
on a.sales_rep_id = s.id
inner join dbo.orders o
on o.account_id =  a.id
group by s.name, r.name 
order by total_amt DESC ),

t2 AS (
    SELECT regionName, MAX(total_amt_used) max_amt
    FROM t1
    GROUP BY 1
)


SELECT t1.salesRep, t1.regionName, t1.total_amt
FROM t1
JOIN t2 ON t1.regionName = t2.regionName AND t1.total_amt = t2.max_amt;


--For the region with the largest sales total_amt_usd, how many total orders were placed?

WITH t1 AS (
    select 
	r.name regionName, 
	SUM(o.total_amt_usd) as total_amt
from dbo.region r
inner join dbo.sales_rep s
on s.region_id = r.id
inner join dbo.accounts a
on a.sales_rep_id = s.id
inner join dbo.orders o
on o.account_id =  a.id
group by s.name, r.name 
order by total_amt DESC ),
--region with highest total_amt
t2 AS (
      SELECT MAX(total_amt)
      FROM t1)

select 
    r.name regionName, 
    COUNT(o.total) total_orders
from dbo.region r
inner join dbo.sales_rep s
on s.region_id = r.id
inner join dbo.accounts a
on a.sales_rep_id = s.id
inner join dbo.orders o
on o.account_id =  a.id
group by s.name, r.name 
HAVING SUM(o.total_amt_usd) = (SELECT * FROM t2);