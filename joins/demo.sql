--create database ParchPosh
--use ParchPosh;

create table dbo.region 
(
id int not null primary key identity,
name varchar(50) not null
)

-- one sales_rep can have many accounts (one-to-many)
create table dbo.sales_rep 
(
id int not null primary key identity,
name varchar(50) not null,
region_id int not null,
constraint salesRep_region foreign key (region_id) references region(id)
on update cascade
on delete cascade
)

--Many accounts (standard, temporal, guest) can be belong by one sales_rep (many-to-one)
create table dbo.accounts
(
id int not null primary key identity,
name varchar(50) not null,
website varchar(100) not null,
--lat,
--long,
--primary_poc
sales_rep_id int not null,
constraint accounts_salesRep foreign key (sales_rep_id) references sales_rep(id) on delete cascade
)

-- many webevents can belong to one account (many to one)
create table dbo.web_events
(
id int not null primary key identity,
account_id int not null,
occurred_at date not null,
channel varchar(50) not null,
constraint webEvents_accounts foreign key (account_id) references accounts(id)
on update cascade
on delete cascade
)

-- many orders can belong to one account (many to one)
create table dbo.orders
(
id int not null primary key identity,
account_id int not null,
standard_qantity smallint not null,
poster_qantity smallint not null,
total smallint not null,
standard_amt_usd money not null,
gloss_amt_usd money not null,
poster_amt_usd money not null,
total_amt_usd money not null,
constraint orders_accounts foreign key (account_id) references accounts(id) 
on update cascade
on delete cascade
)

--add new columns after run
alter table ParchPosh.dbo.orders
add occurred_at date not null;



-- Joining two tables
SELECT o.*, a.*
FROM dbo.orders o
JOIN dbo.accounts a
ON o.account_id = a.id

--JOIN More than Two Tables
SELECT *
FROM dbo.web_events w
INNER JOIN dbo.accounts a
ON w.account_id = a.id
INNER JOIN dbo.orders o
ON a.id = o.account_id

--Provide a table for all web_events associated with account name of StandardAccont.
select a.name, w.channel
from dbo.web_events w
inner join dbo.accounts a
on w.account_id = a.id
where a.name = 'StandardAccont';

-- Provide a table that provides the region for each sales_rep along with their associated accounts.
use ParchPosh;

select r.name region, s.name rep, a.name account
from dbo.sales_rep s
inner join dbo.region r
on s.region_id = r.id
inner join dbo.accounts a 
on a.sales_rep_id = s.id
order by a.name ASC


---Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. 

select r.name region, a.name account, 
           o.total_amt_usd/(o.total + 0.01) unit_price
from dbo.region r
inner join dbo.sales_rep s
on s.region_id = r.id
join accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id;


-- JOINS AND FILERING

--Provide a table that provides the region for each sales_rep along with their associated accounts. This time only for the kumasi region.

select r.name Region, s.name SalesRep, a.name AccountName
from dbo.sales_rep s 
inner join dbo.region r on 
s.region_id = r.id
inner join dbo.accounts a on
a.sales_rep_id = s.id
where r.name = 'Kumasi'

-- GROUP BY
select o.account_id, SUM(o.standard_qantity) standard_sum , SUM(o.poster_qantity) poster_sum
from dbo.orders o
group by o.account_id
having SUM(o.standard_qantity)  > 10
order by o.account_id


-- Which account (by name) placed the earliest order?
use ParchPosh

select top 1 a.name account_name, o.occurred_at order_date
from dbo.orders o
inner join dbo.accounts a
on o.account_id = a.id
order by o.occurred_at

-- Find the total sales in usd for each account. 
--You should include two columns - the total sales for each company's orders in usd and the company name.

select a.name,  SUM(o.total) total_sales
from dbo.orders o
inner join dbo.accounts a
on o.account_id = a.id
group by a.name 


-- Group items rowswise without Aggregation, using DISTINCT
SELECT DISTINCT account_id, channel
FROM dbo.web_events
ORDER BY account_id

-- GROUPING BY DATES
-- DATETRUNC  - returns an input date truncated to a specified datepart. (year, day, month)

select DATETRUNC(YEAR, o.occurred_at) as Year , SUM(o.standard_qantity) as total_standard
from dbo.orders o
group by DATETRUNC(YEAR, o.occurred_at)


select DATEPART(YEAR, o.occurred_at) as Year , SUM(o.standard_qantity) as total_standard
from dbo.orders o
group by DATEPART(YEAR, o.occurred_at)
