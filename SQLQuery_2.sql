use Syracusehousing
GO

-- select * from Leasing_details
-- select * from Units
-- select * from Units



DROP PROCEDURE if EXISTS add_lease
GO
--Stored Procedure to add a lease in the table
CREATE PROCEDURE add_lease(@student_id int,@unit_id int, @start_leasedate VARCHAR(20), @end_leasedate VARCHAR(20), @deposit varchar(10)) 
AS BEGIN
DECLARE @var1 INT
SET @var1 = (select count(*) from Leasing_details where lease_student_id = @student_id and lease_enddate > CAST(@start_leasedate AS DATE))
DECLARE @var2 INT
SET @var2 = (select count(*) from Leasing_details where lease_unitid = @unit_id and lease_enddate > CAST(@start_leasedate AS DATE))
IF @var1 >= 2 OR @var2 >= 2
BEGIN
print('Cannot add this lease!')
END
ELSE
BEGIN
INSERT into Leasing_details (lease_startdate, lease_enddate,lease_unitid,lease_student_id, lease_security_deposit)
    VALUES
    (@start_leasedate, @end_leasedate, @unit_id, @student_id,@deposit)
END
END    
GO
--Stored Procedure to add an Enquiry in the table
GO
CREATE PROCEDURE add_enquiry(@date DATE,@unit_id int, @firstname VARCHAR(20), @lastname VARCHAR(20), @email varchar(25),@comments VARCHAR(50)) 
AS BEGIN
INSERT into Enquiries
VALUES
(@date)
DECLARE @enquiry_ID INT
SET @enquiry_ID = (select Max(Enquiry_ID) from Units_Enquiries)
INSERT into Units_Enquiries (Unit_ID,Enquiry_ID,Enquiry_FirstName,Enquiry_LastName,Enquiry_EmailID,Enquiry_Comments)
VALUES
(@unit_id,@enquiry_ID,@firstname,@lastname,@email,@comments)
END
GO

Select * from Leasing_Details




select * from Units_Enquiries
/* EXEC add_lease @student_id=2, @unit_id=2, @start_leasedate = '2020-11-25', @end_leasedate = '2021-12-2022' , @deposit = '900'
GO */
--Trigger to check if an e-mail is of syr.edu domain
DROP TRIGGER IF EXISTS check_student_email
GO

CREATE TRIGGER check_student_email 
ON dbo.Students
FOR INSERT
AS
BEGIN
    DECLARE @stud_id int
    DECLARE @email varchar(50)

    SELECT @email = student_email FROM inserted

    IF EXISTS(SELECT RIGHT(@email, 7) as Col_name from INSERTED
    where 'syr.edu' in (SELECT RIGHT(@email, 7)))
        BEGIN
        print('Valid email')
        END
    ELSE
    SELECT @stud_id = student_id FROM inserted
    DELETE FROM dbo.Students WHERE student_id =  @stud_id
    print('Invalid email')

 END
GO

--
select * from Leasing_details

INSERT into Leasing_details (lease_startdate, lease_enddate, lease_unitid, lease_security_deposit, lease_student_id)
VALUES
('2021-01-01', '2024-12-31',1,700,2)
GO
DECLARE @var1 INT
SET @var1 = (select count(*) from Leasing_details where lease_student_id = 2 and lease_enddate > CAST('2023-03-01' AS DATE))
DECLARE @var2 INT
SET @var2 = (select count(*) from Leasing_details where lease_unitid = 7 and lease_enddate > CAST('2023-03-01' AS DATE))
IF @var1 >= 1 OR @var2 >= 1
BEGIN
print('Not possible')
END
ELSE
BEGIN
print('Add it!')
END


/* IF EXISTS (select * from Leasing_details where lease_student_id = 2 and lease_enddate > CAST('2021-03-01' AS DATE)) 
    OR  EXISTS(select * from Leasing_details where lease_unitid = 7 and lease_enddate > CAST('2023-01-01' AS DATE)) BEGIN
    print('Either the student has an active lease or the unit is already under lease at that time. Cannot add this lease!')END

ELSE
BEGIN
print('All set')
END
GO */
--)
--Trigger to ensure a student with an active lease is not added or a unit currently under lease is not overbooked.
GO
CREATE TRIGGER add_valid_lease 
ON dbo.Leasing_details
AFTER INSERT
AS
BEGIN
    DECLARE @lease_id_test int
    DECLARE @stud_id int
    DECLARE @unit_id INT
    DECLARE @start_leasedate DATE 
    DECLARE @end_leasedate DATE
    DECLARE @var1 INT
    DECLARE @var2 INT
    --DECLARE @email varchar(50)
    
    SELECT @lease_id_test =  lease_id FROM inserted
    SELECT @stud_id =  lease_student_id FROM inserted
    SELECT @unit_id =  lease_unitid FROM inserted
    SELECT @start_leasedate = lease_startdate FROM inserted
    SELECT @end_leasedate = lease_enddate FROM inserted
    SET @var1 = (select count(*) from Leasing_details where lease_student_id = @stud_id and lease_enddate > CAST(@start_leasedate AS DATE))
    SET @var2 = (select count(*) from Leasing_details where lease_unitid = @unit_id and lease_enddate > CAST(@start_leasedate AS DATE))
    print(@start_leasedate)
    print(@unit_id)
    print(@var1)
    print(@var2)
    IF @var1 >= 2 OR @var2 >= 2
    BEGIN
    print('Either the student has an active lease or the unit is already under lease at that time. Cannot add this lease!')
    DELETE FROM dbo.Leasing_details WHERE lease_id =  @lease_id_test
    END
    ELSE
    BEGIN
    --SELECT @stud_id = student_id FROM inserted
    print('Valid Lease.Entry has been addded!')
    END
END
--Create a trigger to ensure you don't add more wings than total no of permitted wings for each tower
GO
CREATE TRIGGER check_tower_wings
On dbo.Tower_Wings
FOR INSERT
AS
BEGIN
    DECLARE @tower_id_test int
    DECLARE @wing_id_test INT
    DECLARE @permitted_tower_wings_test INT
    DECLARE @existing_n_wings INT

SELECT @tower_id_test = tower_id FROM inserted
SELECT @wing_id_test = Wing_id from inserted

    SET @permitted_tower_wings_test = (SELECT Tower_total_wings from Tower_Details where tower_id = @tower_id_test)
    SET @existing_n_wings = (SELECT count(*) from Tower_Wings where Tower_id = @tower_id_test)
    IF @existing_n_wings >= @permitted_tower_wings_test +1
    BEGIN
    DELETE FROM dbo.Tower_Wings where Tower_id = @tower_id_test and Wing_id = @wing_id_test
    print('Cannot add more wings to this tower!')
    END
    ELSE
    print('Wing added for this particular tower.')
END
GO
-- 




--insert additional wings for tower 1 and check trigger functionality
GO
select * from dbo.Tower_Wings
insert into Tower_Wings (Tower_id,wing_id)
VALUES
(1,16)

--insert invalid lease
GO
select * from dbo.Leasing_details
EXEC dbo.add_lease @student_id=2, @unit_id=2, @start_leasedate = '2030-11-25', @end_leasedate = '2031-12-22' , @deposit = '900'
insert into Leasing_details (lease_startdate, lease_enddate, lease_unitid, lease_security_deposit, lease_student_id)
VALUES
('2020-11-15', '2021-12-31', 2,600,3)


-- insert correct email
INSERT INTO dbo.Students (student_suid, student_firstname, student_lastname, student_email, student_phone) VALUES ('225429', 'this', 'world', 'dpgg@syr.edu', '5252565')
select * from Students

-- Insert wrong email
INSERT INTO dbo.Students (student_suid, student_firstname, student_lastname, student_email, student_phone) VALUES ('4546555', 'that', 'world', 'tddat@world.edu', '2588252')
--available units
DROP VIEW if exists UnitsAvailable
GO

GO
--CREATE VIEW OF AVAILABLE UNITS
CREATE VIEW UnitsAvailable AS
select DISTINCT(unit_id) as View_unitid,Units.tower_id,Units.owner_id, Units.Balcony,Units.Rent,Units.furnished,Units.pets, Units.parking,Units.owner_comments from Leasing_details
join Units on Leasing_details.lease_unitid = Units.unit_id
join Tower_Details on Units.tower_id = Tower_Details.tower_id
where lease_enddate < cast(GETDATE() as DATE);
GO
Select * from UnitsAvailable
---CREATE VIEW OF UNAVAILABLE UNITS
GO
DROP VIEW IF EXISTS Units_NotAvailable
GO
CREATE VIEW Units_NotAvailable AS
select DISTINCT(unit_id) as View_unitid,Units.tower_id,Units.owner_id, Units.Balcony,Units.Rent,Units.furnished,Units.pets, Units.parking,Units.owner_comments,Leasing_details.lease_enddate from Leasing_details
join Units on Leasing_details.lease_unitid = Units.unit_id
join Tower_Details on Units.tower_id = Tower_Details.tower_id
where lease_enddate > cast(GETDATE() as DATE);
GO
select * from Units_NotAvailable
--
GO
--VIEW of all students without an active lease
GO
CREATE VIEW Students_without_Lease AS
with active_lease_tables as ( select * from Leasing_details
where lease_enddate > cast(GETDATE() as DATE))
select * from Students
left join active_lease_tables as x on Students.student_id = x.lease_student_id
where lease_id is NULL 
GO
Select * from Students_without_Lease
--VIEW Of students with an active lease
GO
CREATE VIEW Students_with_Lease AS
with active_lease_tables as ( select * from Leasing_details
where lease_enddate > cast(GETDATE() as DATE))
select * from Students
left join active_lease_tables as x on Students.student_id = x.lease_student_id
where lease_id is NOT NULL 
GO
Select * from Students_with_Lease
--select * from Tower_Details
GO
select * from UnitsAvailable

select * from Units

select * from Units_NotAvailable

select * from Leasing_details
INSERT into Leasing_details (lease_startdate, lease_enddate, lease_unitid, lease_security_deposit, lease_student_id)
VALUES
('2021-01-01', '2021-12-31',1,700,3)

INSERT into Students (student_suid,student_firstname, student_lastname, student_email,student_phone)
VALUES ('1234567787', 'Anand', 'Vamsi', 'avamsi@syr.edu', '989876543')
---

































--CREATE TRIGGER syrhousing.addlease
--on Leasing_details
--AFTER INSERT
--BEGIN
    --IF exists (select * from Leasing_details 
    --where lease_student_id = )

--IF EXISTS (select count(*) from Leasing_details where lease_student_id = 2 and lease_enddate > '2020-11-15')
--GO


/* CREATE PROCEDURE add_lease(@student_id int,@unit_id int, @start_leasedate DATE, @end_leasedate DATE, @deposit) 
AS BEGIN
IF exists (select * from Leasing_details
where lease_student_id = @student and lease_enddate > @start_leasedate) OR IF exists(select * from Leasing_details where lease_unitid = @unit_id and lease_enddate >@start_leasedate)
BEGIN
PRINT ('Cannot add this lease')
return NULL
END
ELSE
INSERT into Leasing_details (lease_startdate, lease_enddate,lease_unitid,lease_student_id, lease_security_deposit)
    VALUES
    (@start_leasedate,@end_leasedate, @unit_id, @student_id,@deposit) */


--SUBSTR('column', LENGTH('column') - 3, 4)
--IF EXISTS (SELECT RIGHT('column', 3) as Col_name
        --where 'syr.edu' in Col_name)
--ND
/* GO
CREATE TRIGGER check_student_email 
ON dbo.Students
FOR INSERT
AS
BEGIN
    DECLARE @stud_id int
    DECLARE @email varchar(50)

    SELECT @email = student_email FROM inserted

    IF EXISTS(SELECT RIGHT(@email, 7) as Col_name from INSERTED
    where 'syr.edu' in (SELECT RIGHT(@email, 7)))
        BEGIN
        print('Valid email')
        END
    ELSE
    SELECT @stud_id = student_id FROM inserted
    DELETE FROM dbo.Students WHERE student_id =  @stud_id
    print('Invalid email')

 END
 */

/* FOR EACH ROW
BEGIN

END;



GO 





IF EXISTS(SELECT RIGHT('avamsi@gmail.com', 7) as Col_name
    where 'syr.edu' in (SELECT RIGHT('avamsi@gmail.com', 7)))
BEGIN
print('Valid email')
END
ELSE
print('Invalid email')


SELECT RIGHT('avamsi@gmail.com', 7)


SELECT * FROM Students;




--CREATE TRIGGER check_student_email_before
--ON dbo.Students
--after INSERT
/* AS
BEGIN
    DECLARE @stud_id int
    DECLARE @email varchar(50)

    SELECT @email = student_email FROM inserted

    IF EXISTS(SELECT RIGHT(@email, 7) as Col_name from inserted
    where 'syr.edu' in (SELECT RIGHT(@email, 7)))
        BEGIN
        print('Valid email')
        END
    ELSE
    BEGIN
    SELECT @stud_id = student_id FROM inserted
    DELETE FROM dbo.Students WHERE student_id =  @stud_id
    print('Invalid email')
    END
 END */
--IF exists (select * from Leasing_details
--where lease_student_id = @student and lease_enddate > @start_date) BEGIN
    --print('The said student is already under an active lease at that time')

--IF exists (select * from Leasing_details
    --where lease_unitid = @unit_id and lease_enddate > @start_date) 
--BEGIN
    --print('The said unit is already under an active lease at that time')
--end



/* DECLARE @student INT = 2
DECLARE @unit_id INT = 1
DECLARE @start_date DATE = '2020-11-15'
BEGIN;
select  
(CASE 
    WHEN ((SELECT TOP(1) lease_enddate from Leasing_details where lease_student_id =  @student ORDER BY lease_enddate DESC)  > @start_date) 
    THEN 'The said student is already under an active lease at that time'
    WHEN ((SELECT TOP(1) lease_enddate from Leasing_details where lease_unitid = @unit_id ORDER BY lease_enddate DESC) > @start_date) 
    THEN 'The said unit is already under an active lease at that time'
    ELSE 'Unit and Student Available'
END)
AS avail;

END; */
 */
-- DECLARE @rseult INT;
-- SET @rseult = 2

-- IF exists (SELECT @rseult)
-- BEGIN print('Avaibalble')
-- end



/* DECLARE @TestVariable AS int

SET @TestVariable = (select max(Tower_total_wings) from Tower_Details
where tower_id = 1)

print(@TestVariable) */