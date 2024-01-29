--create database sampledb;
go

--use sampledb;

-- A company can have many locations (one-to-many)
-- A company can have many jobs
create table dbo.Companies
(
 id int not null primary key identity,
 companyName varchar(50) not null,
 phoneNumber varchar(50) not null,
 emailAddress varchar(50) not null,
)

create table dbo.Employees 
(
 id int not null primary key identity,
 firstName varchar(50) not null,
 lastName varchar(50) not null,
 emailAddress varchar(50) not null,
 payRate money not null,
 billRate  money not null
)

-- Many jobs can belong to one company
create table dbo.Jobs 
(
 id int not null primary key identity,
 jobName  varchar(50) not null,
 company_id int not null,
 constraint jobs_company foreign key (company_id) references Companies(id) on update no action on delete no action
)

-- Many locations can belong to one company
create table dbo.Locations
(
 id int not null primary key identity,
 streetAddress  varchar(50) not null,
 city  varchar(50) not null,
 state  varchar(50) not null,
 company_id int not null,
 constraint locations_company foreign key (company_id) references Companies(id) on update no action on delete no action
)

create table dbo.WorkDone
(
 id int not null primary key identity,
 employee_id int not null,
 job_id int not null,
 location_id int not null,
 hoursWorked int not null,
 description varchar(50) not null ,
 datePerformed date not null,
 constraint workdone_employees foreign key (employee_id) references Employees(id) on update no action on delete no action,
 constraint workdone_jobs foreign key (job_id) references Jobs(id) on update no action on delete no action,
 constraint workdone_locations foreign key (location_id) references Locations(id) on update no action on delete no action
)
go


/* Insert Tables Stored Procedures*/
create proc dbo.spInsertCompany
	 @companyName varchar(50),
	 @phoneNumber varchar(50), 
	 @emailAddress varchar(50) 
as
	insert into dbo.Companies (companyName, phoneNumber, emailAddress)
	values
	(@companyName, @phoneNumber, @emailAddress)

go

create proc dbo.spInsertEmployee
	 @firstName varchar(50),
	 @lastName varchar(50), 
	 @emailAddress varchar(50) 
as
	insert into dbo.Employees(firstName, lastName, emailAddress)
	values
	(@firstName, @lastName, @emailAddress)

go

create proc dbo.spInsertJob
	 @jobName varchar(50),
	 @company_id int
as
	insert into dbo.Jobs(jobName, company_id)
	values
	(@jobName, @company_id)

go

create proc dbo.spInsertLocation
	 @streetAddress  varchar(50),
	 @city  varchar(50),
	 @state  varchar(50),
	 @company_id int 
as
	insert into dbo.Locations(streetAddress, city,state, company_id)
	values
	(@streetAddress,  @city ,  @state, @company_id )

go

create proc dbo.spInsertWorkdone
	@employee_id int ,
	@job_id int ,
	@location_id int,
	@hoursWorked int,
	@description varchar(50),
	@datePerformed date 
as
	insert into dbo.WorkDone(employee_id, job_id, location_id, hoursWorked, description, datePerformed)
	values
	(@employee_id, @job_id, @location_id, @hoursWorked, @description, @datePerformed )

go

/* Update Tables Stored Procedures */

create proc dbo.spUpdateCompany
	@id int,
	@companyName varchar(50),
	@phoneNumber varchar(50), 
	@emailAddress varchar(50) 
as 
	update dbo.Companies
	set 
	companyName = @companyName,
	phoneNumber = @phoneNumber,
	emailAddress = @emailAddress
	where id = @id

go
create proc dbo.spUpdateEmployee
	 @id int,
	 @firstName varchar(50),
	 @lastName varchar(50), 
	 @emailAddress varchar(50)
as
	update dbo.Employees
	set 
	firstName = @firstName,
	lastName = @lastName,
	emailAddress = @emailAddress
	where id = @id

go

/* Delete Tables Stored Procedures */
create proc dbo.spDeleteEmployee
(
	@id int
)
AS
	delete from dbo.Employees
	where id = @id

go

exec dbo.spInsertCompany 'Vodafone', '055678887890', 'vodafone@gmail.com'
exec dbo.spInsertCompany 'Mtn', '05567888788', 'mtn@gmail.com'
exec dbo.spInsertCompany 'Glo', '055678887890', 'glo@gmail.com'
exec dbo.spInsertCompany 'Telecel', '055678887890', 'telecel@gmail.com'
exec dbo.spInsertCompany 'Airtel', '055678887890', 'airtel@gmail.com'

exec dbo.spInsertEmployee 'Dennis', 'Owusu', 'dennis@gmail.com'
exec dbo.spInsertEmployee 'Godfred', 'Appiah', 'fred@gmail.com'
exec dbo.spInsertEmployee 'Travis', 'Appiah', 'travis@gmail.com'
exec dbo.spInsertEmployee 'Alberta', 'Owusu', 'alby@gmail.com'
exec dbo.spInsertEmployee 'Hilda', 'Amosua', 'hilda@gmail.com'


exec dbo.spInsertJob @jobName='Manufacturing Services', @company_id = 1 
exec dbo.spInsertJob @jobName='Cleaning Services', @company_id = 1 
exec dbo.spInsertJob @jobName='Teaching Services', @company_id = 2
exec dbo.spInsertJob @jobName='Engineering Services', @company_id = 2
exec dbo.spInsertJob @jobName='Repairing Services', @company_id = 3

exec dbo.spInsertLocation @streetAddress='Achimota', @city='Accra', @state='GR', @company_id=1
exec dbo.spInsertLocation @streetAddress='Lastown', @city='Accra', @state='GR', @company_id=132
exec dbo.spInsertLocation @streetAddress='Afienya', @city='kumasi', @state='AR', @company_id=2
exec dbo.spInsertLocation @streetAddress='Kokobeng', @city='kumasi', @state='AR', @company_id=2
exec dbo.spInsertLocation @streetAddress='BusStop', @city='Tamale', @state='GR', @company_id=3

exec dbo.spInsertWorkdone 
@employee_id = 1, @job_id = 1, @location_id = 1, @hoursWorked = 8, @description = 'Fixed the knob', @datePerformed='1/28/2019'
exec dbo.spInsertWorkdone 
@employee_id = 1, @job_id = 1, @location_id = 1, @hoursWorked = 2, @description = 'Maintained the roof', @datePerformed='1/29/2019'
exec dbo.spInsertWorkdone 
@employee_id = 2, @job_id = 2, @location_id = 2, @hoursWorked = 18, @description = 'Cleaned the floor', @datePerformed='1/30/2019'
exec dbo.spInsertWorkdone 
@employee_id = 2, @job_id = 2, @location_id = 2, @hoursWorked = 12, @description = 'Cleaned the room', @datePerformed='1/31/2019'
exec dbo.spInsertWorkdone 
@employee_id = 3, @job_id = 3, @location_id = 3, @hoursWorked = 50, @description = 'Repaired the computer', @datePerformed='2/01/2019'


-- Inner Join
select c.companyName, l.city
from  dbo.Companies c
inner join dbo.Locations l on l.company_id = c.id

-- left Join
select c.companyName, l.city
from  dbo.Companies c
left join dbo.Locations l on l.company_id = c.id

-- right Join
select c.companyName, l.city
from  dbo.Companies c
right join dbo.Locations l on l.company_id = c.id


-- Multiple Join
select 
	c.companyName,
    w.hoursWorked,
	w.description as 'Explanation of Work',
	e.firstName + ' ' + e.lastName as 'FullName',
	j.jobName,
	l.city,
	l.state
from dbo.Workdone w
inner join dbo.Employees e on w.employee_id = e.id 
inner join dbo.Jobs j on w.job_id = j.id
inner join dbo.Locations l on w.location_id = l.id
--which company is the location for?
inner join dbo.Companies c on l.company_id = c.id


-- group by -- GROUP BY (total work hours by each customer, employees)
select 
	c.companyName, 
	e.firstName,
	SUM(w.hoursWorked) totalWorkHours
from dbo.Workdone w
inner join dbo.Employees e on w.employee_id = e.id 
inner join dbo.Jobs j on w.job_id = j.id
inner join dbo.Locations l on w.location_id = l.id
--which company is the location for?
inner join dbo.Companies c on l.company_id = c.id
group by c.companyName, e.firstName
having SUM(w.hoursWorked) > 10
order by c.companyName

-- UNION (ALL)
select c.companyName  Name , c.emailAddress
from dbo.Companies c
UNION ALL
select e.firstName + ' ' + e.lastName as 'Name', e.emailAddress
from dbo.Employees e
go