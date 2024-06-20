CREATE VIEW vw_GiftsByLocation
AS

SELECT a.City,
	a.State,
	COUNT(DISTINCT dc.DonorID) AS DonorCnt,
	SUM(g.GiftAmount) AS GiftTotal
FROM dbo.DonorContact dc 
JOIN dbo.Address a ON dc.ID = a.AddressID AND dc.ContactMethodID = 2
JOIN dbo.DonorGiftAssoc dga ON dc.DonorID = dga.DonorID
JOIN dbo.Gift g ON dga.GiftID = g.GiftID
GROUP BY a.City, a.State