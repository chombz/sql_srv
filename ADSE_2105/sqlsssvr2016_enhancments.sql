/*This session is the introduction of SQL_SVR2016 of Enhacments */



/*        25/11/2021             */

--switch databases
USE Edwin_Customer_DB_2105;

--Create a table to demonstrate system versioning
Create table dbo.ExampleTable
	(
		From_Date datetime2 not null,
		To_Date datetime2 not null
	);


--Enable system versioning
ALTER TABLE dbo.ExampleTable
add constraint pk_daterecord
primary key pk_daterecord from_date, to_date
ADD ValidFrom datetime2 GENERATED ALWAYS AS ROW START
HIDDEN NOT NULL,
ValidTo datetime2 GENERATED ALWAYS AS ROW END 
HIDDEN NOT NULL,
PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo);

ALTER TABLE dbo.ExampleTable
SET (SYSTEM_VERSIONING = ON (HISTORY_TABLE =
dbo.ExampleHistoryTable));

--Add a record into the exampletable
INSERT INTO dbo.ExampleTable
VALUES
('2016-07-04 6:26:00', '2016-07-04 6:28:00');

SELECT * FROM dbo.ExampleTable;



--Dasable system versioning on the exampletable
ALTER TABLE dbo.ExampleTable
SET(SYSTEM_VERSIONING = off);

--Add a new column to the example and historyExample table
ALTER TABLE dbo.ExampleTable
ADD NewColumn NVARCHAR(10);

ALTER TABLE dbo.ExampleHistoryTable
ADD NewColumn Nvarchar(10);

--re-enable system versioning
ALTER TABLE dbo.ExampleTable
SET(SYSTEM_VERSIONING = on(history_table =dbo.ExampleHistoryTable));



