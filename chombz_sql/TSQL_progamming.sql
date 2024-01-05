/*This session is the introduction of Programming Transact-SQL */



/*        17/11/2021             */

--switch databases
USE Edwin_Customer_DB_2105;


--Create a batch
Begin Transaction
--Create a Company table
	if (object_id('Company')) is null --check if the company table exists in the db
	Create Table Company
	(
		IDNum int identity(100,5),
		CompanyName nvarchar(100)
	);
	else
Print 'The company table already exists'
--Insert records into the Company table
Insert into Company
values
	('A Bike Store'),
	('Progressive Sports'),
	('Modular Cycle Streams'),
	('Advanced Bike Components'),
	('Metropolitan Sports Supple'),
	('Aerobics Exercise Company'),
	('Associated Bikes'),
	('Exemplary Cycles')
--Display the companies in ascending order
Select IDNum as [CompanyID], CompanyName as [Name of Company]
from Company
Order by [Name of Company]
commit; --rollback



--Use a local variable to hold a value with the last namw
--to be retrieved
DECLARE @find nvarchar(30)= 'Man%';
SELECT CONCAT(P.FirstName, ' ', P.LastName) as [Employee Names], PP.PhoneNumber as [PhoneNumber]
from AdventureWorks2016.Person.Person P
JOIN AdventureWorks2016.Person.Person PP
ON
P.BusinessEntityID = PP.BusinessEntityID
WHERE
P.LastNAme 
LIKE @find;



--Declare a variable and set/assign its value
Declare @myVar nchar(40);
Set @myVar = 'This is a test variable';
--Display the contents of myVar
Select @myVar as 'Contents of @myVar';



--Demonstrate the use of a select statement to return a single value
Declare @var1 nvarchar(30);
Select @var1 = 'Unnamed Company';
Select @var1 = Name
From AdventureWorks2016.Sales.Store
Where BusinessEntityID = 10;
Select @var1 As 'Company Name';


--Create a synonym for the company table
Create Synonym [Kampuni]
for dbo.Company;

--Display the details of the company table using its synonym
Select * from Kampuni;



--Demonstrate the use of the Begin...End statements
Begin Transaction
	if @@TRANCOUNT = 0

	Begin
		Select FirstName, MiddleName
		From AdventureWorks2016.Person.Person
		Where lastname like 'Andy';
		Print 'Rolling back the transaction two times would cause an error!';
	End

Rollback transaction;
	Print 'Rolled back the transaction';




--Demonstrate the use of the if...else construct
Declare @listPrice Money
set @listPrice =
(
	--Query to retrieve the list price of the most expensive
	--mountain bike
	Select Max(A.ListPrice)
	From AdventureWorks2016.Production.Product A
	join AdventureWorks2016.Production.ProductSubcategory B
	on A.ProductSubcategoryID = B.ProductSubcategoryID
	Where A.Name like 'Mountain Bike'
);

--Check whether the price of the bike is < 3000 & display
--an appropriate message
--Demonstrate the use of the if...else construct
	Declare @listPrice Money
	set @listPrice =
	(
		--Query to retrieve the list price of the most expensive
		--mountain bike
		Select Max(A.ListPrice)
		From AdventureWorks2016.Production.Product A
		join AdventureWorks2016.Production.ProductSubcategory B
		on A.ProductSubcategoryID = B.ProductSubcategoryID
		Where A.Name like 'Mountain Bike'
	);

--Check whether the price of the bike is < 3000 & display
--an appropriate message
	if @listPrice < 3000
		print 'All the bikes in this category can be purchased for less than Kes. 3000.'
	else
		print 'The price of some bikes in this category exceeds Kes. 3000'

--Display the even number between 10 and 95 using a while loop
Declare @flag int = 10;
	Print 'The even numbers between 10 and 95 are listed below';
		While (@flag <= 95)
	Begin
		if(@flag % 2 = 0)
			print @Flag
		set @flag += 1
		continue;
	End















/*                18/11/2021                  */




--Example of SQL Server Mathematical functions

/* The first value will be -1.01. This fails because the value is
outside the range.*/
	DECLARE @angle float
	SET @angle = -1.01
	SELECT 'The ASIN of the angle is: ' + CONVERT(varchar, ASIN(@angle))
	GO

-- The next value is -1.00.
	DECLARE @angle float
	SET @angle = -1.00
	SELECT 'The ASIN of the angle is: ' + CONVERT(varchar, ASIN(@angle))
	GO

-- The next value is 0.1472738.
	DECLARE @angle float
	SET @angle = 0.1472738
	SELECT 'The ASIN of the angle is: ' + CONVERT(varchar, ASIN(@angle))
	GO




--Create a table valued function if it doesn't exist
if(OBJECT_ID('ufn_CustDate')) is not null

	Begin
		drop function ufn_CustDate;
	End

	Create function ufn_CustDate()
	Returns table as
	Return
	(
		--Query to retrieve the CustomerID, due and ship dates of orders that were due before 2012
		Select A.CustomerID, B.DueDate, B.ShipDate
		From AdventureWorks2016.Sales.Customer A
		Left Outer Join
		AdventureWorks2016.Sales.SalesOrderHeader B
		On A.CustomerID = B.CustomerID
		and Year(B.Duedate) < 2012
	);



--Demonstrate the use of the partition by and over clause with aggregate function
	Select S.SalesOrderID, s.ProductID, S.OrderQty,
	Sum(S.OrderQty) over(partition by s.Salesorderid) as Total,
	max(S.OrderQty) over(partition by s.Salesorderid) as
	[Maximum Order Quantity]
	From AdventureWorks2016.Sales.SalesOrderDetail S
	Where S.ProductID in(776,773);


	--Create a partition with ordering
	Select c.CustomerID, C.StoreID,
	Rank() over(order by c.StoreId desc) as [Rank All],
	Rank() over (partition by c.PersonID order by C.Customerid desc)
	as [Customer Rank]
	From AdventureWorks2016.Sales.Customer C

--Create a partition with framing
	Select P.ProductID, P.Shelf, P.Quantity,
	SUM(P.Quantity) over (Partition by P.ProductID order by
	p.LocationID rows between unbounded preceding and current row) as
	[Running Quantity]
	From AdventureWorks2016.Production.ProductInventory P


--demonstrate the use ranking function with windowing
Select p.FirstName, P.LastName,
ROW_NUMBER() over (order by A.postalcode) as [Row Number],
NTILE(4) over (order by A.postalcode) as [NTILE],
S.SalesYTD, A.postalCode
from AdventureWorks2016.Sales.SalesPerson As S
join AdventureWorks2016.Person.Person As P
On S.BusinessEntityID = P.BusinessEntityID
join AdventureWorks2016.Person.Address As A
on A.AddressID = p.BusinessEntityID
where s.TerritoryID is not null and s.SalesYTD <> 0;


--Demonstrate the use of the switchoffset function
	Create table Test
	(
		ColDateTimeOffset datetimeoffset
	);

--add a new record
	insert into Test
	values
	(
		'1998-09-20 7:45:50.71345 -5:00'
	)

--Get the time in a zone -8 hrs

	Select SWITCHOFFSET	
	(	
		colDateTimeoffset,'-08:00'
	)
	from Test;



--Demonstrate the use of datetimeoffsetfromparts function
select DATETIMEOFFSETFROMPARTS(2010,12,31,14,23,23,0,12,0,7) as Result;

--Demonstrate the use of different formats used by the date and time functions
select SYSDATETIME() as [System Date/Time],
SYSDATETIMEOFFSET() as [System Date/Time Offset],
SYSUTCDATETIME() as [System UTC Date/Time];


--Demonstrates the use of LEAD() function:
SELECT BusinessEntityID, YEAR(QuotaDate) AS QuotaYear,
SalesQuota AS NewQuota,
LEAD(SalesQuota, 1,0) OVER (ORDER BY YEAR(QuotaDate)) AS FutureQuota
FROM AdventureWorks2016.Sales.SalesPersonQuotaHistory
WHERE BusinessEntityID = 275 and YEAR(QuotaDate) IN ('2011','2012');

--Demonstrates the use of FIRST_VALUE() function:
SELECT Name, ListPrice,
FIRST_VALUE(Name) OVER (ORDER BY ListPrice ASC) AS LessExpensive
FROM AdventureWorks2016.Production.Product
WHERE ProductSubcategoryID = 37;