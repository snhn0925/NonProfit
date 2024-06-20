CREATE VIEW vw_AdROI
AS

WITH CTE_AdTransact AS (
	SELECT 
		c.CampaignTitle,
		a.AdvertisementID,
		a.AdvertisementTitle,
		CAST(SUM(at.TransactionAmount) AS NUMERIC(10,2)) AS TotalAdCost
	FROM dbo.Campaign c
	JOIN dbo.Advertisement a ON c.CampaignID = a.CampaignID
	JOIN dbo.AdvertisementTransaction at ON a.AdvertisementID = at.AdvertisementID
	GROUP BY c.CampaignTitle, a.AdvertisementID, a.AdvertisementTitle
),
CTE_AdDonor AS (
	SELECT DISTINCT
		ala.AdvertisementID,
		ala.AdvertisementLeadAssocID,
		ala.LeadID,
		d.DonorID,
		ce.EventDate,
		DATEADD(MONTH,1,ce.EventDate) AS EventDatePlus1Mo
	FROM dbo.AdvertisementLeadAssoc ala 
	JOIN dbo.Donor d ON ala.LeadID = d.LeadID
	JOIN dbo.ContactAttempt ca ON ala.AdvertisementLeadAssocID = ca.AdvertisementLeadAssoc
	JOIN dbo.ContactEvent ce ON ca.ContactAttemptID = ce.ContactAttemptID
)
SELECT 
	cat.CampaignTitle, 
	cat.AdvertisementTitle,
	TotalAdCost,
	SUM(ISNULL(g.GiftAmount,0)) AS TotalGiftAmount,
	CAST(((CAST(SUM(ISNULL(g.GiftAmount,0)) AS NUMERIC(10,2))/
	cat.TotalAdCost)*100) AS NUMERIC(10,2)) AS ROI
FROM CTE_AdTransact cat
LEFT JOIN CTE_AdDonor ad ON cat.AdvertisementID = ad.AdvertisementID
LEFT JOIN dbo.DonorGiftAssoc dga ON ad.DonorID = dga.DonorID
LEFT JOIN dbo.DonorSubscription ds ON ad.DonorID = ds.DonorID
LEFT JOIN dbo.Gift g ON dga.GiftID = g.GiftID 
AND (
	(g.GiftTypeID = 1 AND g.GiftDate BETWEEN ad.EventDate AND ad.EventDatePlus1Mo)
OR 
	(g.GiftTypeID = 2 AND ds.SubscriptionID = g.SubscriptionID 
		AND ds.StartDate BETWEEN ad.EventDate AND ad.EventDatePlus1Mo)
		)
GROUP BY cat.CampaignTitle, cat.AdvertisementTitle, cat.TotalAdCost