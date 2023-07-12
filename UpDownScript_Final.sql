if not exists(select * from sys.databases where name='Syracusehousing') 
    create DATABASE Syracusehousing
GO
use Syracusehousing
GO   


--DOWN
DROP TRIGGER IF exists check_tower_wings
DROP TRIGGER IF exists add_valid_lease
DROP TRIGGER if EXISTS check_student_email 
DROP PROCEDURE if EXISTS add_lease
GO
if Exists (SELECT * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
            where CONSTRAINT_NAME='fk_Units_Enquiries_Enquiry_ID')
            alter TABLE Units_Enquiries drop CONSTRAINT fk_Units_Enquiries_Enquiry_ID
if Exists (SELECT * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
            where CONSTRAINT_NAME='fk_Units_Enquiries_Unit_ID')
            alter TABLE Units_Enquiries drop CONSTRAINT fk_Units_Enquiries_Unit_ID           
GO
drop TABLE if EXISTS Units_Enquiries
drop TABLE if EXISTS Enquiries
GO
if Exists (SELECT * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
            where CONSTRAINT_NAME='fk_lease_student_id')
            alter TABLE Leasing_details drop CONSTRAINT fk_lease_student_id
GO
if Exists (SELECT * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
            where CONSTRAINT_NAME='fk_lease_unit_id')
            alter TABLE Leasing_details drop CONSTRAINT fk_lease_unit_id
GO           
drop TABLE if EXISTS Leasing_details
GO

drop TABLE if EXISTS Students
GO
if Exists (SELECT * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
            where CONSTRAINT_NAME='fk_floor_id_units')
            alter TABLE Units drop CONSTRAINT fk_floor_id_units
GO    
if Exists (SELECT * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
            where CONSTRAINT_NAME='fk_owner_id_units')
            alter TABLE Units drop CONSTRAINT fk_owner_id_units
GO    
if Exists (SELECT * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
            where CONSTRAINT_NAME='fk_tower_id_units')
            alter TABLE Units drop CONSTRAINT fk_tower_id_units
GO    
drop TABLE if EXISTS Units
GO
if Exists (SELECT * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
            where CONSTRAINT_NAME='fk_tower_floor_floor')
            alter TABLE Tower_Floor drop CONSTRAINT fk_tower_floor_floor
GO    
if Exists (SELECT * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
            where CONSTRAINT_NAME='fk_tower_floor_tower')
            alter TABLE Tower_Floor drop CONSTRAINT fk_tower_floor_tower
GO                    
drop table if EXISTS Tower_Floor
GO
if Exists (SELECT * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
            where CONSTRAINT_NAME='fk_floor_wing')
            alter TABLE Floors drop CONSTRAINT fk_floor_wing
drop table if EXISTS Floors
GO
if Exists (SELECT * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
            where CONSTRAINT_NAME = 'fk_tower_wing_id_wing')
            alter TABLE Tower_Wings drop CONSTRAINT fk_tower_wing_id_wing
GO
if Exists (SELECT * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
            where CONSTRAINT_NAME = 'fk_tower_wing_id_tower')
            alter TABLE Tower_Wings drop CONSTRAINT fk_tower_wing_id_tower
                        
GO            
drop table if EXISTS Tower_Wings
GO
drop table if EXISTS Wings
GO
drop table if EXISTS Tower_Details
GO
drop table if EXISTS Owners
GO



--UP METADATA
CREATE TABLE Owners(
    owner_id int IDENTITY not NULL, -- Identity is used for creating surrogate values, it basically gives serial number
    owner_firstname VARCHAR(10) not NULL,
    owner_lastname VARCHAR(10) not NULL,
    owner_contact_number VARCHAR(50) not NULL,
    owner_emailid VARCHAR(50) NOT NULL,
    CONSTRAINT pk_owner_id_owners PRIMARY KEY(owner_id),
    CONSTRAINT uq_owner_contact_number UNIQUE(owner_contact_number),
    CONSTRAINT uq_owner_emailid UNIQUE(owner_emailid)
)
GO
CREATE TABLE Tower_Details(
    tower_id int IDENTITY not NULL,
    tower_name VARCHAR(15) not NULL,
    tower_street_name VARCHAR(15),
    tower_pin_code VARCHAR(10) not NULL,
    Swimming_Pool BIT,
    Tower_GYM BIT,
    Tower_total_wings int not null,
    CONSTRAINT pk_tower_id PRIMARY KEY(tower_id),
    CONSTRAINT uq_tower_name UNIQUE(tower_name) 
);
GO
CREATE TABLE Wings(
    wing_id int IDENTITY not NULL,
    wing_name VARCHAR(20),
    CONSTRAINT pk_wing_id PRIMARY KEY(wing_id)
)
SET IDENTITY_INSERT Wings ON
GO
CREATE TABLE Tower_Wings(
    Tower_id int not NULL,
    Wing_id int not NULL,
    CONSTRAINT pk_tower_wing_id PRIMARY KEY(Tower_id, Wing_id),
    CONSTRAINT uq_tower_wing_id UNIQUE(Wing_id)
)
ALTER TABLE Tower_Wings add CONSTRAINT
        fk_tower_wing_id_tower FOREIGN KEY(Tower_id) REFERENCES Tower_Details(tower_id)
ALTER TABLE Tower_Wings add CONSTRAINT
        fk_tower_wing_id_wing FOREIGN KEY(Wing_id) REFERENCES Wings(wing_id)
GO              
CREATE TABLE Floors(
    floor_id int IDENTITY not null,
    floor_water_dispenser BIT,
    floor_wing_id int NOT NULL,
    floor_number int NOT NULL,
    CONSTRAINT pk_floor_id PRIMARY KEY(floor_id)
)
ALTER TABLE Floors add CONSTRAINT
        fk_floor_wing FOREIGN KEY(floor_wing_id) REFERENCES Wings(wing_id)
GO
--CREATE TABLE Tower_Floor(
    --Tower_id_Floor int NOT NULL,
    --Floor_id int not NULL,
    --CONSTRAINT pk_tower_floor_id PRIMARY KEY (Tower_id_Floor, floor_id)-)
--ALTER TABLE Tower_Floor add CONSTRAINT
        --fk_tower_floor_tower FOREIGN KEY(Tower_id_Floor) REFERENCES Tower_Details(tower_id)
--ALTER TABLE Tower_Floor add CONSTRAINT
        --fk_tower_floor_floor FOREIGN KEY(Floor_id) REFERENCES Floors(floor_id)
   
--GO
CREATE TABLE Units(
    unit_id int IDENTITY not NULL,
    tower_id int not NULL,
    owner_id int not NULL,
    Bed_type VARCHAR(15) not NULL,
    Balcony BIT,
    Rent int not NULL,
    furnished BIT,
    pets BIT,
    parking BIT,
    owner_comments VARCHAR(100),
    Floor_id int not null,
    CONSTRAINT pk_unit_id PRIMARY KEY(unit_id)
)         
ALTER TABLE Units add CONSTRAINT
        fk_tower_id_units FOREIGN KEY(tower_id) REFERENCES Tower_Details(tower_id)
ALTER TABLE Units add CONSTRAINT
        fk_owner_id_units FOREIGN KEY(owner_id) REFERENCES Owners(owner_id)
--ALTER TABLE Units add CONSTRAINT
        --fk_wing_id_units FOREIGN KEY(wing_id) REFERENCES Wings(wing_id)
ALTER TABLE Units add CONSTRAINT
        fk_floor_id_units FOREIGN KEY(Floor_id) REFERENCES Floors(floor_id)      
GO 
CREATE TABLE Students(
    student_id int IDENTITY not NULL,
    student_suid VARCHAR(15) not NULL,
    student_firstname VARCHAR(10) not NULL,
    student_lastname VARCHAR(10) not NULL,
    student_email VARCHAR(50) not NULL,
    student_phone VARCHAR(20) not NULL,
    CONSTRAINT pk_student_id PRIMARY KEY(student_id),
    CONSTRAINT uq_student_suid UNIQUE (student_suid),
    CONSTRAINT uq_email UNIQUE(student_email),
    CONSTRAINT uq_phone UNIQUE(student_phone)
)                    
CREATE TABLE Leasing_details(
    lease_id int IDENTITY not NULL,
    lease_startdate DATE not NULL,
    lease_enddate DATE not NULL,
    lease_unitid INT not NULL,
    lease_security_deposit int not NULL,
    lease_student_id int NOT NULL,
    CONSTRAINT pk_lease_id PRIMARY KEY(lease_id)
)
ALTER TABLE Leasing_details add CONSTRAINT
        fk_lease_unit_id FOREIGN KEY(lease_unitid) REFERENCES Units(unit_id)
ALTER TABLE Leasing_details add CONSTRAINT
        fk_lease_student_id FOREIGN KEY(lease_student_id) REFERENCES Students(student_id)       
GO         

CREATE TABLE Enquiries(
    Enquiry_id int IDENTITY not NULL,
    Enquiry_Date DATE not null,
    CONSTRAINT pk_Enquiry_id PRIMARY KEY(Enquiry_id)
)

CREATE TABLE Units_Enquiries(
    Unit_ID int not null,
    Enquiry_ID int not null,
    Enquiry_FirstName VARCHAR(10) not null,
    Enquiry_LastName VARCHAR(10) not null,
    Enquiry_EmailID VARCHAR(20) not null,
    Enquiry_Phone VARCHAR(20),
    Enquiry_Comments VARCHAR(100),
    CONSTRAINT pk_Units_Enquiries PRIMARY KEY(Unit_ID,Enquiry_ID)
)
ALTER TABLE Units_Enquiries add CONSTRAINT
        fk_Units_Enquiries_Unit_ID FOREIGN KEY(Unit_ID) REFERENCES Units(unit_id)
ALTER TABLE Units_Enquiries add CONSTRAINT
        fk_Units_Enquiries_Enquiry_ID FOREIGN KEY(Enquiry_ID) REFERENCES Enquiries(Enquiry_id)       
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
--Trigger to check if an e-mail is of syr.edu domain
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
GO
--Trigger to ensure more wings than permitted are not added per tower
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
--UP DATA
insert into Owners
(owner_firstname, owner_lastname, owner_contact_number, owner_emailid)
VALUES
('Marvin', 'Dodd', '3214567676', 'marvin.dodd12@gmail.com'),
('Shelley', 'Turner', '3115678998', 'shelley.t@yahoo.co.in'),
('Jack', 'Chapman', '6754345678', 'jack.chapman@hotmail.com'),
('Kelly', 'Santos', '5676543456', 'kelly.santos@uha.com'),
('Jonas', 'Bothas', '7897654323', 'jonas.bothas@outlook.com'),
('John', 'Miller', '4306045851', 'j.miller@randatmail.com'),
('Jasmine', 'Lloyd','8244482433', 'j.lloyd@randatmail.com'),
('Derek', 'Craig', '3267310415', 'd.craig@randatmail.com'),
('Sabrina', 'Scott', '3092569336', 's.scott@randatmail.com'),
('Fiona', 'Henderson', '9203988401', 'henderson@randatmail.com'),
('Ravi', 'Patel', '3152547668', 'ravi.patel@gmail.com'),
('Anand', 'Vamsi', '3157896652', 'anand.vamsi@gmail.com'),
('Yash', 'Senjaliya', '3154123316', 'yash.senjaliya@gmail.com'),
('Shelly', 'Eclair', '3157812234', 'shelly.eclair@gmail.com'),
('Karen', 'Buffum',	'3155431212', 'karen.buffam@yahoo.com')

insert into Tower_Details
(tower_name, tower_street_name, tower_pin_code, Swimming_Pool, Tower_GYM, Tower_total_wings)
VALUES
('Ernie Davis','Comstock Place', '13210',1,1,2),
('Shaw', 'Lexington Ave', '13210', 1,1,2),
('Saddler', 'Marshall Street', '13210', 0,1,2),
('Graham', 'Euclid Ave', '13210', 1, 0, 2)

insert into Wings
(wing_id,wing_name)
VALUES
(11,'WingAErnie'),
(12,'WingBErnie'),
(21,'WingAShaw'),
(22,'WingBShaw'),
(31, 'WingASaddler'),
(32, 'WingBSaddler'),
(41, 'WingAGraham'),
(42, 'WingBGraham')

--4 towers and 2 wings each tower
insert into Tower_Wings
(Tower_id, Wing_id)
VALUES
(1,11),
(1,12),
(2,21),
(2,22),
(3,31),
(3,32),
(4,41),
(4,42)

--Tower-Wing-Floor (Nomenclature of floor id)
insert into Floors
(floor_water_dispenser,floor_wing_id, floor_number)
VALUES
(1,11,1),
(1,11,2),
(1,12,1),
(1,12,2),
(0,21,1),
(0,21,2),
(1,22,1),
(1,22,2),
(0,31,1),
(0,31,2),
(0,32,1),
(0,32,2),
(1,41,1),
(1,41,2),
(1,42,1),
(1,42,2)

insert into Units
(tower_id,owner_id, Bed_type, Balcony,Rent,furnished,pets,parking,owner_comments,Floor_id)
VALUES
(1,1,'Queen',0,400,1,1,0,'Amazing room.Guaranteed good vibes',1),
(1,1,'Queen',0,400,1,1,0,'Amazing room.Guaranteed good vibes',1),
(1,1,'Single',1,350,1,1,0,'Amazing room.Guaranteed good vibes',2),
(1,1,'Single',1,350,1,1,0,'Amazing room.Guaranteed good vibes',2),
(1,2,'Queen',0,400,1,1,0,'Spacious room and pet friendly with furnishing',3),
(1,2,'Queen',0,400,1,1,0,'Spacious room and pet friendly with furnishing',3),
(1,3,'Queen',1,450,1,1,0,'Spacious room with balcony',4),
(1,3,'Queen',1,450,1,1,0,'Spacious room with balcony',4),

(2,3,'Single',0,350,1,1,1,'Spacious room',5),
(2,3,'Single',0,350,1,1,1,'Spacious room',5),
(2,4,'Single',1,375,1,1,1,'Amazing room.Guaranteed good vibes',6),
(2,4,'Single',1,375,1,1,1,'Amazing room.Guaranteed good vibes',6),
(2,4,'Queen',0,400,1,1,1,'Amazing room.Guaranteed good vibes',7),
(2,5,'Queen',0,400,1,0,1,'',7),
(2,5,'Queen',1,450,1,0,1,'',8),
(2,5,'Queen',1,450,1,0,1,'',8),

(3,6,'Queen',0,360,1,1,0,'Less than 5 Min walk, hardwood floors',9),
(3,6,'Queen',0,360,1,1,0,'Less than 5 Min walk, hardwood floors',9),
(3,6,'Single',1,375,1,1,0,'Less than 5 Min walk, Beautiful front porch and hardwood floors',10),
(3,6,'Single',1,375,1,1,0,'Less than 5 Min walk, Beautiful front porch and hardwood floors',10),
(3,6,'Single',0,360,1,1,0,'Less than 5 Min walk, hardwood floors',11),
(3,6,'Single',0,360,1,1,0,'Less than 5 Min walk, hardwood floors',11),
(3,7,'Single',1,360,1,1,0,'Amazing room.Guaranteed good vibes',12),
(3,7,'Single',1,360,1,1,0,'Amazing room.Guaranteed good vibes',12),

(4,8,'Queen',0,400,1,0,1,'Amazing room.Guaranteed good vibes',13),
(4,8,'Queen',0,400,1,0,1,'Amazing room.Guaranteed good vibes',13),
(4,9,'Queen',1,500,1,1,1,'Guaranteed good vibes',14),
(4,9,'Queen',1,500,1,1,1,'Guaranteed good vibes',14),
(4,9,'Queen',1,475,1,1,1,'Guaranteed good vibes',15),
(4,9,'Queen',1,475,1,1,1,'Guaranteed good vibes',15),
(4,10,'Queen',1,475,1,0,1,'Amazing room',16),
(4,10,'Queen',1,475,1,0,1,'Amazing room',16)

insert into Students
(student_suid,student_firstname,student_lastname,student_email,student_phone)
VALUES
('853172974', 'Julia','Cole','j.cole@syr.edu','143340944'),
('652798129','Abigail','Myers','a.myers@syr.edu','507406127'),
('552042379','Sydney','Carter','s.carter@syr.edu','162943124'),
('607922354','Kevin','Ferguson','k.ferguson@syr.edu','242597966'),
('898460173','Victor','Clark','v.clark@syr.edu','78619793'),
('265483206','Thomas','Reed','t.reed@syr.edu','522911216'),
('216284050','Alexia','Gray','a.gray@syr.edu','528447137'),
('916023487','Savana','Perry','s.perry@syr.edu','871075893'),
('340875532','George','Adams','g.adams@syr.edu','282098794'),
('383188646','Marcus','Foster','m.foster@syr.edu','520570509'),
('235381214','Alfred','Cameron','a.cameron@syr.edu','520714043'),
('437330307','Paul','Casey','p.casey@syr.edu','962221184'),
('931990902','Steven','Murphy','s.murphy@syr.edu','239383278'),
('197377259','Charlie','Morrison','c.morrison@syr.edu','479625338'),
('135348345','Alen','Elliott','a.elliott@syr.edu','146703900'),
('112593365','Charlotte','Russell','c.russell@syr.edu','78226191'),
('237456742','Spike','Wells','s.wells@syr.edu','244754236'),
('741179473','Freddie','Gray','f.gray@syr.edu','614625543'),
('156981800','Maria','Tucker','m.tucker@syr.edu','552908553'),
('565879442','Oscar','Barrett','o.barrett@syr.edu','502428810'),
('822555053','Walter','Barnes','w.barnes@syr.edu','598949582'),
('582831912','Amber','Anderson','a.anderson@syr.edu','35912304'),
('236214147','Valeria','Jones','v.jones@syr.edu','878151442'),
('274010105','Marcus','Gibson','m.gibson@syr.edu','664631205'),
('309736488','Thomas','Moore','t.moore@syr.edu','48777675'),
('892418004','Arianna','Bailey','a.bailey@syr.edu','52856398'),
('607501110','Cadie','Johnston','c.johnston@syr.edu','967100673'),
('534432480','Tony','Morgan','t.morgan@syr.edu','329715136'),
('503168455','Eddy','West','e.west@syr.edu','768267326'),
('249161056','Caroline','Hill','c.hill@syr.edu','305769569'),
('670316151','Preston','Elliott','p.elliott@syr.edu','412367764'),
('983941176','Briony','Ellis','b.ellis@syr.edu','234402956'),
('577728492','Cadie','Harper','c.harper@syr.edu','277281171'),
('252355493','Madaline','Campbell','m.campbell@syr.edu','702945534'),
('720655212','Brad','Armstrong','b.armstrong@syr.edu','754994112'),
('295834111','Mary','Edwards','m.edwards@syr.edu','509046597'),
('158034616','Edith','Howard','e.howard@syr.edu','491014107'),
('265426220','Arianna','Miller','a.miller@syr.edu','226344179'),
('273392617','Ryan','Wells','r.wells@syr.edu','588112306'),
('876514502', 'Freddie','Campbell','f.campbell@syr.edu','857417583')

insert into Leasing_details
(lease_startdate,lease_enddate,lease_unitid,lease_security_deposit, lease_student_id)
VALUES
--Expired lease
('2019-09-01', '2020-09-01',8,600,5),
('2018-09-01', '2019-09-01',2,600,2),
('2019-09-01', '2020-09-01',1,600,9),
('2019-09-01', '2021-09-01',16,600,11),
--On going
('2021-09-01', '2022-09-01',19,600,15),
('2021-02-01', '2022-02-01',32,600,19),
('2020-09-01', '2022-09-01',5,600,32),
('2021-09-01', '2022-09-01',17,600,39)

insert into Enquiries
(Enquiry_Date)
VALUES
('2017-06-06'),
('2018-09-06'),
('2017-12-06'),
('2018-06-07'),
('2017-07-06'),
('2018-06-08')

insert into Units_Enquiries
(Unit_ID,Enquiry_ID,Enquiry_FirstName, Enquiry_LastName,Enquiry_EmailID,Enquiry_Comments)
VALUES
(1,1,'Matt', 'Demona','c.johnson@syr.edu','How spacious is this room?'),
(7,2,'Rohit', 'Upadhyay','a.turner@syr.edu','East facinng room?'),
(9,3,'Drishti', 'Kwatra','m.ellis@syr.edu','West facinbg room?'),
(18,4,'Sanika', 'Hadatgune','r.richardson@syr.edu','What is the flooring like'),
(23,5,'Clark', 'Davis','a.richardson@syr.edu','How far is it fron the university'),
(27,6,'Adison', 'Rose','o.taylor@syr.edu','Do we get study table and a chair')

--VERIFY
SELECT * from Owners
SELECT * from Tower_Details
SELECT * from Wings
SELECT * from Tower_Wings
SELECT * from Floors
SELECT * from Units
SELECT * from Students
SELECT * from Leasing_details
SELECT * from Enquiries
SELECT * from Units_Enquiries