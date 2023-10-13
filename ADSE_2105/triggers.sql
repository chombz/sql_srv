/*This session is the introduction of triggers */



/*        15/11/2021             */

--switch databases
USE Edwin_Customer_DB_2105;

--Create am insert trigger that will present the insertion of salary amounts < 10000
CREATE TRIGGER minSalary
ON
dbo.Employee
AS
IF(SELECT Salary FROM Inserted) < 10000

BEGIN
	PRINT'The salary cannot be less that 10000'
	ROLLBACK
END

--Display the statements that were used to create the minSalary trigger
SELECT * FROM dbo.Employee;


--Try to insert a record with a salary amount less than 10K
INSERT INTO dbo.Employee
VALUES
(6,'Edwin', 6700, 'Embakasi');

--Display the new record
SELECT * FROM dbo.Employee;






--Create a trigger that will prevent entering birthdates greater
--than today's date
CREATE TRIGGER checkbirthdate
ON 
dbo.EmployeeDetails
FOR UPDATE
AS
IF(SELECT DateOfBirth FROM inserted) > GETDATE()

BEGIN
	PRINT 'Birth date cannot be after today''s date!'
	ROLLBACK
END

--display the updated trigger
SELECT * FROM dbo.EmployeeDetails;


--TRy to modify AJ's birthdate to some future date
UPDATE EmployeeDetails
SET BirthDate= '2015/06/02';
WHERE EmployeeID= 'E06';







--Create a trigger that will prevent the modification of
--employee ids
Create trigger CheckEmpId
on dbo.EmployeeDetails
for update as
if Update(EmpId)

begin
	print 'Sorry, you''re not allowed to change/modify the
	employee id!'
	rollback transaction
end

--Try to change/modify Aj's Employee ID
update dbo.EmployeeDetails
set EmpID = 110
where FirstName like 'AJ';


--insert tables 
insert into EmployeeDetails (EmpID, FirstName, LastName, DateOfBirth, Gender, City) values (1, 'Edin', 'Sangwin', '1978-03-10', 'Female', 'Licuan');
insert into EmployeeDetails (EmpID, FirstName, LastName, DateOfBirth, Gender, City) values (2, 'Karen', 'Ivashnyov', '1979-07-30', 'Female', 'Santa Cruz');
insert into EmployeeDetails (EmpID, FirstName, LastName, DateOfBirth, Gender, City) values (3, 'Briggs', 'Dameisele', '1971-03-06', 'Male', 'San Mateo');
insert into EmployeeDetails (EmpID, FirstName, LastName, DateOfBirth, Gender, City) values (4, 'Janina', 'Van Dijk', '1986-07-25', 'Female', 'Fukuma');
insert into EmployeeDetails (EmpID, FirstName, LastName, DateOfBirth, Gender, City) values (5, 'Vivyanne', 'Haggett', '1981-05-16', 'Female', 'Mora');
insert into EmployeeDetails (EmpID, FirstName, LastName, DateOfBirth, Gender, City) values (6, 'Clerc', 'Kingcott', '1998-07-28', 'Male', 'Ciudad Bolivia');
insert into EmployeeDetails (EmpID, FirstName, LastName, DateOfBirth, Gender, City) values (7, 'Melessa', 'Whitby', '1992-06-05', 'Female', 'Ushi');
insert into EmployeeDetails (EmpID, FirstName, LastName, DateOfBirth, Gender, City) values (8, 'Siward', 'Bugden', '1983-04-20', 'Male', 'Hörby');
insert into EmployeeDetails (EmpID, FirstName, LastName, DateOfBirth, Gender, City) values (9, 'Brigida', 'Drummond', '1988-11-18', 'Female', 'Liangzeng');
insert into EmployeeDetails (EmpID, FirstName, LastName, DateOfBirth, Gender, City) values (10, 'Saxe', 'Ethington', '1977-10-13', 'Male', 'Frutal');


select * from dbo.EmployeeDetails;

--create a delete trigger on the employee details table
CREATE TRIGGER checkEmpDelete on EmployeeDetails
AFTER DELETE AS
 
 BEGIN
	DECLARE @num int;
	SELECT @num = COUNT(*) FROM deleted
	PRINT 'The number of Employee fired is ' +  CONVERT (nchar,@num)
END


--Relieve an employee of their duties
delete from dbo.EmployeeDetails
where EmpID = 103;

DELETE FROM EmployeeDetails WHERE EmpID='807';

DELETE FROM dbo.EmployeeDetails
WHERE EmpID < 101;


truncate 





/*           16/11/2021         */

--Add records into the Employee_personal_details table
--obtained from session12
insert into dbo.Employee_Personal_Details
values
(1, 'Jack','Willson','24, Park Ave.'),
(2, 'Susan','Andrews','12, Hill Road'),
(3, 'Robin','Straus','B, Rock S.');

--display the records returned the employee details view
SELECT * FROM dbo.Employee_Personal_Details;


--Add records into the Employee_Salary_details table
--obtained from session12
insert into dbo.Employee_Salary_Details
values
(1, 'Accountant',8000),
(2, 'Reviewer',12000),
(3, 'Admin',12500);


--display the records returned the employee details view
SELECT * FROM dbo.Employee_Salary_Details;



--Create an employee details view
Create view dbo.vwEmployee_Details 
as
Select EP.EmpID, EP.FirstName, EP.LastName, ES.Designation,
ES.Salary
From Employee_Personal_Details EP
Join Employee_Salary_Details ES
on EP.EmpID = ES.EmpID;


--Create an instead of delete trigger on the employee details view
Create trigger Delete_Employees
on dbo.vwEmployee_Details
Instead of Delete as
Begin
	Delete from Employee_Salary_Details where EmpID in
	(Select EmpID from deleted)
	Delete from Employee_Personal_Details where EmpID in
	(Select EmpID from deleted)
	declare @deletedEmpID int
	select @deletedEmpID = (select EmpID from deleted)
	Print 'The details of employee id ' + convert(nvarchar(20),@deletedEmpID) + ' have been deleted.'
End



--display the records returned the employee details view
SELECT * FROM vwEmployee_Details;



--delete the details for Jack Wilson the reviewer
DELETE FROM dbo.Employee_Personal_Details
WHERE ADDRESS like 'New York';


--Delete the details of Robin straus using the view
Delete from vwEmployee_Details where empId = 3;



--Find out whether the Delete_Employees trigger exists
select object_id('Delete_Employees') as [Emp. Deletion Trigger ObjectID];

--Set the execution order of the Delete_employees trigger
exec sp_settriggerorder @triggername = 'Delete_Employee', @order = 'First',
@stattype = 'Delete';

--view the definition of the Delete_Employees trigger
exec sp_helptext 'Delete_Employees';







--modify the checkEmpID trigger
Alter trigger checkEmpID
on Employeedetails
with encryption
for insert as
if '101' in (Select empId from inserted)

Begin
	print 'Sorry, you cannot employ citizens of Austria'
	rollback transaction
End

--view the definition of the checkEmpID trigger
exec sp_helptext 'checkEmpID';--Not viewable as it has been encrypted




--create a dummy trigger that will be used to demonstrate deleting trigge(s)
Create trigger dummyTrigger
on Employeedetails
with encryption
for insert as
if '101' in (Select empId from inserted)

Begin
	print 'Sorry, you cannot employ citizens of Austria'
	rollback transaction
End


--delete the dummy trigger
DROP TRIGGER dummyTrigger;









--Create a database trigger that will prevent the deletion
--of database tables
Create trigger secure
on database
with encryption
for drop_table,alter_table
as
print 'Sorry, you cannot delete this table until you delete the secure trigger!'
Rollback; --Maintain consistency in ACID


--Create a dummy table and try to delete it. This activates the
--secure trigger
Create Table tblDummy
(
	DummyID int identity(50,1) not null primary key,
	DummyName nvarchar(100) not null,
	DummyData nvarchar(150) not null,
	DummyAddress nvarchar(200) not null
);

--try to delete the dummy table
DROP TABLE tblDummy;


--Create an after delete trigger
CREATE TRIGGER Employee_Deletion
ON Employee_Personal_Details
AFTER DELETE
AS

BEGIN
	PRINT 'Deletion will affect Employee_Salary_Details table'
	DELETE FROM Employee_Salary_Details WHERE EmpID IN
	(SELECT EmpID FROM deleted)
END