WITH ProductSales AS (
  SELECT
    Products.ProductID,
    Products.CategoryID,
    SUM((od.UnitPrice * od.Quantity) * (1 - COALESCE(od.Discount, 0))) AS TotalSales,
    SUM(Products.UnitPrice * od.Quantity) AS TotalCost
  FROM Products
  INNER JOIN "Order Details" od ON Products.ProductID = od.ProductID
  INNER JOIN Orders o ON od.OrderID = o.OrderID
  INNER JOIN Categories c ON Products.CategoryID = c.CategoryID
  GROUP BY Products.ProductID, Products.CategoryID
)
SELECT
  c.CategoryName,
  'No Demographic' AS CustomerDesc,  -- Default value due to empty table
  SUM(ps.TotalSales) AS TotalSales,
  SUM(ps.TotalCost) AS TotalCost,
  (SUM(ps.TotalSales) - SUM(ps.TotalCost)) / SUM(ps.TotalSales) AS GrossProfitMargin
FROM ProductSales ps
INNER JOIN Categories c ON ps.CategoryID = c.CategoryID
GROUP BY c.CategoryName, CustomerDesc
ORDER BY GrossProfitMargin DESC;
