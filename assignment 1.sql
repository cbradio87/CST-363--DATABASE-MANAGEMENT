-- e5.1 Exercises from chapter 5
--
-- Before you begin:
-- create the tables and data using the script 
--   zagimore_schema.sql
--
-- 1  Display all records in the REGION table
select regionid from region;
select * from region;
select regionid, regionname from region;

-- 2 Display StoreID and StoreZIP for all stores
 select storeid from store;
 select * from store;
 select storeid, storezip from store;

-- 3 Display CustomerName and CustomerZip for all customers
--   sorted alphabetically by CustomerName
 select customerid from customer;
 select * from customer;
 select customername, customerzip from customer
 order by customername asc;

-- 4 Display the RegionIDs where we have stores 
--   and do not display duplicates
select regionid from store;
select * from store;
select distinct regionid from store;

-- 5 Display all information for all stores in RegionID C 
select storeid from store;
select * from store;
select storeid, storezip, regionid from store where regionid = 'C';

-- 6 Display CustomerID and CustomerName for customers who name 
--   begins with the letter T
select customerid from customer;
select * from customer;
select customerid, customername from customer
where customername like 'T%'
order by customername;

-- 7 Display ProductID, ProductName and ProductPrice for 
--   products with a price of $100 or higher
select productid from product;
select * from product;
select productid, productname, productprice from product where productprice > 100;

-- 8 Display ProductID, ProductName, ProductPrice and VendorName
--   for products sorted by ProductID
select productid from product;
select * from product;
select productid, productname, productprice, vendorname from product, vendor
where product.vendorid =vendor.vendorid
order by productid asc;

-- 9 Display ProductID, ProductName, ProductPrice,  VendorName and CategoryName
--   for products.  Sort by ProductID
select productid, productname, productprice, vendorname, categoryname from product, vendor, category
where product.vendorid =vendor.vendorid AND product.categoryid = category.categoryid
order by productid asc;


-- 10 Display ProductID, ProductName, ProductPrice  
--   for products in category "Camping" sorted by ProductID
select productid, productname, productprice from product, category
where product.categoryid = category.categoryid AND category.categoryname = 'Camping'
order by productid asc;

-- 11 Display ProductID, ProductName, ProductPrice  
--   for products sold in zip code "60600" sorted by ProductID
select productid, productname, productprice from product, store
where store.storezip = 60600
order by productid asc;

-- 12 Display ProductID, ProductName and ProductPrice for VendorName "Pacifica Gear" and were
--    sold in the region "Tristate".  Do not show duplicate information.
select distinct productid, productname, productprice from product, vendor, region
where vendor.vendorname = 'Pacifica Gear' AND region.regionid = 'T'
order by productid asc;

-- 13 Display TID, CustomerName and TDate for any customer buying a product "Easy Boot"
--    Sorted by TID.
select tid, customername, tdate from salestransaction, product, customer
where product.productname = 'Easy Boot' AND  customer.customerid =salestransaction.customerid 
order by tid asc;


-- 14 Create table and insert the following data

-- create table company with columns
--    companyid char(3), name varchar(50), ceo varchar(50)
--    make column companyid the primary key

 create table company
 (companyid char(3),
 	name varchar(50),
     ceo varchar(50),
     primary key (companyid));

-- insert the following data 
--    companyid   name          ceo
--    ACF         Acme Finance  Mike Dempsey
--    TCA         Tara Capital  Ava Newton
--    ALB         Albritton     Lena Dollar
insert into company(companyid, name, ceo)
values ('ACF', 'Acme Finance', 'Mike Dempsey'),
		('TCA', 'Tara Capital', 'Ava Newton'),
        ('ALB', 'Albritton', 'Leria Dollar');

-- create a table security with columns
--     secid, name, type
--     secid should be the primary key
create table security

	(secid char(2),
 	name varchar(50),
     type varchar(50),
	PRIMARY KEY (secid));
    


-- insert the following data
--    secid    name                type
--    AE       Abhi Engineering    Stock
--    BH       Blues Health        Stock
--    CM       County Municipality Bond
--    DU       Downtown Utlity     Bond
--    EM       Emmitt Machines     Stock
insert into security(secid, name, type)
values ('AE', 'Abji Engineering', 'Stock'),
		('BH', 'Blues Health', 'Stock'),
        ('CM', 'Country Municipality', 'Bond'),
        ('DU', 'Emmitt Machines', 'Stock'),
        ('EM', 'Emitt Machines', 'Stock');

-- create the following table called fund 
--  with columns companyid, inceptiondate, fundid, name
--   fundid should be the primary key
--   companyid should be a foreign key referring to the company table.
create table fund

	(CompanyID char(3),
 	InceptionDate varchar(12),
     FundID char(2),
     Name varchar(50),
	PRIMARY KEY (FundID));


-- CompanyID  InceptionDate   FundID Name
--    ACF      2005-01-01     BG     Big Growth
--    ACF      2006-01-01     SG     Steady Growth
--    TCA      2005-01-01     LF     Tiger Fund
--    TCA      2006-01-01     OF     Owl Fund
--    ALB      2005-01-01     JU     Jupiter
--    ALB      2006-01-01     SA     Saturn
insert into fund(CompanyID, InceptionDate, FundID, Name)
values('ACF', '2005-01-01', 'BG', 'Big Growth'),
		('ACF', '2006-01-01', 'SG', 'Steady Growth'),
        ('TCA', '2005-01-01', 'LF', 'Tiger Fund'),
        ('TCA', '2006-01-01', 'OF', 'Owl Fund'),
        ('ALB', '2005-01-01', 'JU', 'Jupiter'),
        ('ALB', '2006-01-01', 'SA', 'Saturn');

-- create table holdings with columns
--   fundid, secid, quantity
--   make (fundid, secid) the primary key
--   fundid is also a foreign key referring to the fund  table
--   secid is also a foreign key referring to the security table
create table holdings

	(FundID char(2),
     secid char(2),
     quantity int,
	PRIMARY KEY (FundID, secid));

--    fundid   secid    quantity
--     BG       AE           500
--     BG       EM           300
--     SG       AE           300
--     SG       DU           300
--     LF       EM          1000
--     LF       BH          1000
--     OF       CM          1000
--     OF       DU          1000
--     JU       EM          2000
--     JU       DU          1000
--     SA       EM          1000
--     SA       DU          2000
insert into holdings(FundID, secid, quantity)
values('BG', 'AE', '500'),
		('BG', 'EM', '300'),
        ('SG', 'AE', '300'),
        ('SG', 'DU', '300'),
        ('LF', 'EM', '1000'),
        ('LF', 'BH', '1000'),
        ('OF', 'CM', '1000'),
        ('OF', 'DU', '1000'),
        ('JU', 'EM', '2000'),
        ('JU', 'DU', '1000'),
        ('SA', 'EM', '1000'),
        ('SA', 'DU', '2000');
        

-- 15 Use alter table command to add a column "price" to the 
--    security table.  The datatype should be numeric(7,2)
 alter table security ADD (price float);

-- 16 drop tables company, security, fund, holdings.
--    You must drop them in a certain order.
drop table holdings;
drop table fund;
drop table security;
drop table company;


-- 17 Try to delete the row for product with productid '5X1'
-- delete from product where productid = '5x1';

-- 18 Explain why does the delete in question 17 fails.
-- the delete in question 17 fails because it produces the error message
-- "Error Code: 1451. Cannot delete or update a parent row: a foreign key
-- contstraint fails. This error occurs when there is a child table
-- you must delete from the child table before deleting from the parent table.

-- 19 Try to delete the row for product with productid '5X2'
delete from product where productid = '5x2';

-- 20 Re-insert productid '5X2'
insert into product values('5X2', 'Action Sandal', 70.00, 'PG', 'FW');

-- 21  update the price of '5X2', 'Action Sandal' by $10.00
update product
set
	productprice = '80.00'
where
	productid = '5x2';

-- 22 increase the price of all products in the 'CY' category by 5%
update product
set
	productprice = productprice * 1.05
where
	categoryid = 'CY';

-- 23 decrease the price of all products made by vendorname 'Pacifica Gear' by $5.00
update product
JOIN vendor
       ON product.vendorid = vendor.vendorid
set
	productprice = productprice - 5
where
	vendorname = 'Pacifica Gear';

-- 24 List productid and productprice for all products.  Sort by productid;
select productid from product;
 select * from product;
 select productid, productprice from product
 order by productid asc;