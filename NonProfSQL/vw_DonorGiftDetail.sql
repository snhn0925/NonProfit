CREATE VIEW vw_DonorGiftDetail
AS 
SELECT d.FirstName,
	d.LastName,
	g.GiftAmount,
	g.GiftDate
FROM dbo.Donor d
JOIN dbo.DonorGiftAssoc dga ON d.DonorID = dga.DonorID
JOIN dbo.Gift g ON dga.GiftID = g.GiftID