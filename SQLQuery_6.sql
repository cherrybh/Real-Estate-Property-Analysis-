--DOWN
DROP table if EXISTS Properties
IF EXISTS(select* from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME='fk_Properties_city')
    alter table Properties DROP CONSTRAINT fk_Properties_city
 
IF EXISTS(select* from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME='fk_Properties_property_owner_id')
    alter table Properties DROP CONSTRAINT fk_Properties_property_owner_id
 
DROP table if EXISTS City
DROP table if EXISTS Transactions
IF EXISTS(select* from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME='fk_Transactions_customer_id ')
    alter table Transactions DROP CONSTRAINT fk_Transactions_customer_id
 
 
 
 
drop table if exists Customers
drop table if exists Owners
drop table if exists Rent
IF EXISTS(select* from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME='fk_rent_property_id')
    alter table Properties DROP CONSTRAINT fk_rent_property_id
 
DROP TABLE if EXISTS Review
IF EXISTS(select* from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME='fk_Review_customer_id')
    alter table Transactions DROP CONSTRAINT fk_Review_customer_id
 
 
 
GO
 
 
--UP METADATA
 
CREATE TABLE City(
    city_name VARCHAR(50) not null,
    CONSTRAINT pk_City_city_name PRIMARY KEY(city_name)
    
)
 
 
 
create table Owners (
  owner_id int not null,
  owner_firstname varchar(50) not null,
  owner_lastname varchar(50) not null,
  owner_email_id varchar(50) not null,
  owner_contact_number int not null,
  constraint pk_owners_owner_id primary key (owner_id),
  constraint u_owners_owner_email_id unique (owner_email_id)
)
 
 
 
 
 
CREATE TABLE Properties(
property_id INT not NULL,
property_size INT NOT NULL,
prop_location VARCHAR(50) NOT NULL ,
prop_status VARCHAR(50) NOT NULL,
Avaiability DATE NOT NULL,
zip_code varchar(50) NOT NULL,
nearby_landmark VARCHAR(50) NOT NULL,
property_owner_id int NOT NULL,
property_type VARCHAR(50) NOT NULL,
city VARCHAR(50) NOT NULL,
no_rooms INT NOT NULL,
CONSTRAINT pk_Properties_property_id PRIMARY KEY(property_id),
CONSTRAINT fk_Properties_city FOREIGN KEY(city) REFERENCES City(city_name) 
 
 
)
 
ALTER table Properties
ADD CONSTRAINT fk_Properties_property_owner_id FOREIGN KEY(property_owner_id)
REFERENCES Owners(owner_id)
 
 
 
create table Customers (
    customer_id int not null,
    customer_first_name varchar (50) not null,
    customer_last_name varchar(50) not null,
    customer_email varchar (50) not null,
    customer_contact_no int not null,
    customer_type varchar (50) not null,
    customer_min_price int not null,
    customer_max_price int not null,
    constraint pk_customers_customer_id primary key (customer_id),
    constraint u_customer_email unique (customer_email))
 
 
 
CREATE TABLE Transactions(
    transaction_id int not NULL,
    customer_id int not NULL,
    payment_type varchar(50) not NULL,
    owner_id varchar(50) not NULL,
 
    CONSTRAINT pk_Transactions_transaction_id PRIMARY KEY(transaction_id),
 
    CONSTRAINT fk_Transactions_customer_id FOREIGN KEY(customer_id)
    REFERENCES Customers(customer_id)
   
 
)
 
 
 
 
 
 
 
 
 
 
create table Rent (
rent_amount int not null,
property_id int not null,
rent_id int not null,
constraint pk_rent_rent_id primary key (rent_id),
CONSTRAINT fk_rent_property_id FOREIGN KEY(property_id)
REFERENCES Properties(property_id)
)
 
 
 
 
CREATE TABLE Review(
    review_id int not NULL,
    property_review int Not NULL,
    customer_id int not NULL,
 
    CONSTRAINT pk_Review_review_id PRIMARY KEY(review_id),
    CONSTRAINT fk_Review_customer_id FOREIGN KEY(customer_id)
    REFERENCES Customers(customer_id)
)
 
GO
 
 
 
 
 
 
 
 
 
INSERT INTO City 
(city_name)
VALUES
('Syracuse'),
('Rochester'),
('Utica')
 
 
 
insert into Owners
(owner_id, owner_firstname, owner_lastname,owner_email_id, owner_contact_number)
values
(91,'Naruto', 'Uzumaki', 'naruto.uzumaki@gmail.com', 223344),
(92,'Eren', 'Yeger', 'eren.yegar@gmail.com', 443311),
(93,'Peter', 'Pan', 'peter.pan@gmail.com', 54678),
(94,'Alice', 'Wonderland', 'alice.wonderland@gmail.com', 66677),
(95,'Dani', 'Carvajal', 'dani.carvajal@gmail.com', 435111),   
(96,'Leo', 'Messi', 'leo.messi@gmail.com', 111222),
(97,'Tom', 'Cruise', 'tom.cruise@gmail.com', 889912),
(98,'Sergio', 'Perez', 'sergio.perez@gmail.com',32456),
(99,'Thor', 'Thunder', 'thor.thunder@gmail.com', 542378),
(100,'Harry', 'Potter', 'harry.potter@gmail.com',23100)
 
 
 
 
INSERT INTO Properties 
(property_id,property_size,prop_location, prop_status,Avaiability,zip_code,nearby_landmark, property_owner_id, property_type, city,
no_rooms)
values
(01, 1000, '119 Comstock','Available','2021-05-11',13210,'Walgreens', 91, 'Residential', 'Syracuse',4),
(02, 2000, '115 Ostrom_Ave','Unvailable','2022-05-11',12444,'Walmart', 91, 'Commercial', 'Utica',6),
(03, 3000, '110 Euclid','Available','2020-03-11',13215,'Walgreens', 92, 'Residential', 'Rochester',4),
(04, 2000, '123 Lancaster','Available','2021-05-11',10210,'Walgreens', 92, 'Residential', 'Syracuse',2),
(05, 4000, '117 Westcott','Available','2022-05-11',16710,'Pricerite', 92, 'Residential', 'Rochester',5),
(06, 1000, '121 Maryland','Available','2020-05-11',23410,'Walmart', 93, 'Industrial', 'Syracuse',6),
(07, 1000, '109 Harrison','Unvailable','2021-05-11',78990,'Walgreens', 93, 'Industrial', 'Syracuse',3),
(08, 3000, '103 Madison','Available','2022-05-11',17210,'Pricerite', 94, 'Commercial', 'Syracuse',2),
(09, 4000, '167 Waverly','Available','2020-05-11',63210,'University', 94, 'Residential', 'Utica',5),
(10, 2000, '100 University_Ave','Available','2021-05-11',897210,'University', 91, 'Commercial', 'Utica',3)
 
 
 
insert into Customers
(customer_id , customer_first_name , customer_last_name,  customer_email, customer_contact_no,
    customer_type, customer_min_price, customer_max_price )
values
(21 , 'Charles', 'Leclerc', 'robin.hood@gmail.com', 435678,'Contractor', 2000, 3000),
(22 , 'Oswald', 'Lesly', 'oswald.lesly@gmail.com', 678945,'Student', 2500, 4000),
(23 , 'Henry', 'Owens', 'hen.ow@gmail.com', 367890,'Family', 3500, 5000),
(24 , 'Tony', 'Stark', 'starkindustries@gmail.com', 768903,'Contractor',4000, 5000),    
(25 , 'Bruce', 'Banner', 'bruce.banner@gmail.com', 321897,'Contractor', 2200, 3500),  
(26 , 'Phoebe', 'Buffey', 'phoebe.buffey@gmail.com', 567891,'Family', 2200, 3500), 
(28 , 'Ross', 'Geller', 'ross.geller@gmail.com', 12345,'Student', 1000, 2500),
(29 , 'Rachel', 'Green', 'rachel.green@gmail.com', 345678,'Student', 1200, 2600),
(30 , 'Monica', 'Bingler', 'monica.bingler@gmail.com', 210987,'Family', 3500, 5000),
(31 , 'Max','Verstappen', 'max.verstappen@gmail.com', 678432,'Contractor',2300, 4500)
 
 
 
INSERT INTO Transactions
(transaction_id,customer_id,payment_type,owner_id)
VALUES
(700,21,'cash',91),
(710,21,'digital',91),
(720,21,'digital',91),
(730,22,'cash',92),
(740,22,'cash',92),
(750,22,'cash',93),
(760,23,'digital',93),
(770,23,'digital',92),
(780,23,'digital',92),
(790,21,'cash',94)
 
 
 
INSERT INTO Review
(review_id,property_review,customer_id)
VALUES
(501,2,21),
(502,1,21),
(503,4,21),
(504,4,22),
(505,4,22),
(506,4,22),
(507,5,23),
(508,1,23),
(509,3,23),
(510,2,21)
 
 
 
 
 
 
 
 
 
 
 
 
 
insert into Rent
(property_id,rent_amount, rent_id )
values
(1,2100,801),
(2,2400,802),
(3,4300,803),
(4,5000,804),
(5,1500,805),
(6,3200,806),
(7,3200,807),
(8,5000,808),
(9,4300,809),
(10,1900,810)
 
GO
 
/*select rank() over(PARTITION BY customer_id ORDER BY transaction_id) AS rank,customer_id, transaction_id
from Transactions*/
 
 
/*1. To find repeated customers */
SELECT customer_id, count(*) AS total_count 
FROM Transactions 
group BY customer_id
 
/*2. Repeated owners i.e more than one house leased*/
SELECT owner_id, count(*) AS total_count 
FROM Transactions 
group BY owner_id
having count(*)>1
 
 
 
/*3 Categorizing the ratings --- Can say students are happy with the houses and in general contractors are not*/
with rating_query AS(
Select *,
CASE
WHEN property_review>3 THEN 'Good_Rating'
WHEN property_review<3 THEN 'Poor_Rating'
ELSE 'Average'
END AS Ratings
FROM review
)
 
SELECT customer_first_name + ' ' + customer_last_name as Full_Names,property_review,Ratings,customer_type
from rating_query r JOIN Customers c
on r.customer_id=c.customer_id
order by customer_type
 
 
 
/*4 Ratings and nearby landmark- Cannot say anything*/
with rating_query AS(
Select *,
CASE
WHEN property_review>3 THEN 'Good_Rating'
WHEN property_review<3 THEN 'Poor_Rating'
ELSE 'Average'
END AS Ratings
FROM review
)
 
SELECT nearby_landmark,Ratings
from rating_query r JOIN Customers c
on r.customer_id=c.customer_id
JOIN Transactions t 
on c.customer_id = t.customer_id
JOIN Owners o 
on o.owner_id=t.owner_id
JOIN Properties p 
ON o.owner_id=p.property_owner_id
GROUP BY nearby_landmark,Ratings
ORDER by nearby_landmark
 
 
 
/*5 Window functions check for expenditure for each customer type* Inference Family customer types seem to have a higher range of 
min and max pay of pay while students seem to have a lower range*/
with delta_query AS(
select customer_first_name + ' ' + customer_last_name as Full_Name,customer_type,customer_min_price,customer_max_price,
avg(customer_min_price) OVER(PARTITION BY customer_type) AS average_customer_min_price_by_cust_type,
avg(customer_min_price) OVER() AS average_overall_min_price,
avg(customer_max_price) OVER(PARTITION BY customer_type) AS average_customer_max_price_by_cust_type,
avg(customer_max_price) OVER() AS average_overall_max_price
FROM Customers
 
 
)
 
SELECT *,average_customer_min_price_by_cust_type-average_overall_min_price AS delta_min_price,
average_customer_max_price_by_cust_type-average_overall_max_price AS delta_max_price
FROM delta_query
 
/*6 Check for availability of property*/
select * from properties
where prop_status ='Available'
 
/*7 Using ranking to rank properties by size and no_of rooms*/
select property_size,property_type,no_rooms,
rank() OVER(partition by property_type order by property_size) AS Ranking_By_Size,
percent_rank() OVER(partition by property_type order by property_size) AS Percent_Ranking_By_Size,
rank() OVER(partition by property_type order by no_rooms) AS Ranking_By_Rooms,
percent_rank() OVER(partition by property_type order by no_rooms) AS Percent_Ranking_By_Rooms
from Properties
Order BY property_type
 
/*8 Pivoting for years i.e to check the average rent amount for each year as per property type Inference- In year 2020 and 2021 Residential properties
have the highest average rent while in 2022 Commercial properties have the highest average rent which shows 
a shift in trend that rent in commercial properties are on the rise.
*/
With pivot_source as (
Select p.property_type,r.rent_amount,left(cast(Avaiability as varchar),4) AS Year
FROM Properties p
JOIN Rent r on p.property_id=r.property_id
)
 
Select * FROM pivot_source PIVOT(
    avg(rent_amount) FOR Year IN([2020],[2021],[2022])
) AS pivot_table
 
/*9 Trigger* Changed owner first name and can sse inserted and deleted tables to see current and previous change*/
 
Drop TRIGGER if EXISTS t_trig
GO
 
Create trigger t_trig
ON owners
after insert, update, delete
as BEGIN
    select 'INSERTED', * from inserted
    select 'DELETED', * from deleted
END
 
update owners set owner_firstname ='Nezuko' where owner_id=91
update owners set owner_lastname ='Kamado' where owner_id=91
 
select * from owners
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
GO
