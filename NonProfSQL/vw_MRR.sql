CREATE VIEW vw_MRR
AS

SELECT 
	dd.Year,
	dd.FirstDayOfMonth,
	dd.MonthName,
	SUM(g.GiftAmount) AS GiftTotal,
	SUM(CASE WHEN g.GiftTypeID = 1 THEN g.GiftAmount ELSE 0 END) AS OneTimeGiftTotal,
	SUM(CASE WHEN g.GiftTypeID = 2 THEN g.GiftAmount ELSE 0 END) AS SubscriptionGiftTotal
FROM dim.date dd
LEFT JOIN dbo.Gift g ON dd.Date = g.GiftDate
WHERE dd.Date <= CAST(GETDATE() AS DATE)
GROUP BY dd.Year, 
	dd.FirstDayOfMonth, dd.MonthName