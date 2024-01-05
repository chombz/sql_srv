/*This session covers the select statment and xml data. */

--Pick off the first 5 characters from a string
select LEFT('International',5)
as [First 5 Characters];

--pick off the last 5 characters 
select RIGHT('International',5)
as[Last 5 Characters];

--Fetch all details from the employee's tables in the Employee's Table in HR scheme
Select * --*-> fetch all columns
from AdventureWorks2016.HumanResources.Employee;

--Switch to adventureworks 2016 database
use AdventureWorks2016;

--Display specific columns from the location table
--schema in the adventureworks2016 database
select LocationID, CostRate
from Production.location
order by costrate desc;

--Display specific columns from the location table
--production schema in the adventureworks2016 database
select [Name] + ':' + CountryRegionCode + '->' + [Group]
as [Territory Details] --rename the column heading
from Sales.SalesTerritory;

--Demonstrate the use of computed values in a resultset
--Fetch the dicount details from the ProductCostHistory table
--in the productions schema in the AdventureWorks2016 database
select ProductID, StandardCost, StandardCost * .15 as 'Discount',
StandardCost - StandardCost * .15
from Production.ProductCostHistory;

--display
select ProductID, convert(decimal(10,2),StandardCost) as 'Standard Cost',
convert(decimal(10,2),StandardCost * .15) as 'Dicount',
convert(decimal(10,2),(StandardCost - StandardCost * .15)) as [Discounted Price]
from Production.ProductCostHistory;

--Fetch unique prices from theProductionCostHistory table
--inthe productions schema in the AdventureWorks2016 database
select distinct StandardCost
from Production.ProductCostHistory;


--display prices of ProcudctionCostHistory
--in the productions schema in the AdventureWorks2016 database
select distinct StandardCost
from Production.ProductCostHistory
order by StandardCost desc;

--Fetch the top unique prices from the ProductionHistory table
--in the productions schema in the AdventureWorks2016 database
select distinct top 7 StandardCost
from Production.ProductCostHistory
order by StandardCost desc;

--Fetch the top 5 cheapest unique prices from the ProductionCostHistory table
--in the productions schema in the AdventureWorks2016 database
select distinct top 5 StandardCost
from Production.ProductCostHistory
order by StandardCost;

--Change to customer database
use Edwin_Customer_DB_2105;

--Fetch rows from the adventureworkds database table and insert them into a
--new table in the custimers database
select ProductModelID, [Name]
into ProductName --Name of the table to create in the destination customers database
from AdventureWorks2016.Production.ProductModel;

--Query to display all the records from the ProductionName table in the Customer database
select ProductionModelID, [Name]
into ProductName
from Production.ProductModel.ProductionModelID;
