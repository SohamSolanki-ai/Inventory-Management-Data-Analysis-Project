
-- CREATE TABLES

--  Customer Table
CREATE TABLE customer (
    customerid INT PRIMARY KEY,
    customername VARCHAR(255),
    customeremail VARCHAR(255),
    customerphone VARCHAR(20),
    customeraddress VARCHAR(255),
    customercreditlimit DECIMAL(10,2)
);

-- Orders Table (References Customer)
CREATE TABLE orders (
    orderid INT PRIMARY KEY,
    orderdate DATE,
    customerid INT REFERENCES customer(customerid) ON DELETE CASCADE
);

--  Product Table
CREATE TABLE product (
    productid VARCHAR(10) PRIMARY KEY,
    productname VARCHAR(255),
    categoryname VARCHAR(100),
    productdescription TEXT,
    productstandardcost DECIMAL(10,2),
    productlistprice DECIMAL(10,2),
    profit DECIMAL(10,2)
);

-- OrderDetails Table (References Orders & Product)
CREATE TABLE orderdetails (
    orderdetailsid INT PRIMARY KEY,
    productid VARCHAR(10) REFERENCES product(productid),
    orderid INT REFERENCES orders(orderid) ON DELETE CASCADE,
    orderitemquantity INT,
    perunitprice DECIMAL(10,2),
    orderstatus VARCHAR(50)
);

-- Warehouse Table
CREATE TABLE warehouse (
    warehouseid INT PRIMARY KEY,
    warehousename VARCHAR(255),
    warehouseaddress VARCHAR(255),
    regionid INT
);

--  Region Table
CREATE TABLE region (
    regionid INT PRIMARY KEY,
    regionname VARCHAR(255),
    countryname VARCHAR(255),
    state VARCHAR(255),
    city VARCHAR(255),
    postalcode VARCHAR(10)
);

--  Employee Table (References Warehouse)
CREATE TABLE employee (
    employeeid INT PRIMARY KEY,
    employeename VARCHAR(255),
    employeeemail VARCHAR(255),
    employeephone VARCHAR(20),
    employeehiredate DATE,
    employeejobtitle VARCHAR(255),
    warehouseid INT REFERENCES warehouse(warehouseid)
);

 CHECK TABLE STRUCTURE & COLUMN NAMES

-- List all tables in the database
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public';

-- List all columns in the Product table
SELECT column_name 
FROM information_schema.columns 
WHERE table_name = 'product';



-- STEP 4: DATA ANALYSIS QUERIES


--  Find Total Number of Orders
SELECT COUNT(*) AS total_orders FROM orders;

--  Find the Top 5 Best-Selling Products
SELECT p.productname, SUM(o.orderitemquantity) AS total_sales
FROM orderdetails o
JOIN product p ON o.productid = p.productid
GROUP BY p.productname
ORDER BY total_sales DESC
LIMIT 5;

--  Find Total Revenue for Each Product
SELECT p.productname, SUM(o.orderitemquantity * o.perunitprice) AS total_revenue
FROM orderdetails o
JOIN product p ON o.productid = p.productid
GROUP BY p.productname
ORDER BY total_revenue DESC;

--  Monthly Sales Trend
SELECT DATE_TRUNC('month', orderdate) AS month, 
       SUM(orderitemquantity * perunitprice) AS monthly_revenue
FROM orders o
JOIN orderdetails od ON o.orderid = od.orderid
GROUP BY month
ORDER BY month;

--  Average Order Value (AOV)
SELECT ROUND(AVG(order_value), 2) AS avg_order_value
FROM (
    SELECT orderid, SUM(orderitemquantity * perunitprice) AS order_value
    FROM orderdetails
    GROUP BY orderid
) AS order_totals;


-- CUSTOMER ANALYSIS QUERIES

--  Top 5 Customers Who Spent the Most
SELECT c.customername, SUM(od.orderitemquantity * od.perunitprice) AS total_spent
FROM orders o
JOIN customer c ON o.customerid = c.customerid
JOIN orderdetails od ON o.orderid = od.orderid
GROUP BY c.customername
ORDER BY total_spent DESC
LIMIT 5;

--  Repeat vs. New Customers
SELECT 
    COUNT(DISTINCT CASE WHEN order_count = 1 THEN customerid END) AS new_customers,
    COUNT(DISTINCT CASE WHEN order_count > 1 THEN customerid END) AS repeat_customers
FROM (
    SELECT customerid, COUNT(orderid) AS order_count
    FROM orders
    GROUP BY customerid
) AS customer_orders;

--  Cancelled vs. Shipped Orders
SELECT orderstatus, COUNT(*) AS total_orders
FROM orderdetails
GROUP BY orderstatus;

-- EMPLOYEE & WAREHOUSE PERFORMANCE QUERIES

-- Top Employees by Orders Handled
SELECT e.employeename, COUNT(o.orderid) AS orders_handled
FROM employee e
JOIN orders o ON e.warehouseid = (SELECT warehouseid FROM warehouse LIMIT 1)
GROUP BY e.employeename
ORDER BY orders_handled DESC
LIMIT 5;

--  Employee Workload Distribution
SELECT e.employeejobtitle, COUNT(o.orderid) AS total_orders
FROM employee e
JOIN orders o ON e.warehouseid = (SELECT warehouseid FROM warehouse LIMIT 1)
GROUP BY e.employeejobtitle
ORDER BY total_orders DESC;

