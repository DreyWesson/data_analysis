WITH SupplierPerformance AS (
  SELECT
    s.SupplierID,
    s.CompanyName AS SupplierName,
    COUNT(DISTINCT oi.ProductID) / COUNT(DISTINCT o.OrderID) AS OrderItemFulfillmentRate,
    AVG(julianday(o.RequiredDate) - julianday(o.OrderDate)) AS AverageOrderLeadTime
  FROM
    Suppliers s
  INNER JOIN Products p ON s.SupplierID = p.SupplierID
  INNER JOIN "Order Details" oi ON p.ProductID = oi.ProductID
  INNER JOIN Orders o ON oi.OrderID = o.OrderID
  GROUP BY s.SupplierID, s.CompanyName
)
SELECT * FROM SupplierPerformance
ORDER BY OrderItemFulfillmentRate DESC;
