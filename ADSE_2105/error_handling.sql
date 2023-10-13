/*This session is the introduction of error handling whole writng T-SQL  */



/*        22/11/2021             */

--switch databases
USE Edwin_Customer_DB_2105;


--Illustrate the use of try...catch block to handle div by zero error 
Begin try 

	declare @num int 
	select @num = 217 / 0 
	select @num as Quotient; 
end try 
	Begin catch Print 'Error encountered, you cannot divide by zero. Please change the denominator to a non-zero value.' 
end catch;



--Illustrate the use of try...catch block to handle div by zero error amd display the error information
Begin try 

	declare @num int 
	select @num = 217 / 0 
	select @num as Quotient; 
end try 
Begin Catch
	Select
	ERROR_NUMBER()as 'Error Number',
	ERROR_SEVERITY()as 'Error Severity',
	ERROR_LINE()as 'Error Line',
	ERROR_MESSAGE()as 'Error Message'
	Print 'Error encountered, you cannot divide by zero. Please change the denominator to a non-zero value.' 
end catch;



--Practical use of try...catch and error functions in a transaction 
Begin transaction

begin try 
	delete from AdventureWorks2016.Production.Product 
	where ProductID = 980; 
end try 

begin catch 
	Select Error_Number() as 'Error Number', --Display error number 
	ERROR_SEVERITY() as 'Error Severity', --Display error severity
	 ERROR_LINE() as 'Error Line', --Display line where error occured 
	 ERROR_MESSAGE() as 'Error Message', --Display error message 
	 ERROR_STATE() as 'Error State', 
	 ERROR_PROCEDURE() as 'Error Procedure'
	 --Check the content of the trancount
	 (Transaction count) 
	 --global variable and rollback when its < 0 i.e. transaction 
--failed. if(@@TRANCOUNT > 0) rollback tran; 
end catch;





--Demonstrate the use of @@ERROR to check for constraint violation 
begin try update AdventureWorks2016.HumanResources.EmployeePayHistory 
	set PayFrequency = 4 
	where BusinessEntityID = 1; 
end try 

begin catch 
	if @@ERROR = 547 
		print 'Check constraint violation has occured!' 
	else 
		print 'You don''t have permission to update this table'
end catch 
	if(@@TRANCOUNT > 0) 
	Commit transaction


--Demostrate how to build a RAISERROR statement to display a customised error statement
Raiserror ('This is an error message %s %d.', 10,1,'Serial Number', 23);

--Demonstrate how to raise the same error statement in different ways
Raiserror ('%*.*s', 10, 1, 7,19, 'Hello World');
--alternatively
Raiserror ('%7.19s',10,1, 'Hello World');




--Demonstrate the use of ERROR_STATE() and ERROR_SEVERITY()
Begin try
	select 217 / 0;
end try
Begin catch
	select
	ERROR_STATE() As [Error State],
	ERROR_SEVERITY() As 'Error Severity'
end catch;



--Create a faulty user defined procudure and use to ERROR_PROCUDURE function
--to get the name of the faulty procudure
if OBJECT_ID('usp_Example','P') is not null
	drop proc usp_Example;
Create proc usp_Example
as
	select 34/0;
--invoke the faulty procedure

begin try
	exec usp_Example;
end try

begin catch
	Select ERROR_PROCEDURE() as 'Faulty Procedure'
end catch;




--Demonstrate how to get the ERROR_NUMBER(), ERROR_MESSAGE() and ERROR_LINE(),
--that causes the catch block to execute
Begin try
select 217 / 0;
end try
Begin catch
select
ERROR_NUMBER() As [Error Number],
ERROR_MESSAGE() As 'Error Message',
ERROR_LINE() AS 'Line where error occured'
end catch;



--Demonstrate how an object name resolution error is generated using
-- a select statement
	Begin try
		select * from dbo.nonexistent;
	end try

	begin catch

--displaying the error number and message
	select
		ERROR_NUMBER() as [Error Number],
		ERROR_MESSAGE() as [Error Message]
	end catch;




--Show how to display the error message for the above scenario
--Check if the user defined procedure usp_Example exists and drop it,
--then recreate it
	if OBJECT_ID('usp_Example1','P') is not null
		drop proc usp_Example1;
	create proc usp_Example1
	as
		select * from dbo.nonexistent;

	Begin try
		exec usp_Example1;
	end try

	begin catch
--displaying the error number and message
select
ERROR_NUMBER() as [Error Number],
ERROR_SEVERITY() As 'Error Severity',
ERROR_MESSAGE() as [Error Message]
end catch;


--Demonstrate how to throw and catch exceptions in TSQL
create table TestRethrow
	(
		ID int primary key
	);

--Try to insert duplicate records
begin try
	insert into dbo.TestRethrow
	values
		(1),
		(1);
end try

begin catch
		print 'We are inside the catch block';
		throw;
end catch