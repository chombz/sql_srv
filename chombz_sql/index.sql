/*This session is the introduction of indexes */



/*        10/11/2021             */

--switch databases
USE Edwin_Customer_DB_2105;



--Display the objectid of the products and customer's table
select object_id('products') as [Products Table ObjectID];
select object_id('Customers') as [Customers Table ObjectID];

--Display the objectnames of given objectids
select object_name(1029578706) as [Name of ObjectID 1029578706];
select object_name(581577110) as [Name of ObjectID 581577110];

--Display the version of the sqlserver in which this script is running
Select SERVERPROPERTY('productversion') as [SQL Server Version];

--Display the edition of the sqlserver in which this script is running
Select SERVERPROPERTY('edition') as [SQL Server Edition];


--Display a list of current user connection details from the
--sys.dm_exec_sessions view
Select session_id, login_name, login_time, program_name
from sys.dm_exec_sessions
where login_name = 'EDULINK\e.Chomba' and is_user_process = 1;

--Create an index on the productid column of the Product_Details table
create index ixProdID on dbo.ProductName(ProductModelID);


/*           11/11/20                     */


--create a cluster index

CREATE CLUSTERED INDEX Salary ON Employee_Salary_Details(EmpID)

--create an none-clustred index
CREATE NONCLUSTERED INDEX IX_State ON Customer_1(CustID)




--Display all the details from the sys.partitions view
select * from sys.partitions;




--Create an EmployeeDetails Table
Create Table EmployeeDetails
(
	EmpID int not null,
	FirstName nvarchar(20) not null,
	LastName nvarchar(20) not null,
	DateOfBirth date not null,
	Gender nvarchar(6) not null,
	city nvarchar(30) not null
);

--Insert employee records
Insert into dbo.EmployeeDetails
values
(101, 'Andrew', 'Waller','1994-03-22', 'Male', 'Boston'),
(102, 'AJ', 'Sties','1992-02-14', 'Female', 'Liverpool'),
(103, 'Sophia', 'Broderich','1996-05-18', 'Female', 'Boston'),
(104, 'Shawn', 'Roderichs','1986-07-17', 'Male', 'Texas'),
(105, 'Edwin', 'Chomba', '1999-09-23', 'Male', 'Nairobi');
--Add your details as record 105
--display the employee records
SELECT * FROM dbo.EmployeeDetails;

--Create a non-clustered index on the city column of the
--employeedetails table
Create nonclustered index ixEmployeeCity
on dbo.EmployeeDetails(City);


--The above index is used by the DB Engine to search city details
--Get details of employees from 'Boston' city
Select EmpID as [Employee ID],
concat(Firstname, ' ', LastName) As [Employee Names], city
From dbo.EmployeeDetails
where city like 'Boston';


--Create a clustered index on the empID column
Create clustered index ixEmpID on dbo.EmployeeDetails(EmpID);

--The DB Engine will use this to search for queries using
--the empId as a filter/search criteria
--Query to display the employee details within the range 102 - 105
Select EmpID as [Employee ID],
concat(Firstname, ' ', LastName) As [Employee Names],
city
From dbo.EmployeeDetails
where EmpID >=102 and EmpID <=105;




--Create a table with computed values
CREATE TABLE Calc_Areaa
(
	Length decimal,
	Breadth int,
	Area AS Length*Breadth --> Computed column given by multiplying the length and breadth of the shape
);

--Add records into the calc_area table
insert into Calc_Areaa
values
(34,10),
(20,20),
(33.4,12),
(12,7);

--Display the contents of the calc_area table
select * from Calc_Areaa;




--Create an index on the computer column field of the calc_area table
CREATE INDEX px_area 
ON
Calc_Areaa(Area);

--Use the above Index to display those shapes with an area < 400
SELECT * FROM Calc_Area
WHERE Area < 400;




--1. Create an Employee's Table
Create Table Employeee
(
	EmpID int not null primary key,
	EmpName nvarchar(100) not null,
	Salary int not null,
	Address nvarchar(200) not null
);

--2. Insert employee records
Insert into dbo.Employeee
values
(1,'Derek', 12000, 'Houston'),
(2,'David', 25000, 'Texas'),
(3,'Alan', 22000, 'New York'),
(4,'Matthew', 22000, 'Las Vegas'),
(5,'Joseph', 28000, 'Chicago');

--3. Confirm entry of records into the Employee's Table
Select * from Employeee;



--4. Declare a cursor on the Employee's Table
set nocount on
declare @id int, @name nvarchar(100), @salary int
--A cursor is declared by defining sql statements that return a resultset
declare curEmp Cursor
static for
Select EmpID, EmpName, Salary from employee
--A cursor is opened and populated by executing the statement(s)
--defined in the cursor
open curEmp
--Execute the statements below if the emp cursor contains rows
if @@CURSOR_ROWS > 0
begin
--Rows are fetched from the cursor one by one or in a block
--for data manipulation
Fetch next from curEmp into @id, @name, @salary
while @@FETCH_STATUS = 0
begin
print 'ID: ' + convert(nvarchar(20),@id) + char(13) +
'Name: ' + @name + char(13) +
'Salary: ' + convert(nvarchar(20),@salary) + char(13)--> used for line break
Fetch next from curEmp into @id, @name, @salary
End
End
--Close the cursor explicitly
Close curEmp
--Delete the cursor definition and release all the system resources associated
--with the cursor
deallocate curEmp
set nocount off
