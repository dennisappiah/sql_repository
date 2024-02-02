-- LEFT, RIGHT, LENGHTH

--LEFT : retrieves a specified number of characters for each row starting from left
--CASE END: is a row-wise operation
--POSITION, STRPOS, & SUBSTR -POSITION takes a character and a column, and provides the index where that character is for each row.

--www.standard.com
SELECT website,
		LEFT(website, 3) web,  
		RIGHT(website, LEN(website)- 4)  as domain
FROM dbo.accounts



SELECT website,
	   CASE 
		   WHEN LEFT(website, 1) IN ('a', 'b') THEN 'Not website' 
		   WHEN LEFT(website, 1) IN ('w') THEN 'Not website'
	   END  as 'confirm_website'
FROM dbo.accounts


SELECT LEFT(primary_poc, STRPOS(primary_poc, ' ') -1 ) first_name, 
   RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name
FROM accounts;


-- With Windows Fnction, we can perform aggregation across rows (row-wise aggregation such as cumulatiive total)

select standard_qantity,
      SUM(standard_qantity) OVER (ORDER BY occurred_at) AS cumulative_running_total
from dbo.orders

--assming we want get the running_total by each month
SELECT
      standard_qantity,
	  DATETRUNC(MONTH, occurred_at) AS month,
      SUM(standard_qantity) OVER (PARTITION BY DATETRUNC(MONTH, occurred_at) ORDER BY occurred_at) AS cumulative_running_total
FROM dbo.orders