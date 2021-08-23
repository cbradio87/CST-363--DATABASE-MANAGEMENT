-- e5.1 Exercises from chapter 5
--
-- Before you begin:
-- re-create the tables and data using the script 
--   zagimore_schema.sql

-- 1  Display the RegionID, RegionName and number of stores in each region.
-- select Code as RegionID, Name as RegionName, count(*) as number_of_stores
-- from country
-- group by Region;

-- 2 Display CategoryID and average price of products in that category.
select categoryid, avg(productprice) as price from product
group by categoryid;

-- 3 Display CategoryID and number of items purchased in that category.
select categoryid, count(*) as number_of_items_purchased
from product
group by categoryid;

-- 4 Display RegionID, RegionName and total amount of sales as AmountSpent

select store.regionid, region.regionname, sum(includes.quantity * product.productprice) as AmountSpent
from product
inner join includes on includes.productid = product.productid
inner join salestransaction on salestransaction.tid = includes.tid
inner join store on store.storeid = salestransaction.storeid
inner join region on region.regionid = store.regionid
group by regionname;

-- 5 Display the TID and total number of items in the sale
--    for all sales where the total number of items is greater than 3
select includes.tid, includes.quantity
from product
inner join includes on includes.productid = product.productid
inner join salestransaction on salestransaction.tid = includes.tid
inner join store on store.storeid = salestransaction.storeid
inner join region on region.regionid = store.regionid
where includes.quantity > 3;

-- 6 For vendor whose product sales exceeds $700, display the
--    VendorID, VendorName and total amount of sales as "TotalSales"
select vendor.vendorid, vendor.vendorname, sum(includes.quantity * product.productprice) as TotalSales
from product
inner join includes on includes.productid = product.productid
inner join salestransaction on salestransaction.tid = includes.tid
inner join store on store.storeid = salestransaction.storeid
inner join region on region.regionid = store.regionid
inner join vendor on vendor.vendorid = product.vendorid
group by vendor.vendorid;

-- 7 Display the ProductID, Productname and ProductPrice
--    of the cheapest product.
select product.ProductID, product.ProductName, min(product.ProductPrice) as CheapestProduct
from product
inner join includes on includes.productid = product.productid
inner join salestransaction on salestransaction.tid = includes.tid
inner join store on store.storeid = salestransaction.storeid
inner join region on region.regionid = store.regionid
inner join vendor on vendor.vendorid = product.vendorid;

-- 8 Display the ProductID, Productname and VendorName
--    for products whose price is below average price of all products
--    sorted by productid.
select product.ProductID, product.ProductName, vendor.VendorName
from product
inner join includes on includes.productid = product.productid
inner join salestransaction on salestransaction.tid = includes.tid
inner join store on store.storeid = salestransaction.storeid
inner join region on region.regionid = store.regionid
inner join vendor on vendor.vendorid = product.vendorid
where product.ProductPrice < (select avg(product.ProductPrice) from product)
order by product.productid;

-- 9 Display the ProductID and Productname from products that
--    have sold more than 2 (total quantity).  Sort by ProductID
select product.ProductID, product.ProductName
from product
inner join includes on includes.productid = product.productid
inner join salestransaction on salestransaction.tid = includes.tid
inner join store on store.storeid = salestransaction.storeid
inner join region on region.regionid = store.regionid
inner join vendor on vendor.vendorid = product.vendorid
where includes.quantity > 2
order by product.productid;

-- 10 Display the ProductID for the product that has been 
--    sold the most (highest total quantity across all
--    transactions). 
select product.ProductID, sum(includes.quantity) *includes.quantity as Highest_Quantity
from product
inner join includes on includes.productid = product.productid
inner join salestransaction on salestransaction.tid = includes.tid
inner join store on store.storeid = salestransaction.storeid
inner join region on region.regionid = store.regionid
inner join vendor on vendor.vendorid = product.vendorid
group by product.ProductID
order by Highest_Quantity desc limit 0,1;



-- 11 Rewrite query 30 in chapter 5 using a join.
SELECT product.productid, productname, productprice
FROM product
inner join includes on includes.productid = product.productid
group by productid
Having sum(includes.quantity) > 3
order by productid;

-- 12 Rewrite query 31 using a join.
SELECT product.productid, productname, productprice
FROM product
inner join includes on includes.productid = product.productid
GROUP BY productid
HAVING count(includes.tid) > 1;

-- 13 create a view over the product, salestransaction, includes, customer, store, region tables
--     with columns: tdate, productid, productname, productprice, quantity, customerid, customername, 
--                   storeid, storezip, regionname
create view over_multiple_tables as
select tdate, product.productid, productname, productprice, quantity, salestransaction.customerid, customername, store.storeid, storezip, regionname
from product
inner join includes on includes.productid = product.productid
inner join salestransaction on salestransaction.tid = includes.tid
inner join store on store.storeid = salestransaction.storeid
inner join region on region.regionid = store.regionid
inner join customer on customer.customerid = salestransaction.customerid;

-- 14 Using the view created in question 13
--   Display ProductID, ProductName, ProductPrice  
--   for products sold in zip code "60600" sorted by ProductID
select ProductID, ProductName, ProductPrice
from over_multiple_tables
where over_multiple_tables.storezip = '60600'
order by productid;

-- 15 Using the view from question 13 
--    display CustomerName and TDate for any customer buying a product "Easy Boot"
select Customername, TDate
from over_multiple_tables
where over_multiple_tables.productname = 'Easy Boot';

-- 16 Using the view from question 13
--    display RegionName and total amount of sales in each region as "AmountSpent"
select RegionName, sum(ProductPrice * Quantity) as Amount_Spent
from over_multiple_tables
group by RegionName;

-- 17 Display the product ID and name for products whose 
--    total sales is less than 3 or total transactions is at most 1.
--    Use a UNION. 
select product.productid, productname, quantity, includes.tid
from product
inner join includes on includes.productid = product.productid
inner join salestransaction on salestransaction.tid = includes.tid
inner join store on store.storeid = salestransaction.storeid
inner join region on region.regionid = store.regionid
inner join customer on customer.customerid = salestransaction.customerid
having quantity < 3
and sum(includes.tid) < 2;

-- 18 Create a view named category_region 
--    over the category, region, store, salestranaction, includes,
--    and product tables that summarizes sales by region and category.  The view 
--    should have columns:
--    categoryid, categoryname, regionid, regionname, totalsales
create view category_region as
select product.categoryid, categoryname, store.regionid, regionname, sum(quantity) as totalsales
from product
inner join includes on includes.productid = product.productid
inner join salestransaction on salestransaction.tid = includes.tid
inner join store on store.storeid = salestransaction.storeid
inner join region on region.regionid = store.regionid
inner join category on category.categoryid = product.categoryid
group by categoryname, regionname;


-- 19 Using the view created in 18, which region has the most sales in 
--    each category.
--    you should get the result
--    categoryname regionname    totalsales
--    Electronics  Chicagoland   6
--    Cycling      Chicagoland   13
--    Climbing     Indiana       17
--    Camping      Tristate      9
--    Footwear     Tristate      20

select categoryname, regionname, totalsales
from category_region
where totalsales in (select max(totalsales) from category_region group by categoryname)
group by categoryname, regionname
order by regionname;
