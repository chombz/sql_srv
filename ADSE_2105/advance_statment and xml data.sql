/*This session covers the select statment and xml data. */

--Pick off the first 5 characters from a string
select LEFT('International',5)
as [First 5 Characters];

--pick off the last 5 characters 
select LEFT('International',5)
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
order by StandardCost ;

--Change to the customer database
use Edwin_Customer_DB_2105;

--Fetch rows from the adventureworks database table and insert them into a
--new table in the customers database
IF OBJECT_ID('tepdb..#Test') IS NOT NULL
select ProductModelID, [Name]
into ProductName --Name of the table to create in the destination customers database
from AdventureWorks2016.Production.ProductModel;

--Query to display all the records from the ProductionName table in the Customer database
select * from AdventureWorks2016.Production.ProductModel;



--Display Title, firstname, lastname and suffix details of people
--whose last name begins letter B
Select Title, firstname, lastname, suffix
from Person.person
where lastname like 'B%';

--Learn how to use logical operators "Not", "And" & "Or"
--Display Title, firstname, lastname and suffix details of people
--whose last name begins letter B,
-- and their title and suffix are not null
Select Title, firstname, lastname, suffix
from Person.person
where lastname like 'B%' and title is not null and suffix is not null;

--Display Title, firstname and lastname details of people
--whose title is Mr. or Ms,
Select Title, firstname, lastname
from Person.person
where title like 'M_.';--can be written as "Where title like 'Mr.' or title like 'Ms.'

--Fetch/retrieve all details of transaction from usd to Canadian Dollars
--or chinese yen
Select *
from sales.currencyrate
where tocurrencycode like 'c[an][dy]';

--Fetch/retrieve all details of transaction from usd to currencies starting
--with 'A' and not followed by 'r' or 's'
Select *
from sales.currencyrate
where tocurrencycode like 'a[^r][^s]';

--fetch all details of where the address id is greater than 900 and
--the address type ix equal to 5
select *
from person.BusinessEntityAddress
where addressId < 900 or addresstypeID = 5;

--fetch all details where the address type is not 5
select*
from person.BusinessEntityAddress
where not addresstypeID = 5;--also addresstypeID is 5 or addresstypeID <> 5

--demonstrate the use of the group by clause in a select statement 
--get the number of hours pe work order
select WorkorderID, sum(ActualResourceHrs) as 'Hours Per Order'
from Production.WorkOrderRouting
Group by WorkOrderID;

--switch to customers database
use Edwin_Customer_DB_2105;

--use CTB[common table expression] in SELECT and INSERT statement
--create the new employees table
IF OBJECT_ID ('tempdb..#Test')is not null
Create Table NewEmployees
	(
		EmployeeID smallint,
		FirstName nchar(10),
		LastName nchar(10),
		Department nchar(50),
		HireDate datetime,
		Salary money
	);

--Insert in record into the newEmployees table
Insert into NewEmployees
	values
		(11, 'Kevin','Research', '2012-07-31', 54000);
	with EmployeeTemp
		(EmployeeID, FirstName, LastName, Department, HiredDate, Salary)
	as
	( 
		Select * from NewEmployees
	)

Select * From EmployeeTemp;
 




 /*Use the output clause to display the rows affected
by update statements. Execute the statements below as
one batch to avoid errors.*/
IF OBJECT_ID ('tempdb..#Test')is not null
Create table dbo.Table_3
	(
		id Int,
		employee nvarchar(32)
	);

--Insert records into table_3
insert into dbo.Table_3
	values
		(1,'Matt'),
		(2,'Joseph'),
		(3,'Renny'),
		(4,'Daisy');

--display dbo.Table_3
SELECT * FROM dbo.Table_3;


--Create a table variable to hold the updated values
Declare @updatedTable Table
	(
		id int,
		oldData_employee varchar(32),
		newData_employee varchar(32)
	);/*Use the output clause to display the rows affected
	by update statements. Execute the statements below as
	one batch to avoid errors.*/
IF OBJECT_ID ('tempdb..#Test')is not null
Create table dbo.Table_3
	(
		id Int,
		employee nvarchar(32)
	);

--Insert records into table_3
insert into dbo.Table_3
	values
		(1,'Matt'),
		(2,'Joseph'),
		(3,'Renny'),
		(4,'Daisy');

--display dbo.Table_3
SELECT * FROM dbo.Table_3;




--Create a table variable to hold the updated values
Declare @updatedTable Table
	(
		id int,
		oldData_employee varchar(32),
		newData_employee varchar(32)
	);

update dbo.Table_3
set employee = UPPER(employee)
--Use output to specify the details to be displayed
	output
		inserted.id,
		deleted.employee,
		inserted.employee
	into @updatedTable

--Display all the records that were updated from the updatedTable variable
Select * from @updatedTable;


/* Use the write clause to replace a long string in a column */
--Create a new table called Table_5
Create table dbo.Table_5
	(
		EmployeeRole varchar(max),
		Summary varchar(max)
	);

--Add records in the new table
Insert into dbo.Table_5
		(EmployeeRole,Summary)
	values
		('Research','This is a very long non-unicode string');
--This is an incredibly long non-unicode string
--Modify/update the summary column using the write clause
update dbo.table_5
set Summary .write('n incredibly ',9,5)
where EmployeeRole like 'Research';
--Display all the records in Table_5
select * from dbo.Table_5;

--Create a schema Person
IF OBJECT_ID ('tempdb..#Test')is not null
CREATE SCHEMA Person
--Create the phone bulling table in the person schema
IF OBJECT_ID ('tempdb..#Test')is not null
CREATE TABLE Person.PhoneBilling
	(
		Bill_ID int,
		PhoneNumber bigint unique,
		CallDetail xml
	);

--Add a record in the PhoneBilling table in the Person Schema
IF OBJECT_ID ('tempdb..#Test')is not null
Insert into Person.PhoneBilling
values
(
	100, 95592345245, '<Info><Call><Local></Call><Time><Charges> 200</Charges></Info>'
);

--Fetch Deatails pf the call from PhoneBilling Table
select CallDetail from Person.PhoneBilling;


--Declare a xml variable
DECLARE @xmlvar xml
Get @xmlvar = '<Employee name="Joan" />' --variable asignment


--Create and register an XML schema
CREATE XML SCHEMA COLLECTION CricketSchemaCollection
AS N'<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema" >
<xsd:element name="MatchDetails">
<xsd:complexType>
<xsd:complexContent>
<xsd:restriction base="xsd:anyType">
<xsd:sequence>
<xsd:element name="Team" minOccurs="0" maxOccurs="unbounded">
<xsd:complexType>
<xsd:complexContent>
<xsd:restriction base="xsd:anyType">
<xsd:sequence />
<xsd:attribute name="country" type="xsd:string" />
<xsd:attribute name="score" type="xsd:string" />
</xsd:restriction>
</xsd:complexContent>
</xsd:complexType>
</xsd:element>
</xsd:sequence>
</xsd:restriction>
</xsd:complexContent>
</xsd:complexType>
</xsd:element>
</xsd:schema>'

/*Create a CricketTeam table with xml type column and specifically the schema that will be
used to validate */

Create table CricketTeam
(
	TeamID int  identity not null,
	TeamInfo xml(CricketSchemaCollection)
); 

--Display teamID
select*
from TeamID;

--Add some records to the CricketTeam Table
Insert into CricketTeam
values
(
	'<MatchDetails>
		<Team County = "Australia" score="7435"></Team>
		<Team County = "Zimbabwe" score="7435"></Team>
		<Team County = "England" score="7435"></Team>
	</MatchDetails>'
);

--Create a typed xml variable by sing the 'CricketSchemaCollection'
Declare @team xml(CricketSchemaCollection);
set @team = '<MatchDetails><Team country="Australia"></Team></MatchDetails>'
--Display the contents of the schema xml variable
select @team as 'Team';

--Demonstrate the use of the exist xml function to determine if there's
--a tea, element whose immediate parent is a MAtchDetails element
select TeamID
from CricketTeam
where TeamInfo.exist
(
	'((/MatchDetails/Team)') = 1'
);


SELECT TeamInfo.query('/MatchDetails/Team') AS Info
FROM CricketTeam


SELECT TeamInfo.value('(/MatchDetails/Team/@score)[1]', 'varchar(20)') AS Score
FROM CricketTeam
where TeamID=1