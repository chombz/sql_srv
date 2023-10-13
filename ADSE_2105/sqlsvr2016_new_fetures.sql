/*This session is the introduction of new ftures introducing SQL Sever 2016  */



/*        24/11/2021             */

--switch databases
USE Edwin_Customer_DB_2105;

--Create an emplolyee JSON table
CREATE TABLE Employees_json
	(
		ID INT IDENTITY (1,1) NOT NULL,
		FirstName nvarchar(255),
		LastName nvarchar(255),
		Grade INT,
		Age DECIMAL (3,1)
	);

insert into Employees_json

	(FirstName, LastName, Grade, Age)

		SELECT 'Mark', 'Thomas', 2, 45
	UNION ALL
		SELECT 'Salmon', 'John', 1, 56
	UNION ALL
		SELECT 'Kirsten', 'Powell', 3, 28
	union all
		select 'Edwin', 'Chomba', 2, 18


--query to retrieve the date in employee_json table using json AUTO 
SELECT Id, 
		FirstName as 'Employee.FirstName', 
		LastName as 'Employee.LastName', 
		Grade, 
		Age 
FROM Employees_json 
FOR JSON AUTO;

--Display the table
SELECT * FROM Employees_json;


--query to retrieve the date in employee_json table using json AUTO 
SELECT Id, FirstName, LastName, Grade, Age 
FROM Employees_json 
FOR JSON PATH;