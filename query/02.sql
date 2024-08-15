WITH ProductSales AS (
  SELECT 
      p.ProductID, 
      p.ProductName, 
      o.OrderDate, 
      od.UnitPrice, 
      od.Quantity,
      od.UnitPrice * od.Quantity * (1 - od.Discount) AS TotalPrice
  FROM products p
  INNER JOIN "order details" od ON p.ProductID = od.ProductID
  INNER JOIN orders o ON od.OrderID = o.OrderID
),
ProductPerformance AS (
  SELECT 
      ProductID, 
      ProductName, 
      SUM(TotalPrice) AS TotalSales,
      AVG(UnitPrice) AS AveragePrice,
      COUNT(*) AS OrderCount,
      SUM(Quantity) AS TotalQuantity,
      STRFTIME('%Y-%m', OrderDate) AS SalesMonth
  FROM ProductSales
  GROUP BY ProductID, ProductName, SalesMonth
)
SELECT 
  pp.ProductID, 
  pp.ProductName, 
  pp.SalesMonth, 
  pp.TotalSales, 
  (pp.TotalSales - SUM(ps.Quantity * ps.UnitPrice)) AS Profit,
  pp.AveragePrice, 
  pp.OrderCount
FROM ProductPerformance pp
INNER JOIN ProductSales ps ON pp.ProductID = ps.ProductID AND STRFTIME('%Y-%m', ps.OrderDate) = pp.SalesMonth
GROUP BY pp.ProductID, pp.ProductName, pp.SalesMonth
ORDER BY pp.SalesMonth, pp.TotalSales DESC;
