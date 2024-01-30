-- Always start from the inner query

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


-- using subqueries for filtering

select *
 from dbo.orders
 where DATETRUNC(month, occurred_at) = 
(select DATETRUNC(month, min(occurred_at)) min_month
from dbo.orders)
order by occurred_at



use ParchPosh;

-- Q1. Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.
select 
	s.name salesRep,
	r.name regionName, 
	SUM(o.total_amt_usd) as total_amt_used
from dbo.region r
inner join dbo.sales_rep s
on s.region_id = r.id
inner join dbo.accounts a
on a.sales_rep_id = s.id
inner join dbo.orders o
on o.account_id =  a.id
group by s.name, r.name 
order by total_amt_used DESC

---- Next, I pulled the max for each region, and then we can use this to pull those rows in our final result.


(SELECT regionName, MAX(total_amt_used) max_amt
	FROM (select 
			s.name salesRep,
			r.name regionName, 
			SUM(o.total_amt_usd) as total_amt_used
		from dbo.region r
		inner join dbo.sales_rep s
		on s.region_id = r.id
		inner join dbo.accounts a
		on a.sales_rep_id = s.id
		inner join dbo.orders o
		on o.account_id =  a.id
		group by s.name, r.name ) t1
GROUP BY regionName)

---- this is a JOIN of these two tables, where the region and amount match.
SELECT t3.regionName, t3.salesRep, t3.total_amt_used
FROM
(SELECT regionName, MAX(total_amt_used) max_amt
	FROM (select 
			s.name salesRep,
			r.name regionName, 
			SUM(o.total_amt_usd) as total_amt_used
		from dbo.region r
		inner join dbo.sales_rep s
		on s.region_id = r.id
		inner join dbo.accounts a
		on a.sales_rep_id = s.id
		inner join dbo.orders o
		on o.account_id =  a.id
		group by s.name, r.name ) t1
GROUP BY regionName) t2
INNER JOIN (select 
		s.name salesRep,
		r.name regionName, 
		SUM(o.total_amt_usd) as total_amt_used
	from dbo.region r
	inner join dbo.sales_rep s
	on s.region_id = r.id
	inner join dbo.accounts a
	on a.sales_rep_id = s.id
	inner join dbo.orders o
	on o.account_id =  a.id
	group by s.name, r.name 

) t3
ON t3.regionName = t2.regionName and t3.total_amt_used = t2.max_amt



--Q2. For the region with the largest sales total_amt_usd, how many total orders were placed?

-- The first query I wrote was to pull the total_amt_usd for each region and select max
select top 1
	r.name regionName, 
	SUM(o.total_amt_usd) as total_amt
from dbo.region r
inner join dbo.sales_rep s
on s.region_id = r.id
inner join dbo.accounts a
on a.sales_rep_id = s.id
inner join dbo.orders o
on o.account_id =  a.id
group by  r.name
order by total_amt desc


select 
	r.name regionName, 
	COUNT(o.total) as total_orders
from dbo.region r
inner join dbo.sales_rep s
on s.region_id = r.id
inner join dbo.accounts a
on a.sales_rep_id = s.id
inner join dbo.orders o
on o.account_id =  a.id
group by  r.name
having SUM(o.total_amt_usd) = ( 
		SELECT total_amt
		FROM (select top 1
			r.name regionName, 
			SUM(o.total_amt_usd) as total_amt
		from dbo.region r
		inner join dbo.sales_rep s
		on s.region_id = r.id
		inner join dbo.accounts a
		on a.sales_rep_id = s.id
		inner join dbo.orders o
		on o.account_id =  a.id
		group by  r.name
		order by total_amt desc) t1)