/*This session covers advanced queries, subqueries and joins in sql server.*/


-- switch to AdventureWorks2016 database
use AdventureWorks2016;

--Demonstrate the use of the group by clause in a select statement
--Retrieve the number of hours per work order
select WorkorderID, sum(ActualResourceHrs) as 'Hours Per Order'
from Production.WorkOrderRouting
Group by WorkOrderID


--Get the number of hours per work order, for those orders
--with a workorderID less then 50
select WorkorderID, sum(ActualResourceHrs) as 'Hours Per Order'
from Production.WorkOrderRouting
where WorkOrderID <= 50
Group by WorkOrderID;
--order by 'Hours Per Order' desc; optionally sort the results

--DIsplay the average list price from the clasess in the 
--product table in the production schema
select Class , AVG (ListPrice) as 'Average List Price'
from Production.Product
group by Class;


--display the slaes in various regions using the group by with all clause
select [Group], SUM(SalesYTD) AS 'TotalSales'
FROM Sales.SalesTerritory
WHERE [Group] LIKE 'N%' OR [Group] LIKE 'E%' GROUP BY ALL [Group]

--display the slaes in various regions with sales less than 60 
select [Group], convert(decimal(12,2),SUM(SalesYTD)) AS 'Total Sales'
FROM Sales.SalesTerritory
group by [Group]
HAVING SUM(SalesYTD) <6000000;

--display the sales in all countries apart from Australia and Canada
select [Name], SUM(SalesYTD) AS 'Total Sales'
FROM Sales.SalesTerritory
where [Name] <> 'Australia' and [Name] <> 'Canada'
group by[Name], CountryRegionCode with Cube

--display the sales in all countries apart from Australia and Canada
select [Name], SUM(SalesYTD) AS 'Total Sales'
FROM Sales.SalesTerritory
where [Name] <> 'Australia' and [Name] <> 'Canada'
group by[Name], CountryRegionCode with rollup



--Get the average unit price, least orderquantity and the
--highest unitpriceDiscount from the salesorderdetail table in
--the sales schema
Select AVG(UnitPrice) as 'Average Unit Price',
min(OrderQty) as 'Minimum Order Quantity',
max(UnitPriceDiscount) as [Maximum Discount]
from AdventureWorks2016.Sales.SalesOrderDetail;

--Retrieve the earliest and latest order dates
select min(OrderDate) as 'Earliest Order',
max(OrderDate)as 'Latest Order'
from AdventureWorks2016.Sales.SalesOrderHeader;

--Demonstrate the user of the STUnion function
select geometry::Point(251,1,4326).--Point function is case sensitive
STUnion (geometry::Point(252,2,4326));

--Another example of declaring user of the STUnion function by using a city
DECLARE @City1 geography
SET @City1 = geography::STPolyFromText
('POLYGON((175.3 -41.5, 178.3 -37.9, 172.8 -34.6, 175.3 -41.5))',
4326)
DECLARE @City2 geography
SET @City2 = geography::STPolyFromText
('POLYGON((169.3 -46.6, 174.3 -41.6, 172.5 -40.7, 166.3 -45.8, 169.3 -
46.6))',
4326)
DECLARE @CombinedCity geography = @City1.STUnion(@City2)
SELECT @CombinedCity;


--Display the constants of the combined city variable
select @CombinedCity;

--Find out example of union aggregate of people living in London
select Geography::UnionAggregate(SpatialLocation) as [Average Location]
from Person.Address
where City like 'London';

--example of envelope aggregate
SELECT Geography::EnvelopeAggregate(SpatialLocation)
AS Location
FROM Person.Address
WHERE City = 'London';

--Example that returns an instansce of carrypolygon and a polygon
DECLARE @CollectionDemo TABLE
(
	shape geometry,
	shapeType nvarchar(50)
)

--insert values into the @collectionTable variable
INSERT INTO @CollectionDemo(shape,shapeType) 
VALUES('CURVEPOLYGON(CIRCULARSTRING(2 3, 4 1, 6 3, 4 5, 2 3))','Circle'),('POLYGON((1 1, 4 1, 4 5, 1 5, 1 1))', 'Rectangle');
SELECT geometry::CollectionAggregate(shape)
FROM @CollectionDemo;


--Exaple of convex hull aggregate of people living in London 
SELECT Geography::ConvexHullAggregate(SpatialLocation) as [Convex Hull Aggregate]
FROM Person.Address
WHERE City = 'London';



--Get the due date and shipping date of the most recent order
select DueDate, ShipDate
from sales.SalesOrderHeader
where orderdate =
(
	--Subquery to get the latest/most recent order
	select max(orderdate)
	from sales.SalesOrderHeader
);


--Get the first and Last name for employees working in Reaserch and Development managers
SELECT FirstName as [First Name], LastName as [Last Name] 
FROM Person.Person
WHERE Person.Person.BusinessEntityID IN 
(
	--subquery to extract the job title
	SELECT BusinessEntityID
	FROM HumanResources.Employee 
	WHERE JobTitle ='Research and Development Manager'
);


--Use a corerelated query to get the first and Last name for employees working in Reaserch and Development managers using the exist keyword

SELECT FirstName as [First Name], LastName as [Last Name] 
FROM Person.Person as A
WHERE exists 
(
	--subquery to extract the job title
	SELECT BusinessEntityID
	FROM HumanResources.Employee as B 
	WHERE JobTitle like 'Research and Development Manager'
	AND A.BusinessEntityID=B.BusinessEntityID
);



--get the First and Last Names of sales persons from Canada
select LastName, FirstName
from Person.Person
where BusinessEntityID in
(
	select BusinessEntityID
	from Sales.SalesPerson
	where TerritoryID in
	(
		select TerritoryID
		from Sales.SalesTerritory
		where name like 'Canada'
	)
);


-- same from above with names joined
select FirstName, LastName
from Person.Person
where BusinessEntityID in
(
	select BusinessEntityID
	from Sales.SalesPerson
	where TerritoryID in
	(
		select TerritoryID
		from Sales.SalesTerritory
		where name like 'Canada'
	)
);

--extractt the business entity ID of all the individuals modified after 2012 using correlated quaries
select e.BusinessEntityID
From Person.BusinessEntityContact as e
where e.ContactTypeID in
(
	--subquery toextract the contact type id modified after 20212
	select e.ContactTypeID
	from Person.ContactType as e
	where year (e.ContactTypeID) > 2012
);


--using joins
--determine the names of employees and their job titles
SELECT A.FirstName, A.LastName, B.JobTitle
FROM Person.Person A
INNER JOIN HumanResources.Employee B
ON
A.BusinessEntityID = B.BusinessEntityID;

--Get all customers IDs for the customer table in the sales schema and order
--information such as ship and due dates for orders placed prior to 2012
--even custimers leave not placed any orders
SELECT A.CustomerID, B.DueDate, B.ShipDate
FROM Sales.Customer A LEFT OUTER JOIN Sales.SalesOrderHeader B
ON
A.CustomerID = B.CustomerID AND YEAR(B.DueDate)<2012;

--above can be also written as
select A.CustomerID, B.DueDate, B.ShipDate
from Sales.Customer A
right outer join Sales.SalesOrderHeader B
on
A.CustomerID = B.CustomerID and YEAR(B.DueDate)<20112;


--We want to get the number of customers who've not placed any orders
select COUNT(A.CustomerID) as 'Number of Customerss without orders before 2012'
from Sales.Customer A
left outer join Sales.SalesOrderHeader B
on
A.CustomerID = B.CustomerID and YEAR(B.DueDate) < 2012;


--Get names of all products irregaredress of wheather they've been ordered or not
select P.Name as 'Product Name', s.SalesOrderID
from Sales.SalesOrderDetail S 
right outer join Production.Product P
on s.ProductID = p.ProductID;







--Switch database
use Edwin_Customer_DB_2105

--Create the SterlingEmployee table
IF OBJECT_ID ('tempdb..#Test')is not null
Create table SterlingEmployee
(
	Emp_id nvarchar(20) not null primary key,
	Fname nvarchar(50) not null,
	Middle_init nvarchar(1) ,
	Lname nvarchar(50) not null,
	Job_id int not null,
	Job_level int not null,
	Pub_id nvarchar(5) not null,
	Hire_date datetime not null,
	Mngr_id nvarchar(20)
);

--Populate the SterlingEmployee table with employee details
IF OBJECT_ID ('tempdb..#Test')is not null
Insert into dbo.SterlingEmployee values
('PMA42628M','Paolo','M','Accorti',13,35,'0877','1992-08-27','POK93028M'),
('PSA89086M','Pedro','S','Afonso',14,89,'1389','1990-12-24','POK93028M'),
('VPA30890F','Victoria','S','Ashworth',6,140,'0877','1990-09-13','ARD36733F'),
('H-B39728F','Helen','','Bennett',12,35,'0877','1989-09-21','POK93028M'),
('L-B31947F','Lesley','','Brown',7,120,'0877','1991-02-13','ARD36733F'),
('F-C16315M','Francisco','','Chang',4,227,'9952','1990-11-03','MAS70474F'),
('PTC11962M','Philip','T','Cramer',2,215,'9952','1989-11-11','MAS70474F'),
('A-C71970F','Aria','','Cruz',10,87,'1389','1991-10-26','POK93028M'),
('AMD15433F','Ann','M','Devon',3,200,'9952','1991-07-16','MAS70474F'),
('ARD36733F','Anabela','R','Domingues',8,100,'0877','1993-01-27',''),
('PHF38899M','Peter','H','Franken',10,75,'0877','1992-05-17','POK93028M'),
('PXH22250M','Paul','X','Henroit',5,159,'0877','1993-08-19','MAS70474F')


--Display all the details in the SterlingEmployee table
select * from dbo.SterlingEmployee;

--Display all the details in the startingEmployee table
select top 7 A.Fname + ' ' + A.Lname as 'Employee Name', B.Fname + ' ' + B.Lname as 'Manager'
from dbo.SterlingEmployee as A
join 
dbo.SterlingEmployee as B
on
A.Mngr_id = B.Emp_id







--Create the Products and new products table
IF OBJECT_ID ('tempdb..#Test')is not null
Create table Products
(
	ProductID int not null Primary Key,
	Name nvarchar(30) not null,
	[Type] nvarchar(30) not null,
	PurchaseDate date not null
);

IF OBJECT_ID ('tempdb..#Test')is not null
Create table NewProducts
(
	ProductID int not null Primary Key,
	Name nvarchar(30) not null,
	[Type] nvarchar(30) not null,
	PurchaseDate date not null
);


--Insert Items into both tables
IF OBJECT_ID ('tempdb..#Test')is not null
Insert into Products
values
(	
	101,'Rivets','Hardware','2012-12-01'),
	(102,'Nuts','Hardware','2012-12-01'),
	(103,'Washers','Hardware','2011-01-01'),
	(104,'Rings','Hardware','2013-01-15'),
	(105,'Paper Clips','Stationery','2012-01-01'
);

IF OBJECT_ID ('tempdb..#Test')is not null
Insert into NewProducts
values
(	
	102,'Nuts','Hardware','2012-12-01'),
	(103,'Washers','Hardware','2011-01-01'),
	(107,'Rings','Hardware','2013-01-15'),
	(108,'Paper Clips','Stationery','2012-01-01'
);


--Display details from both tables
Select * from Products;
Select * from NewProducts;



--merge the records from the new products table to the products table
Merge into dbo.products as P1
using
dbo.NewProducts as P2
on P1.ProductId = P2.ProductId
when matched then
update set
P1.Name = P2.Name,
P1.Type = P2.Type,
P1.PurchaseDate = P2.PurchaseDate
When not matched then
insert(ProductID, Name, Type, PurchaseDate)
Values (P2.ProductId, P2.Name, P2.Type, P2.PurchaseDate)
When not matched by source then
delete
output $action, Inserted.ProductID, Inserted.Name, Inserted.Type,
Inserted.PurchaseDate, Deleted.ProductID, Deleted.Name, Deleted.Type,
Deleted.PurchaseDate;


--Display the year and number of customer in that year
With CTE_OrderYear
As
(
Select YEAR(OrderDate) As OrderYear, CustomerID
From AdventureWorks2016.Sales.SalesOrderHeader
)
Select OrderYear, COUNT(Distinct CustomerID)
As 'Number Of Customers'
From CTE_OrderYear
Group by OrderYear
Order by OrderYear;




--Learn how to use the union operator
--Display all product IDs from the product table in the production schema 
--and the matching product id from the salesorderdetail table in the sales schema
select productId
from production.product
union--all
select productID from sales.salesorderdetail;



--Display all distinct rows that are common the production.product and Sales.salesorderdetails
--table using the intersect operator
select productId from production.product
intersect
select productID from sales.salesorderdetail;

--Display all distinct rows that are common the production.product table and Sales.salesorderdetails
--table using the EXCEPT operator
select productId from production.product
except
select productID from sales.salesorderdetail;





--display the top 5 sales regions for the sales.salesterritory table
select top 5 name, salesytd
from sales.salesterritory;


--Learn how to use the pivot operator to display the results from the
--above query row wise
select top 5 'TotalSalesYTD'
as [Grand Totals], [NorthWest], [NorthEast], [Central], [SouthWest], [SouthEast] --column Headers
from
(
	select top 5 name, salesytd
	from sales.salesterritory

)
as sourcetable
pivot
(
	sum(salesytd)
	for name in ([Grand Totals], [NorthWest], [NorthEast], [Central], [SouthWest], [SouthEast])
)as PivotTable;

--unpivot the above data
SELECT Name, SalesYTD FROM
(
	SELECT [Grand Totals], [NorthWest], [NorthEast], [Central], [SouthWest], [SouthEast]
	FROM PivotTable
) p
UNPIVOT
(
	SalesYTD FOR Name IN ([Grand Totals], [NorthWest], [NorthEast], [Central], [SouthWest], [SouthEast])
)AS unpvt;

