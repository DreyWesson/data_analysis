SELECT 
    c.CustomerID, 
    c.companyName, 
    SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalSales,
    AVG(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS AverageOrderValue,
    COUNT(DISTINCT o.OrderID) AS OrderCount,
    SUM(od.Quantity) AS TotalQuantity
FROM 
    customers c
INNER JOIN orders o ON c.CustomerID = o.CustomerID
INNER JOIN "order details" od ON o.OrderID = od.OrderID
GROUP BY 
    c.CustomerID, c.companyName
ORDER BY 
    TotalSales DESC;