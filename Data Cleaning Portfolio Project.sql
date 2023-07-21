-----------------------------------------------------------------------------------------------------------------------------
--Naomi Ngethe
--Combining Data from multiple sources-Joins


--How many Sales Orders (Headers) used Vista credit cards in October 2002

SELECT		*
FROM        [Sales].[SalesOrderHeader]

SELECT CreditCardID
FROM Sales.CreditCard
WHERE CardType = 'Vista'


SELECT COUNT(*)
FROM (
   SELECT soh.*, cc.CardType
   FROM Sales.SalesOrderHeader soh
   INNER JOIN Sales.CreditCard cc
   ON soh.CreditCardID = cc.CreditCardID
) t
WHERE t.CardType = 'Vista'
AND t.OrderDate BETWEEN '2002-10-01' AND '2002-10-31'


-- Store the answer to Q1. in a variable.

DECLARE @num_vista_orders INT;
SELECT @num_vista_orders = COUNT(*)
FROM Sales.SalesOrderHeader
WHERE CreditCardID IN (SELECT CreditCardID FROM Sales.CreditCard WHERE CardType = 'Vista')
AND OrderDate BETWEEN '2002-10-01' AND '2002-10-31'

--Create a UDF that accepts start date and end date. The function will returnthe number of Sales Orders (Using Vista credit cards)
-- that took place between the start date and end date entered by the user.


CREATE FUNCTION GetNumberVistaOrders (@start_date DATE, @end_date DATE)
RETURNS INT
AS
BEGIN
   DECLARE @result INT;

   SELECT @result = COUNT(*)
   FROM Sales.SalesOrderHeader
   WHERE  CreditCardID IN (SELECT CreditCardID FROM Sales.CreditCard WHERE CardType = 'Vista')
AND OrderDate BETWEEN  @start_date AND @end_date;

 
   RETURN @result;
END

--Find out how much Revenue (TotalDue) was brought in by the North American Territory Group from 2002 through 2004
SELECT SUM(TotalDue) AS TotalRevenue
FROM Sales.SalesOrderHeader
WHERE TerritoryID IN (SELECT TerritoryID FROM Sales.SalesTerritory WHERE CountryRegionCode = 'US')
AND OrderDate BETWEEN '2002-01-01' AND '2004-12-31'



SELECT * 
FROM [Sales].[CreditCard] 
 SELECT [TotalDue]
 FROM [Sales].[SalesOrderHeader] 
 WHERE TerritoryID IN (1,2,3,4,5,6) AND [OrderDate] BETWEEN 2005-01-01 
 AND 2007-12-31 ORDER BY ModifiedDate select * from [Sales].[SalesTerritory] s SELECT h.[TotalDue] 
 FROM [Sales].[SalesOrderHeader] h INNER JOIN [Sales].[SalesTerritory] s
 ON h.[TerritoryID] = s.TerritoryID WHERE h.TerritoryID IN (1,2,3,4,5,6) AND h.[OrderDate] BETWEEN YEAR(2005) AND YEAR(2007) 

 --Store the above code in a variable
 DECLARE @sales_data TABLE (CreditCard varchar(50), TotalDue MONEY, SalesTerritory varchar(50));

INSERT INTO @sales_data (CreditCard, TotalDue, SalesTerritory)
SELECT cc.CardType, h.TotalDue, st.Name
FROM Sales.CreditCard cc
INNER JOIN Sales.SalesOrderHeader h
ON cc.CreditCardID = h.CreditCardID
INNER JOIN Sales.SalesTerritory st
ON h.TerritoryID = st.TerritoryID
WHERE h.TerritoryID IN (1,2,3,4,5,6) AND h.OrderDate BETWEEN '2005-01-01' AND '2007-12-31';

--Create a UDF that accepts the State Province and returns the associated Sales Tax Rate,
-- StateProvinceCode and CountryRegionCode.



 CREATE FUNCTION Fx_Utility ( @StateProvinceID INT )
 RETURNS TABLE
 AS 
 RETURN
 ( SELECT s.[TaxRate], s.[StateProvinceID], t.[CountryRegionCode] 
 FROM [Sales].[SalesTaxRate] s JOIN [Sales].[SalesTerritory]
 t
 ON s.[ModifiedDate] = t.[ModifiedDate]
 WHERE s.[Name] Like '%@State%' ) 
 SELECT * FROM Fx_Utility('California')

 --Show a list of Product Colors. For each Color show how many SalesDetails there are and the Total SalesAmount--
 --(UnitPrice * OrderQty).Only show Colors with a Total SalesAmount more than $50,000 
--and eliminate the products that do not have a color.

select * from Production.Product
select * from Sales.SalesOrderDetail

Select pr.Color
from Production.Product as pr
left Join 
--on pr.ProductID=sr.ProductID
(SELECT  count( sr.SalesOrderDetailID) as count1,sum(sr.UnitPrice * sr.OrderQty) as total
     FROM    Sales.SalesOrderDetail as sr
     GROUP BY sr.ProductID,
     HAVING  sum (sr.UnitPrice * sr.OrderQty) >50000
    ) as sa
 on sa.ProductID=pr.ProductID

 SELECT * 
 FROM [Production].[Product] p
 SELECT * FROM [Sales].[SalesOrderDetail] s
 SELECT DISTINCT(p.color) AS Color, 
 COUNT(s.SalesOrderID) AS OrderID, SUM(s.[UnitPrice]*s.OrderQty)
 AS TotalSalesAmt FROM [Sales].[SalesOrderDetail] S JOIN [Production].[Product] p
 ON s.[ProductID] = p.[ProductID] WHERE p.Color IS NOT NULL GROUP BY (p.color) HAVING SUM(s.[UnitPrice]*s.OrderQty) > 50000


 --Create a join using 4 tables in AdventureWorks database. Explain what the join is doing

 SELECT *
 FROM Production.Product

  SELECT *
 FROM [Production].[ProductCategory]

  SELECT *
 FROM [Production].[ProductModel]


 SELECT p.Name AS ProductName, c.Name AS CategoryName, sc.Name AS SubCategoryName, pm.Name AS ProductModelName
FROM Production.Product p
INNER JOIN Production.ProductSubcategory sc
ON p.ProductSubcategoryID = sc.ProductSubcategoryID
INNER JOIN Production.ProductCategory c
ON sc.ProductCategoryID = c.ProductCategoryID
INNER JOIN Production.ProductModel pm
ON p.ProductModelID = pm.ProductModelID
INNER JOIN Production.ProductModelProductDescriptionCulture pc
ON pm.ProductModelID = pc.ProductModelID
AND pc.CultureID = 'en'
