-- 1) Get the firstname and lastname of the employees who placed orders between 15th August,1996 and 15th August,1997
SELECT e.first_name, e.last_name
FROM Employee e
JOIN Orders o
ON e.id = o.EmployeeId
WHERE o.OrderDate BETWEEN '1996-08-15' AND '1997-08-15';

-- 2) Get the distinct EmployeeIDs who placed orders before 16th October,1996
SELECT *
FROM Employee e
JOIN Orders o
ON e.id = o.EmployeeId
WHERE o.OrderDate < '1996-10-16'

-- 3) How many products were ordered in total by all employees between 13th of January,1997 and 16th of April,1997.
SELECT COUNT(*) AS [No.of Products]
FROM Orders o
JOIN OrderDetails od
ON o.OrderId = od.OrderId
WHERE o.OrderDate BETWEEN '1997-01-13' AND '1997-04-16'

-- 4) What is the total quantity of products for which Anne Dodsworth placed orders between 13th of January,1997 and 16th of April,1997
SELECT SUM(od.Quantity) AS Quantity
FROM Orders o
JOIN Employee e
ON o.EmployeeId = e.id
JOIN OrderDetails od
ON o.OrderId = od.OrderId
WHERE e.first_name = 'Anne' AND e.last_name = 'Dodsworth'

-- 5) How many orders have been placed in total by Robert King
SELECT COUNT(*) As [No.of Orders]
FROM Orders o
JOIN Employee e
ON o.EmployeeId = e.id
WHERE e.first_name = 'Robert' AND e.last_name = 'King'

-- 6)  How many products have been ordered by Robert King between 15th August,1996 and 15th August,1997
SELECT COUNT(*) AS [No.of Products]
FROM Orders o
JOIN Employee e
ON o.EmployeeId = e.id
JOIN OrderDetails od
ON od.OrderId = o.OrderId
Where e.first_name = 'Robert' AND e.last_name = 'King' AND o.OrderDate BETWEEN '1996-08-15' AND '1997-08-15'

-- 7) I want to make a phone call to the employees to wish them on the occasion of Christmas who placed orders between 13th of January,1997 and 16th of April,1997. I want the EmployeeID, Employee Full Name, HomePhone Number.
SELECT DISTINCT e.id,CONCAT(e.first_name, e.last_name) AS [Full Name], HomePhoneNo
FROM Employee e
JOIN Orders o
ON o.EmployeeId = e.id
WHERE o.OrderDate BETWEEN '1997-01-13' AND '1997-04-16'

-- 8) Which product received the most orders. Get the product's ID and Name and number of orders it received.
SELECT TOP 1 p.ProductId, p.ProductName, COUNT(*) AS [No.of orders]
FROM OrderDetails od
JOIN Products p
ON od.ProductId = p.ProductId
GROUP BY p.ProductId, p.ProductName
ORDER BY COUNT(*) DESC

--9) Which are the least shipped products. List only the top 5 from your list
SELECT TOP 5 p.productId, COUNT(*) AS [Least shipped products]
FROM Products p
LEFT JOIN OrderDetails od
ON p.ProductId = od.ProductId
GROUP BY p.ProductId
ORDER BY COUNT(*),p.ProductId

-- 10) What is the total price that is to be paid by Laura Callahan for the order placed on 13th of January,1997
SELECT SUM(p.UnitPrice*od.Quantity) AS [Total Amount]
FROM Employee e
JOIN Orders o
ON e.id = o.EmployeeId
JOIN orderDetails od
ON od.OrderId = o.OrderId
JOIN Products p
ON p.ProductId = od.ProductId
WHERE e.first_name ='Laura' AND e.last_name = 'Callahan' AND o.OrderDate = '1997-01-13'

-- 11) How many number of unique employees placed orders for Gorgonzola Telino or Gnocchi di nonna Alice or Raclette Courdavault or Camembert Pierrot in the month January,1997
SELECT COUNT(DISTINCT o.EmployeeId) as [Unique Employees]
FROM OrderDetails od
JOIN Products p
ON od.ProductId = p.ProductId
JOIN Orders o
ON od.OrderId = o.OrderId
WHERE p.ProductName IN ('Gorgonzola Telino','Gnocchi di nonna Alice','Raclette Courdavault','Camembert Pierrot')

-- 12) What is the full name of the employees who ordered Tofu between 13th of January,1997 and 30th of January,1997
SELECT CONCAT(e.first_name, e.last_name) AS [Full Name]
FROM Employee e
JOIN Orders o
ON e.id = o.EmployeeId
JOIN OrderDetails od
ON o.OrderId = od.OrderId
JOIN Products p
ON p.ProductId = od.ProductId
WHERE p.ProductName = 'Tofu' AND (o.OrderDate BETWEEN '1997-01-13' AND '1997-01-30')

-- 13) What is the age of the employees in days, months and years who placed orders during the month of August. Get employeeID and full name as well
SELECT e.id, CONCAT(e.first_name,' ', e.last_name) AS [Full Name] , DATEDIFF(DAY, e.DateOfBirth, '1998') AS AgeInDays, DATEDIFF(MONTH , e.DateOfBirth, '1998')  AS [Age In Months], DATEDIFF(YEAR, e.DateOfBirth, '1998') AS [Age In Years]
FROM Employee e
JOIN Orders o
ON e.id = o.EmployeeId
WHERE MONTH(o.OrderDate) = 8

-- 14)  Get all the shipper's name and the number of orders they shipped
SELECT shp.CompanyName AS [Shipper Name] , COUNT(*) AS  [No.of Orders Shipped]
FROM Orders o
JOIN Shippers shp
ON o.ShipperId = shp.ShipperId
GROUP BY shp.CompanyName

-- 15)  Get the all shipper's name and the number of products they shipped.
SELECT DIStinct(shp.CompanyName) AS [Shipper Name] , COUNT(DISTINCT od.ProductId) AS [No.of Products Shipped]
FROM Orders o
JOIN Shippers shp
ON o.ShipperId = shp.ShipperId
JOIN OrderDetails od
ON od.OrderId = o.OrderId
GROUP BY shp.CompanyName

-- 16) Which shipper has bagged most orders. Get the shipper's id, name and the number of orders.
SELECT TOP 1 shp.ShipperId , shp.CompanyName , COUNT(*) AS [No.of Orders Shipped]
FROM Orders o
JOIN Shippers shp
ON o.ShipperId = shp.ShipperId
GROUP BY Shp.ShipperId , shp.CompanyName
ORDER BY COUNT(*) DESC

-- 17)  Which shipper supplied the most number of products between 10th August,1996 and 20th September,1998. Get the shipper's name and the number of products
SELECT TOP 1 shp.CompanyName , COUNT(DISTINCT od.ProductId) AS [No.of Products Shipped]
FROM Orders o
JOIN Shippers shp
ON o.ShipperId = shp.ShipperId
JOIN OrderDetails od
ON od.OrderId = o.OrderId
WHERE o.OrderDate BETWEEN '1996-08-10' AND '1998-09-20'
GROUP BY shp.CompanyName
ORDER BY [No.of Products Shipped] DESC

-- 18)  Which employee didn't order any product 4th of April 1997
SELECT e.id, CONCAT(e.first_name, ' ', e.last_name) as [Full Name]
FROM Employee e
LEFT JOIN Orders o
ON e.id = o.EmployeeId AND o.OrderDate = '1997-04-04'
WHERE o.OrderId IS NULL
ORDER BY e.id;

-- 19) How many products where shipped to Steven Buchanan
SELECT COUNT(DISTINCT od.ProductId) AS [No.of Products Shipped to Steven Buchanan]
FROM Employee e
JOIN Orders o
ON e.id = o.EmployeeId
JOIN OrderDetails od
ON od.OrderId = o.OrderId
WHERE e.first_name = 'Steven' AND e.last_name =  'Buchanan'

-- 20) How many orders where shipped to Michael Suyama by Federal Shipping
SELECT COUNT(*) AS [No.of Orders shipped to Michael Suyama by Federal Shipping]
FROM Orders o
JOIN Shippers shp
ON o.ShipperId = shp.ShipperId
JOIN Employee e
ON o.EmployeeId = e.id
WHERE shp.CompanyName = 'Federal Shipping' AND e.first_name = 'Michael' AND e.last_name =  'Suyama'

-- 21)  How many orders are placed for the products supplied from UK and Germany
SELECT COUNT(DISTINCT o.OrderId) AS [No.of Orders Placed for products from UK and Germany]
FROM Orders o
JOIN OrderDetails od
ON o.OrderId = od.OrderId
WHERE od.ProductId IN (    SELECT ProductId
                           FROM Products p
                           JOIN Supplier sup
                           ON p.SupplierId = sup.SupplierId
                           WHERE sup.Address IN ('UK','Germany'))

-- 22)  How much amount Exotic Liquids received due to the order placed for its products in the month of January,1997
SELECT SUM(p.UnitPrice*od.Quantity) AS [Total amount Exotic Liquids received due to the order placed for its products in the month of January,1997]
FROM Orders o
JOIN OrderDetails od
ON o.OrderId = od.OrderId
JOIN Products p
ON p.ProductId = od.ProductId
JOIN Supplier sup
ON sup.SupplierId = p.SupplierId
WHERE sup.CompanyName = 'Exotic Liquids' AND YEAR(o.OrderDate) = 1997AND MONTH(o.OrderDate) = 1;

-- 23)  In which days of January, 1997, the supplier Tokyo Traders haven't received any orders
WITH Numbers AS (
  SELECT 1 AS DayNumber
  UNION ALL
  SELECT DayNumber + 1
  FROM Numbers
  WHERE DayNumber < 31
)

SELECT DayNumber
FROM Numbers
WHERE DayNumber NOT IN (  SELECT DISTINCT DAY(o.OrderDate) AS [Orders placed Days]
                            FROM Orders o
                            JOIN OrderDetails od
                            ON o.OrderId = od.OrderId 
                            WHERE od.ProductId IN (  SELECT p.ProductId
                                                     FROM Products p
                                                     JOIN Supplier sup
                                                     ON p.SupplierId = sup.SupplierId
                                                     WHERE sup.CompanyName = 'Tokyo Traders' )  AND MONTH(o.OrderDate) = 1 AND YEAR(o.OrderDate) = 1997)


-- 24)  Which of the employees did not place any order for the products supplied by Ma Maison in the month of May.
SELECT id ,CONCAT(first_name, last_name) AS [Full Name]
FROM Employee
WHERE id NOT IN ( SELECT DISTINCT e.id
                  FROM Employee e
                  LEFT JOIN Orders o
                  ON e.id = o.EmployeeId
                  LEFT JOIN OrderDetails od
                  ON o.OrderId = od.OrderId
                  WHERE od.ProductID IN (  SELECT p.ProductId
                                           FROM Products p
                                           JOIN Supplier sup
                                           ON p.SupplierId = sup.SupplierId
                                           WHERE sup.CompanyName = 'Ma Maison') AND MONTH(o.orderDate) = 5 )

-- 25) Which shipper shipped the least number of products for the month of September and October,1997 combined.
SELECT TOP 1 o.shipperId, COUNT(*)
FROM Orders o
JOIN Shippers shp
ON o.ShipperId = shp.ShipperId
JOIN OrderDetails od
ON o.OrderId = od.OrderId
WHERE MONTH(o.OrderDate) IN (9, 10) AND YEAR(o.OrderDate) = 1997
GROUP BY o.ShipperId
ORDER BY COUNT(*) , o.shipperId

-- 26) What are the products that weren't shipped at all in the month of August, 1997
SELECT ProductId,ProductName FROM Products
WHERE ProductId NOT IN (  SELECT DISTINCT od.ProductId
                          FROM Orders o
                          JOIN OrderDetails od
                          ON od.OrderId = o.OrderId
                          WHERE MONTH(o.Shipped_date) = 8 AND YEAR(o.Shipped_date) = 1997)

-- 27) What are the products that weren't ordered by each of the employees. List each employee and the products that he didn't order.
SELECT 
    e.id AS EmployeeID, 
    CONCAT(e.first_name, ' ', e.last_name) AS FullName, p.ProductId,
    p.ProductName AS NotOrderedProduct
FROM 
    Employee e
CROSS JOIN 
    Products p
LEFT JOIN 
    (
        SELECT 
            e.id AS EmployeeID, 
            od.ProductID
        FROM 
            Employee e
        JOIN 
            Orders o ON e.id = o.EmployeeId
        JOIN 
            OrderDetails od ON o.OrderId = od.OrderId
    ) AS OrderedProducts ON e.id = OrderedProducts.EmployeeID AND p.ProductID = OrderedProducts.ProductID
WHERE 
    OrderedProducts.ProductID IS NULL
ORDER BY 
    e.id, p.ProductID;

-- 28) Who is busiest shipper in the months of April, May and June during the year 1996 and 1997
SELECT TOP 1 shp.ShipperId, shp.CompanyName AS ShipperName, COUNT(*) AS TotalOrders
FROM Orders o
JOIN OrderDetails od ON o.OrderId = od.OrderId
JOIN Shippers shp ON o.ShipperId = shp.ShipperId
WHERE MONTH(o.OrderDate) IN (4, 5, 6) AND YEAR(o.OrderDate) IN (1996, 1997)
GROUP BY shp.ShipperId, shp.CompanyName
ORDER BY COUNT(*) DESC;

-- 29) Which country supplied the maximum products for all the employees in the year 1997
SELECT TOP 1 sup.Address AS Country, COUNT(*) AS [Total No.of Products]
FROM Orders o
JOIN OrderDetails od ON o.OrderId = od.OrderId
JOIN Products p ON p.ProductId = od.ProductId
JOIN Supplier sup ON sup.SupplierId = p.SupplierId
WHERE YEAR(o.OrderDate) = 1997
GROUP BY sup.Address
ORDER BY COUNT(*) DESC;

-- 30) What is the average number of days taken by all shippers to ship the product after the order has been placed by the employees
SELECT AVG(DATEDIFF(DAY, o.OrderDate, o.Shipped_date)) AS [Average Days To Ship]
FROM Orders o
WHERE o.Shipped_date IS NOT NULL;

-- 31) Who is the quickest shipper of all
SELECT TOP 1 o.ShipperId, 
       AVG(DATEDIFF(DAY, o.OrderDate, o.Shipped_date)) AS [Average days]
FROM Orders o
GROUP BY o.ShipperId
ORDER BY AVG(DATEDIFF(DAY, o.OrderDate, o.Shipped_date))

-- 32) Which order took the least number of shipping days. Get the orderid, employees full name, number of products, number of days took to ship and shipper company name.
SELECT TOP 1 o.OrderId, CONCAT(e.first_name, e.last_name) AS [Full Name], COUNT(*) AS [No.of Products], DATEDIFF(DAY, o.OrderDate, o.Shipped_date) AS [No.of Days took to ship] , shp.CompanyName AS [Shipper Company Name]
FROM Orders o 
JOIN Employee e
ON o.EmployeeId = e.id
JOIN OrderDetails od
ON o.OrderId = od.OrderId
JOIN Shippers shp
ON shp.ShipperId = o.ShipperId
WHERE DATEDIFF(DAY, o.OrderDate, o.Shipped_date) =
(SELECT  MIN(DATEDIFF(DAY, o.OrderDate, o.Shipped_date))
FROM Orders o)
GROUP BY o.OrderId , e.first_name, e.last_name, o.OrderDate, o.Shipped_date, shp.CompanyName


-- UNIONS
-- 1) Which orders took the least number and maximum number of shipping days? Get the orderid, employees full name, number of products, number of days taken to ship the product and shipper company name. Use 1 and 2 in the final result set to distinguish the 2 orders.
SELECT TOP 1 o.OrderId, CONCAT(e.first_name, e.last_name) AS [Full Name], COUNT(*) AS [No.of Products], DATEDIFF(DAY, o.OrderDate, o.Shipped_date) AS [No.of Days took to ship] , shp.CompanyName AS [Shipper Company Name]
FROM Orders o 
JOIN Employee e
ON o.EmployeeId = e.id
JOIN OrderDetails od
ON o.OrderId = od.OrderId
JOIN Shippers shp
ON shp.ShipperId = o.ShipperId
WHERE DATEDIFF(DAY, o.OrderDate, o.Shipped_date) =
(SELECT  MIN(DATEDIFF(DAY, o.OrderDate, o.Shipped_date))
FROM Orders o)
GROUP BY o.OrderId , e.first_name, e.last_name, o.OrderDate, o.Shipped_date, shp.CompanyName
UNION
SELECT TOP 1 o.OrderId, CONCAT(e.first_name, e.last_name) AS [Full Name], COUNT(*) AS [No.of Products], DATEDIFF(DAY, o.OrderDate, o.Shipped_date) AS [No.of Days took to ship] , shp.CompanyName AS [Shipper Company Name]
FROM Orders o 
JOIN Employee e
ON o.EmployeeId = e.id
JOIN OrderDetails od
ON o.OrderId = od.OrderId
JOIN Shippers shp
ON shp.ShipperId = o.ShipperId
WHERE DATEDIFF(DAY, o.OrderDate, o.Shipped_date) =
(SELECT  MAX(DATEDIFF(DAY, o.OrderDate, o.Shipped_date))
FROM Orders o)
GROUP BY o.OrderId , e.first_name, e.last_name, o.OrderDate, o.Shipped_date, shp.CompanyName

-- 2) Which is cheapest and the costliest of products purchased in the second week of October, 1997. Get the product ID, product Name and unit price. Use 1 and 2 in the final result set to distinguish the 2 products.
SELECT p.ProductId, p.ProductName, p.UnitPrice
FROM Orders o
JOIN OrderDEtails od
ON od.OrderId = o.OrderId
JOIN Products p
ON p.ProductId = od.ProductId
WHERE p.UnitPrice = (  SELECT MIN(p.UnitPrice)
                       FROM Orders o
                       JOIN OrderDetails od
                       ON o.OrderId = od.OrderId
                       JOIN Products p
                       ON p.ProductId = od.ProductId
                       WHERE o.OrderDate BETWEEN '1997-10-08' AND '1997-10-14' ) AND o.OrderDate BETWEEN '1997-10-08' AND '1997-10-14'

UNION
SELECT p.ProductId, p.ProductName, p.UnitPrice
FROM Orders o
JOIN OrderDEtails od
ON od.OrderId = o.OrderId
JOIN Products p
ON p.ProductId = od.ProductId
WHERE p.UnitPrice = (  SELECT MAX(p.UnitPrice)
                       FROM Orders o
                       JOIN OrderDetails od
                       ON o.OrderId = od.OrderId
                       JOIN Products p
                       ON p.ProductId = od.ProductId
                       WHERE o.OrderDate BETWEEN '1997-10-08' AND '1997-10-14' ) AND o.OrderDate BETWEEN '1997-10-08' AND '1997-10-14'

-- CASE
-- 1) Find the distinct shippers who are to ship the orders placed by employees with IDs 1, 3, 5, 7 Show the shipper's name as "Express Speedy" if the shipper's ID is 2 and "United Package" if the shipper's ID is 3 and "Shipping Federal" if the shipper's ID is 1
SELECT DISTINCT 
CASE o.ShipperId
    WHEN 1 THEN 'Shipping Federal'
	WHEN 2 THEN 'Express Speedy'
	WHEN 3 THEN 'United Package'
	Else shp.CompanyName
END AS [Distinct Shippers]
FROM Orders o
JOIN Shippers shp
ON o.ShipperId = shp.ShipperId
WHERE o.EmployeeId IN (1, 3, 5, 7)