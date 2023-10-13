/*This session is the introduction of SQL_SVR2016 of Security amd how to protect data  */



/*        26/11/2021             */

--switch databases
USE Edwin_Customer_DB_2105;



--Create an encrypted table using the Column Encrypted Key


Create Table Employees_Encrypted
(
	EmpName nvarchar(60) Collate Latin1_General_BIN2 encrypted with
		(
			column_encryption_key = Demo_Always_Encrypted_2105,
			encryption_type = randomized,
			ALGORITHM ='AEAD_AES_256_CBC_HMAC_SHA_256'
		),

	[UID] nvarchar(11) Collate Latin1_General_BIN2 encrypted with
		(
			column_encryption_key = Demo_Always_Encrypted_2105,
			encryption_type = randomized,
			ALGORITHM ='AEAD_AES_256_CBC_HMAC_SHA_256'
		),
			
		Age int null
);




--Create a table with dynamic data masking(DDM) 
Create table [NewGroup] 
	(
		[UID] int identity primary key not null, 
		FNM nvarchar(100) masked with (function = 'partial(1,"#######",0)') null, 
		FatherName nvarchar(100) not null, 
		Mobile nvarchar(12) masked with (function = 'default()') null, 
		PersonalEmail nvarchar(100) masked with (function = 'email()') null 
	); 

--Insert records into the newgroup table 
Insert into NewGroup(FNM,FatherName,Mobile,PersonalEmail) 
values 
	('Johnson','Flanagan','12345688','JohnsonFlan@yahoo.com'), 
	('Rossell','Geller','7654218','RossGeller@hotmail.com'), 
	('Brook','Darwin','88956585','BrookDarwin@gmail.com'); 
	
--Display the records from the newgroup table 
select * from NewGroup;

--Create a new user and grant/assign them read/select permissions on the newgroup table
create user DemoUser without login;
grant select on newgroup to DemoUser;

--Display the contents of the newgroup table as the 'DemoUser' login created above
execute as user = 'DemoUser';
select * from NewGroup;

--Revert to the previous user(dbo)
revert;



--Modify an existing column and add DDM to it using the partial function 
alter table newgroup alter column fathername add masked with 
(
	function = 'partial(2,"****",0)'
);


--Modify an existing column and remove DDM to it using the FatherName function 
alter table newgroup alter column fathername DROP MASKED;


--Declare a JSON variable and its details
DECLARE @JSON NVARCHAR (MAX) = N'
	{
		"InitialName": null,
		"MaidenName": "Dawson ",
		"UID": 9988776655,
		"Current": false,
		"Skills": ["DevOps", "Python", "Perl"],
		"Region": {"Country":"USA","Territory":"North America"}
	}';

--Display the contents of the JSON Variable
SELECT * FROM OPENJSON (@json);
