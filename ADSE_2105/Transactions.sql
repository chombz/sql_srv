/*This session is the introduction of Transactions */



/*        19/11/2021             */

--switch databases
USE Edwin_Customer_DB_2105;


--Add a new employee
	insert into dbo.EmployeeDetails values
		(
			106,'James','Gichuru','1994-06-16','Male','Kawangware'
		);

--Begin a transaction with rollback
--delete the details for James Gichuru
	DECLARE @TransName nvarchar(38);
	SELECT @TransName = 'FirstTransaction';

	BEGIN TRAN @TransName;
		DELETE FROM dbo.EmployeeDetails
		WHERE EmpID = 106;
	ROLLBACK TRAN--undo the transaction

--Display the records
SELECT * FROM dbo.EmployeeDetails;

 
--Begin a transaction with commit train
--delete the details for James Gichuru
	DECLARE @DeleteJames nvarchar(38);
	SELECT @DeleteJames = 'FirstTransaction';

	BEGIN TRAN @DeleteJames;
		DELETE FROM dbo.EmployeeDetails
		WHERE EmpID = 106;
	COMMIT TRAN--undo the transaction


--Begin a transaction with mark
--delete the details for James Gichuru
	DECLARE @DeleteJames_WithMark nvarchar(38);
	SELECT @DeleteJames_WithMark = 'Delete James and mark the transaction';

	BEGIN TRAN @DeleteJames_WithMark;
	WITH mark N'Deleting James.';--mark the transaction in the log file
		DELETE FROM dbo.EmployeeDetails
		WHERE EmpID = 106;
	COMMIT TRAN--undo the transaction




--Demonstrate rolling back a transaction
	Create table ValueTable
	(
		[Value] nchar not null
	);

--Insert Values into the Values table using explicit transactions
	Begin tran
	Insert into dbo.ValueTable values
		('A'),
		('B')
	go
--display the details in the value table
	select * from dbo.ValueTable
--Undo the inserts
	rollback tran



--Creating a stored procedure with a save point
	Create proc SaveTransExample
	@InputCandidateID int
	as
		Declare @TranCounter int;
		Set @TranCounter = @@TRANCOUNT;
	If @TranCounter > 0
		Save tran ProcedureSave;
	Else
	
	Begin Tran;
	Delete from
		AdventureWorks2016.HumanResources.JobCandidate
	where JobCandidateID = @InputCandidateID;
	If @TranCounter = 0
		print 'Transaction Successful!'
	commit tran;

	if @TranCounter = 1
		print 'Transaction Rolledback!'
	rollback tran ProcedureSave;

--Write the statement to run the above stored procedure
	exec SaveTransExample 13;




--Demonstrate the use of the @@trancount function in nested begin and commit statements
		Print @@Trancount
	begin tran
		print @@Trancount
	begin tran
		print @@Trancount
	commit
		print @@Trancount
	commit
		print @@Trancount



USE AdventureWorks2016
GO
BEGIN TRANSACTION ListPriceUpdate
WITH MARK 'UPDATE Product list prices';
GO
UPDATE Production.Product
SET ListPrice = ListPrice * 1.20
WHERE ProductNumber LIKE 'BK-%';
GO
COMMIT TRANSACTION ListPriceUpdate;
GO