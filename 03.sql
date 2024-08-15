-- CREATE TABLE OrderPromotions (
--     OrderPromotionID INT PRIMARY KEY,
--     OrderID INT,
--     PromotionID INT,
--     StartDate DATE,
--     EndDate DATE,
--     DiscountPercentage DECIMAL(5,2),
--     PromotionType VARCHAR(50),
--     FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
--     FOREIGN KEY (PromotionID) REFERENCES Promotions(PromotionID)
-- );

-- CREATE TABLE Promotions (
--     PromotionID INT PRIMARY KEY,
--     PromotionName VARCHAR(50),
--     Description TEXT,
--     StartDate DATE,
--     EndDate DATE,
--     DiscountType VARCHAR(50),
--     DiscountValue DECIMAL(5,2)
-- );

-- CREATE TABLE Holidays (
--     HolidayID INT PRIMARY KEY,
--     HolidayName VARCHAR(50),
--     HolidayDate DATE
-- );

WITH OrderTrends AS (
    SELECT
        STRFTIME('%Y-%m', o.OrderDate) AS OrderMonth,
        SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalSales,
        COUNT(DISTINCT o.OrderID) AS OrderCount,
        SUM(od.Quantity) AS TotalQuantity,
        SUM(od.UnitPrice * od.Quantity * od.Discount) AS TotalDiscount,
        SUM(CASE WHEN op.PromotionID IS NOT NULL THEN 1 ELSE 0 END) AS PromotionCount
    FROM 
        orders o
    INNER JOIN "order details" od ON o.OrderID = od.OrderID
    LEFT JOIN OrderPromotions op ON o.OrderID = op.OrderID
    GROUP BY 
        OrderMonth
),
HolidayOrders AS (
  SELECT
    STRFTIME('%Y-%m', o.OrderDate) AS OrderMonth,
    COUNT(o.OrderID) AS OrdersOnHoliday
  FROM Orders o
  LEFT JOIN Holidays h ON o.OrderDate = h.HolidayDate
  WHERE h.HolidayID IS NOT NULL
  GROUP BY OrderMonth
)
SELECT
  ot.OrderMonth,
  SUM(ot.TotalSales) AS MonthlySales,
  SUM(ot.TotalDiscount) AS MonthlyDiscounts,
  SUM(ot.TotalQuantity) AS MonthlyQuantity,
  SUM(ot.PromotionCount) AS OrdersWithPromotion,
  COALESCE(ho.OrdersOnHoliday, 0) AS OrdersOnHoliday
FROM 
  OrderTrends ot
LEFT JOIN 
  HolidayOrders ho ON ot.OrderMonth = ho.OrderMonth
GROUP BY 
  ot.OrderMonth
ORDER BY 
  ot.OrderMonth;

