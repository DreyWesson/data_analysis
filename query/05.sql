WITH MonthlySales AS (
  SELECT
    STRFTIME('%Y-%m', o.OrderDate) AS OrderMonth,
    SUM(od.UnitPrice * od.Quantity * (1 - COALESCE(od.Discount, 0))) AS TotalSales
  FROM Orders o
  INNER JOIN "Order Details" od ON o.OrderID = od.OrderID
  GROUP BY OrderMonth
)
SELECT * FROM MonthlySales
ORDER BY OrderMonth;
