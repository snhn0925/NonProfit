CREATE VIEW vw_DonorRank
AS 
SELECT d.FirstName,
	d.LastName,
	SUM(g.GiftAmount) AS TotalGiven,
	MAX(g.GiftDate) AS LatestGift,
	DENSE_RANK() OVER (ORDER BY SUM(g.GiftAmount) DESC) TotalGivenRank,
	DENSE_RANK() OVER (ORDER BY MAX(g.GiftDate) DESC) LatestGiftRank
FROM dbo.Donor d
JOIN dbo.DonorGiftAssoc dga ON d.DonorID = dga.DonorID
JOIN dbo.Gift g ON dga.GiftID = g.GiftID
GROUP BY d.FirstName, d.LastName