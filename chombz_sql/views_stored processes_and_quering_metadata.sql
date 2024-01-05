/*Thissession converts views, stored procedures and querying database metadata*/



/*        04/11/2021             */

--change database
use Edwin_Customer_DB_2105;

--Creata a view that displays the personal details of employees using data
--from the employee table in the HR Schema and person table in the 
--person schema
Create View vwPersonDetails as
SELECT p.Title, p.FirstName, p.MiddleName, p.LastName,
Year(getdate()) - year(E.birthdate) as 'Age', e.gender, e.jobtitle
 
FROM AdventureWorks2016.HumanResources.Employee E
JOIN AdventureWorks2016.Person.Person P
on P.BusinessEntityID = E.BusinessEntityID;

--display the details in the persondetails view
SELECT * from vwPersonDetails;


--Recreate the above query but replace the null values with an 
--empty string using the  COALESCE functiooon
 Create View vwPersonDetails 
 as
SELECT  COALESCE (p.Title,'*****') as 'Title', COALESCE (p.FirstName,'*****') as 'First Name', COALESCE(p.MiddleName,'*****') as 'Middle Name', COALESCE(p.LastName,'') as 'Last Name',
Year(getdate()) - year(E.birthdate) as 'Age', e.gender, e.jobtitle
 
FROM AdventureWorks2016.HumanResources.Employee E
JOIN AdventureWorks2016.Person.Person P
on P.BusinessEntityID = E.BusinessEntityID;


--Create aview that contains employee details sorted by the 
--employee's first name in accending order
 Create View vwPersonDetails 
 as
SELECT  COALESCE (p.Title,'') as 'Title', COALESCE (p.FirstName,'') as 'First Name', COALESCE(p.MiddleName,'') as 'Middle Name', COALESCE(p.LastName,'') as 'Last Name',
Year(getdate()) - year(e.birthdate) as 'Age', e.gender, e.jobtitle
 
FROM AdventureWorks2016.HumanResources.Employee e
JOIN AdventureWorks2016.Person.Person p
on p.BusinessEntityID = e.BusinessEntityID;


--Display records of above
SELECT * FROM vw.PersonDetails;




--Create an employee details and employee salary details table
--to be used as the base table for an employee details view
Create table Employee_Personal_Details

IF OBJECT_ID('tepdb..#Test') IS NOT NULL
(
    EmpID int not null,
    FirstName nvarchar(30) not null,
    LastName nvarchar(30) not null,
    Address nvarchar(30)
);

 

Create table Employee_Salary_Details
(
    EmpID int not null,
    Designation nvarchar(30) not null,
    Salary int not null
    --Foreign key(EmpID) references Employee_Personal_Details(EmpID)
);

--Create a view to display the employeepersonal and salary details
Create view vwEmpSalDetails as
Select PD.EmpID, PD.FirstName, PD.LastName, ED.Designation,
ED.Salary
From Employee_Personal_Details PD
join
Employee_Salary_Details ED
on
PD.EmpID = ED.EmpID;

--Try to insert a record into the tables using the view
Insert into vwEmpSalDetails
values
(2,'Jack','Wilson', 'Software Developer', 16000); --will not work


--Create a view that will be used to insert values into the
--Employee personal details table
Create view vwEmp_Details
as
Select EmpID, FirstName, LastName,Address
from Employee_Personal_Details;

 

--Insert using the EmpDetails view
Insert into vwEmp_Details
values
(
	2,'Jack','Wilson','New York',
);


--Display the details from the EmpDetails View
select * from vwEmp_Details;








/*                  5th/11/21                        */

--use customers database
use Edwin_Customer_DB_2105;


--Create a ProductDetials table
Create Table Product_Details
(
    Product int not null,
    ProductName nvarchar(30) not null,
    Rate money not null
);

--Add rows/records to the above table
Insert into Product_Details
values
(5, 'DVD Writer',2250),
(4,    'DVD Writer',1250),
(3,    'DVD Writer',1250),
(2,    'External Hard Drive',4250),
(3,    'External Hard Drive',4250)

--display the records inserted into the product details table 
SELECT * FROM Product_Details;


--Create a view that will used to update product_details tabLE
create view vwProduct_Details
AS
SELECT Product, ProductName, Rate
FROM Product_Details;

--Displays the from product details view
SELECT * FROM dbo.Product_Details;

--Update the prices of all dvd writers to 3000
UPDATE vwProduct_Details
SET Rate = 3000
WHERE ProductName='DVD Writer'

--modify the product_details by adding a description column
alter table dbo.product_details
add [Description] nvarchar();--description in [] as it's a keyword

--Add more records into the Product details table
Insert into Product_Details
values
(1, 'Hard Disk Drive',3750,'Internal 120 GB'),
(7, 'Portable Disk Drive',5580,'Internal 500 GB'),
(8, 'Hard Disk Drive',5580,'Internal 500 GB'),
(9, 'Hard Disk Drive',3750,'Internal 120 GB'),
(10,'Portable Disk Drive',3750,'Internal 500 GB');

--modify the product_details view to display the description column
alter view vwProduct_details
AS
SELECT ProductName, [Description], Rate
FROM dm.Product_Details;

--View records recurred by the product details view
SELECT * FROM vwProduct_details; 

--Correct the description of portable hard drives from
--internal to external hard drives
UPDATE vwProduct_details
SET [Description] .write(N'EX',8,2)
WHERE ProductName='Portable Hard Drive';

--Create a customer details table 
CREATE TABLE Customer_Details
(
	CustID nvarchar(7) not null,
	AccNo int identity(1,1) not null,
	Accname nvarchar(20) not null,
	[Date of Birth] date not null,
	City nvarchar(25) not null
);


--Add records to the customer details table
insert into dbo.Customer_Details
(
	CustID,
	Accname,
	[Date of Birth],
	City
)
VALUES
('C0001','Jane','1980-02-02','Topeka'),
('C0002','Haris','1978-12-05','Lansing'),
('C0003','Pitts','1985-11-10','Columbus'),
('C0004','Monaliza','1980-11-12','Topeka');

--Createthe customer details view
Create view vwCustDetails
AS
SELECT * FROM Customer_Details;

--display the records returened by the sutomer details view
SELECT * FROM vwCustDetails;

--Delete nomalize's record using the view
DELETE
FROM vwCustDetails
WHERE CustID like 'C0004'; 


--alter the definition of the productInfo view
alter view vwProductInfo as
Select ProductId as [Product ID], ProductNumber as 'Product Number',
Name as 'Product Name', SafetyStockLevel as [Safety Stock Level],
ReorderPoint as [Re-order Point]
From AdventureWorks2016.Production.Product;

--display records returned by the modified product info view
SELECT * FROM vwProductInfo;


--Create view to delete
create view vw2Delete 
AS
Select ProductId as [Product ID], ProductNumber as 'Product Number',
Name as 'Product Name', SafetyStockLevel as [Safety Stock Level],
ReorderPoint as [Re-order Point]
From AdventureWorks2016.Production.Product;

--delete view
DROP VIEW vw2Delete;


--Display the statement used to create the productinfo view
EXEC sp_helptext vwProductInfo;

--Create a view using an inbuilt function
--create a view to display the average price of products
--using the Avg() function
CREATE VIEW vwProductDEtails 
AS
SELECT ProductName, AVG(Rate) AS [Average Rate]
FROM dbo.Product_Details
GROUP BY ProductName;

--Display the records return by the product details view
SELECT * FROM vwProductInfo;



/*        08/11/21               */


--Create a view with the check option
CREATE VIEW vwProductInfomation as
Select ProductId as [Product ID], ProductNumber as 'Product Number',
Name as 'Product Name', SafetyStockLevel as [Safety Stock Level],
ReorderPoint as [Re-order Point]
From AdventureWorks2016.Production.Product
WHERE SafetyStockLevel <= 1000
WITH CHECK OPTION;

--View records return by above view
SELECT * FROM vwProductInfomation;

--Try to make changes which violate the CHECK OPTION
UPDATE vwProductInformation
set [Safety Stock Level] = 2500
where ProductID = 321; 




--Switch databases
USE AdventureWorks2016;

--Create a view with schema binding option
Create view vwNewProductInfo
with Schemabinding as
Select ProductID, ProductNumber, [Name], SafetyStockLevel
From Production.Product;--WIll not work due to permission restriction of the database of AdventureWorks2016






--Switch databases
USE Edwin_Customer_DB_2105;

--Demonstrate the working of sp_refresh view




--1. Create a Customer table
Create table Customer_1
(
	CustID int,
	CustName nvarchar(50),
	Address nvarchar(60)
);

--2. Create a customer view
Create View vwCustomer_1
As 
Select * from dbo.Customer_1;

--3. Display the details from the Customer view
Select * from vwCustomer;

--4. Add a new column (age) to the customer table
Alter table dbo.Customer_1
Add Age tinyint;

--5. Click if the customer view displays all columns after 
--table modification
SELECT * FROM vwCustomer;

--6. Refresh the Customer view to display all columns in the
--Customer table
exec sp_refreshview [vwCustomer_1];

--7. Check if the Customer view displays all columns after
--refreshing the view
Select * from vwCustomer;





/*      09/11/21        */

--Check if a file exsists using an extended stored procedure
exec  xp_fileexist 'c:\MyTest.txt'



--Create a custom/user-defined store procedure to display customer details
Create Proc uspCustTerritory as
Select top 10 CustomerID, C.TerritoryID, T.Name
From AdventureWorks2016.Sales.Customer as C
Join AdventureWorks2016.Sales.SalesTerritory As T on
C.TerritoryID = T.TerritoryID;

--Execute a custom/user-defined stored procedure
Exec uspCustTerritory;



--Create a user defined/custom stored procedure that accepts parameters
--Create a custom procedure that accepts the name of a territory
--and displays the salesperson id and sales details
create proc uspGetSales
@territory nvarchar(40)--Variable to store the name of the territory from which to get the sales details
as
Select BusinessEntityID, B.SalesYTD, B.SalesLastYear
From AdventureWorks2016.Sales.SalesPerson A
Join AdventureWorks2016.Sales.SalesTerritory B
on A.TerritoryID = B.TerritoryID
Where B.[Name] = @territory;

--Get the sales from the NorthWest and NorthEast regions
exec uspGetSales 'NorthWest';
exec uspGetSales 'NorthEast';


--Create a user defined/custom stored procedure that accepts
--parameters and gives an output value
--Create a user defined/custom stored procedure that accepts the
--region and returns the total sales from that region
Create proc uspGetTotalSales
@territory nvarchar(40),--Territory from which to get total sales
@sum int OUTPUT --Output variable to stores sales for the region
as
Select @sum = Sum(B.SalesYTD)
From AdventureWorks2016.Sales.SalesPerson A
Join AdventureWorks2016.Sales.SalesTerritory B
on A.TerritoryID = B.TerritoryID
Where B.[Name] = @territory;

--Get the total sales from the NorthWest region
DECLARE @sumSales money;--Variables to hold NorthWest's total sales
exec uspGetTotalSales 'NorthWest', @sum = @sumSales output;

--Display the dales of NorthWest region
PRINT 'The year-to-date sales figure for this territory is ' +  CONVERT(nvarchar(100), @sumSales);



--View the definition statements used to create as stored procedure of uspGetTotals
EXEC sp_helptext uspGetSales;
EXEC sp_helptext uspGetTotalSales;



--Change/modify a user defined stored procedure
Alter Proc uspGetTotals


@territory nvarchar(40)--Variable to store the name of the territory from which to get the details
WITH ENCRYPTION --Encrypt/Obfusicate the code/definition of the usp
as
Select BusinessEntityID, B.SalesYTD, B.CostYTD, B.SalesLastYear
From AdventureWorks2016.Sales.SalesPerson A
Join AdventureWorks2016.Sales.SalesTerritory B
on A.TerritoryID = B.TerritoryID
Where B.[Name] = @territory;


--Create a dummy stored procedure
CREATE PROCEDURE  uspDelete

@territory nvarchar(40)--Variable to store the name of the territory from which to get the details
WITH ENCRYPTION --Encrypt/Obfusicate the code/definition of the usp
as
Select BusinessEntityID, B.SalesYTD, B.CostYTD, B.SalesLastYear
From AdventureWorks2016.Sales.SalesPerson A
Join AdventureWorks2016.Sales.SalesTerritory B
on A.TerritoryID = B.TerritoryID
Where B.[Name] = @territory;


--Check dependencies fot uspDelete custom stored procedure
EXEC sp_depends uspDelete;

--Delete the dummy uspDelete stored procedure
drop procedure uspDelete;




--Create a nested stored procedure (a stored proc. that call other stored procs.)
CREATE PROCEDURE uspNestedProcedure 
AS
BEGIN
	EXEC uspCustTerritory
	EXEC uspGetSales 'France'
END

--display a nested stored procedure
EXEC uspNestedProcedure; 



--Create a usp to get the level of nesting
CREATE PROCEDURE uspNestProcedure 
AS
SELECT @@NESTLEVEL 
AS NestLevel;
EXEC('Select @@NESTLEVEl AS [NestLevel With Execute]');
EXEC sp_executesql N'Select @@NESTLEVEl AS [NestLevel With sp_execute]';

--Execute the NestProcedure usp
EXEC uspNestProcedure

--display @@nested stored procedure
EXEC uspNestProcedure; 

--Display a list of user tables and their attributes from the system catalog view
SELECT NAME, OBJECT_ID, TYPE, TYPE_DESC
FROM sys.Tables
ORDER BY NAME;


--Display data from the Edwin_CustDB database
Select TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE
From Edwin_Customer_DB_2105.INFORMATION_SCHEMA.TABLES;