/*This session introduces us to transact SQL- */

--Change the Adventurework2016 database
use AdventureWorks2016;

--Get the Login ID of employees whose job title is design enginner
select LoginID
from HumanResources.Employee
where JobTitle like 'Design Engineer';

--Demonstrate operaator precendence
DECLARE @Number int;
SET @Number = 2 + 2 * (4 + (5 - 3))
SELECT @Number as "Result";


--show time and date
select GETDATE() as "Current Date"


--Get the sale detials from the salesorderheader table 
SELECT SalesOrderID, CustomerID, SalesPersonID, TerritoryID,YEAR(OrderDate)
AS CurrentYear, YEAR(OrderDate) + 1 AS NextYear
FROM Sales.SalesOrderHeader;

--Display all the details from the Employee table in the HR schema
select *
from HumanResources.Employee;

--How an Logic Order of Operators in SELECT works
SELECT SalesPersonID, YEAR(OrderDate) AS OrderYear
FROM Sales.SalesOrderHeader
WHERE CustomerID = 30084
GROUP BY SalesPersonID, YEAR(OrderDate)
HAVING COUNT(*) > 1
ORDER BY SalesPersonID, OrderYear;