--TRUNCATE TABLE dbo.LeadSource
INSERT dbo.LeadSource(LeadSourceTitle)
SELECT DISTINCT LeadSourceTitle 
FROM stg.LeadInfo li
WHERE LeadSourceTitle <> 'nan'
AND NOT EXISTS (
	SELECT 1
	FROM dbo.LeadSource ls2
	WHERE li.LeadSourceTitle = ls2.LeadSourceTitle
)


INSERT dbo.Lead (
	LeadSourceID,
	FirstName,
	LastName,
	CreatedDate
	)
SELECT
	ls.LeadSourceID,
	li.FirstName, 
	li.LastName,
	GETDATE()
FROM stg.LeadInfo li
LEFT JOIN dbo.LeadSource ls ON li.LeadSourceTitle = ls.LeadSourceTitle
AND NOT EXISTS (
	SELECT 1
	FROM dbo.Lead l2
	WHERE li.FirstName = l2.FirstName
	AND li.LastName = l2.LastName
)


INSERT dbo.ContactMethod (
	ContactMethodTitle
	) 
SELECT DISTINCT ct.ContactMethodTitle 
FROM stg.CampaignTransactionInfo ct
WHERE ct.ContactMethodTitle <> 'nan'
AND NOT EXISTS (
	SELECT 1
	FROM dbo.ContactMethod cm
	WHERE ct.ContactMethodTitle = cm.ContactMethodTitle
)


INSERT dbo.EmailType (
	EmailTypeDesc
	)
SELECT DISTINCT li.EmailTypeDesc
FROM stg.LeadInfo li
WHERE NOT EXISTS (
	SELECT 1
	FROM dbo.EmailType et 
	WHERE li.EmailTypeDesc = et.EmailTypeDesc
)


INSERT dbo.Email (
	EmailTypeID, 
	Email
	)
SELECT DISTINCT 
	et.EmailTypeID,
	li.Email
FROM stg.LeadInfo li
LEFT JOIN dbo.EmailType et on li.EmailTypeDesc = et.EmailTypeDesc
WHERE NOT EXISTS (
	SELECT 1
	FROM dbo.Email e
	WHERE li.Email = e.Email
)

INSERT dbo.AddressType (
	AddressTypeDesc
	)
SELECT DISTINCT li.AddressTypeDesc
FROM stg.LeadInfo li
WHERE NOT EXISTS (
	SELECT 1
	FROM dbo.AddressType at 
	WHERE li.AddressTypeDesc = at.AddressTypeDesc
)
	
--TRUNCATE TABLE dbo.Address
INSERT dbo.Address (
	AddressTypeID, 
	State,  
	City ,
	Zip,
	Address1
	)
SELECT DISTINCT
	at.AddressTypeID,
	li.State,
	li.City,
	NULLIF(li.Zip,0) AS Zip,
	NULLIF(li.Address1,'nan') AS Address1
FROM stg.LeadInfo li
LEFT JOIN dbo.AddressType at on li.AddressTypeDesc = at.AddressTypeDesc
WHERE NOT EXISTS (
	SELECT 1
	FROM dbo.Address a
	WHERE li.State = a.State
	AND li.City = a.City
	AND li.Address1 = ISNULL(a.Address1,'nan')
)

--SELECT *
--FROM dbo.Address

INSERT dbo.PhoneType (
	PhoneTypeDesc
	)
SELECT DISTINCT li.PhoneTypeDesc
FROM stg.LeadInfo li
WHERE li.PhoneTypeDesc <> 'nan'
AND NOT EXISTS (
	SELECT 1
	FROM dbo.PhoneType pt 
	WHERE li.PhoneTypeDesc = pt.PhoneTypeDesc
)



INSERT dbo.Phone (
	PhoneTypeID, 
	Phone
	)
SELECT DISTINCT
	pt.PhoneTypeID,
	li.Phone
FROM stg.LeadInfo li
LEFT JOIN dbo.PhoneType pt on li.PhoneTypeDesc = pt.PhoneTypeDesc
WHERE li.Phone <> 0
AND NOT EXISTS (
	SELECT 1
	FROM dbo.Phone p
	WHERE li.Phone = p.Phone
)


INSERT dbo.Website (
	WebsiteName, 
	[URL]
	)
SELECT DISTINCT
	ae.WebsiteName,
	ae.URL
FROM stg.AttemptsEventsInfo ae
WHERE ae.URL <> 'nan'
AND NOT EXISTS (
	SELECT 1
	FROM dbo.Website w
	WHERE ae.URL = w.URL
)

--TRUNCATE TABLE dbo.LeadContact
INSERT dbo.LeadContact (
	LeadID, 
	ContactMethodID,
	IsPrimary,
	ID
	)
SELECT l.LeadID,
(SELECT TOP 1 cm.ContactMethodID FROM dbo.ContactMethod cm WHERE cm.ContactMethodTitle = 'Email'),
CASE WHEN li.Phone <> 0 THEN 0 ELSE 1 END AS IsPrimary,
e.EmailID
FROM stg.LeadInfo li
JOIN dbo.Lead l ON li.FirstName = l.FirstName AND li.LastName = l.LastName
JOIN dbo.Email e ON li.Email = e.Email
WHERE NOT EXISTS (
	SELECT 1
	FROM dbo.LeadContact lc
	WHERE l.LeadID = lc.LeadID
	AND lc.ContactMethodID = (SELECT TOP 1 cm.ContactMethodID FROM dbo.ContactMethod cm WHERE cm.ContactMethodTitle = 'Email')
	AND lc.ID = e.EmailID
)
UNION
SELECT l.LeadID,
(SELECT TOP 1 cm.ContactMethodID FROM dbo.ContactMethod cm WHERE cm.ContactMethodTitle = 'Phone'),
CASE WHEN li.Phone <> 0 THEN 1 ELSE 0 END AS IsPrimary,
p.PhoneID
FROM stg.LeadInfo li
JOIN dbo.Lead l ON li.FirstName = l.FirstName AND li.LastName = l.LastName
JOIN dbo.Phone p ON li.Phone = p.Phone
WHERE NOT EXISTS (
	SELECT 1
	FROM dbo.LeadContact lc
	WHERE l.LeadID = lc.LeadID
	AND lc.ContactMethodID = (SELECT TOP 1 cm.ContactMethodID FROM dbo.ContactMethod cm WHERE cm.ContactMethodTitle = 'Phone')
	AND lc.ID = p.PhoneID
)
UNION
SELECT l.LeadID,
(SELECT TOP 1 cm.ContactMethodID FROM dbo.ContactMethod cm WHERE cm.ContactMethodTitle = 'Mail'),
0 AS IsPrimary,
a.AddressID
FROM stg.LeadInfo li
JOIN dbo.Lead l ON li.FirstName = l.FirstName AND li.LastName = l.LastName
JOIN dbo.Address a ON li.State = a.State AND li.City = a.City AND ISNULL(li.Address1,'nan') = ISNULL(a.Address1,'nan')
WHERE NOT EXISTS (
	SELECT 1
	FROM dbo.LeadContact lc
	WHERE l.LeadID = lc.LeadID
	AND lc.ContactMethodID = (SELECT TOP 1 cm.ContactMethodID FROM dbo.ContactMethod cm WHERE cm.ContactMethodTitle = 'Mail')
	AND lc.ID = a.AddressID
)


INSERT dbo.SubscriptionType (
	SubscriptionTypeCode,
	SubscriptionTypeDesc
	)
SELECT DISTINCT
	gs.SubscriptionTypeCode,
	gs.SubscriptionTypeDesc
FROM stg.GiftSubscriptionInfo gs
WHERE gs.SubscriptionTypeDesc <> 'nan'
AND NOT EXISTS (
	SELECT 1
	FROM dbo.SubscriptionType st
	WHERE st.SubscriptionTypeDesc = gs.SubscriptionTypeDesc
)

INSERT dbo.Subscription (
	SubscriptionName,
	SubscriptionTypeID,
	SubscriptionAmount
	)
SELECT DISTINCT
	gs.SubscriptionName,
	st.SubscriptionTypeID,
	gs.SubscriptionAmount
FROM stg.GiftSubscriptionInfo gs
JOIN dbo.SubscriptionType st ON gs.SubscriptionTypeDesc = st.SubscriptionTypeDesc
WHERE NOT EXISTS (
	SELECT 1
	FROM dbo.Subscription s
	WHERE s.SubscriptionName = gs.SubscriptionName
)


INSERT dbo.Donor (
	LeadID,
	FirstName,
	LastName,
	CreatedDate
	)
SELECT DISTINCT
	l.LeadID,
    l.FirstName,
    l.LastName,
    l.CreatedDate
FROM dbo.Lead l
JOIN stg.GiftSubscriptionInfo gs ON l.FirstName = gs.FirstName AND l.LastName = gs.LastName
WHERE NOT EXISTS (
	SELECT 1
	FROM dbo.Donor d
	WHERE l.FirstName = d.FirstName
	AND l.LastName = d.LastName
)

	
INSERT dbo.DonorContact (
	DonorID,
	ContactMethodID,
	IsPrimary,
	ID
	)
SELECT d.DonorID,
       lc.ContactMethodID,
       lc.IsPrimary,
       lc.ID
FROM dbo.Donor d
JOIN dbo.LeadContact lc ON d.LeadID = lc.LeadID
WHERE NOT EXISTS (
	SELECT 1 
	FROM dbo.DonorContact dc
	WHERE d.DonorID = dc.DonorID
	AND lc.ContactMethodID = dc.ContactMethodID
	AND lc.ID = dc.ID
)

	
INSERT dbo.DonorSubscription (
	DonorID,
	SubscriptionID,
	StartDate
	)
SELECT DISTINCT
	d.DonorID,
	s.SubscriptionID,
	gs.StartDate
FROM stg.GiftSubscriptionInfo gs
JOIN dbo.Donor d ON gs.FirstName = d.FirstName AND gs.LastName = d.LastName
JOIN dbo.Subscription s ON gs.SubscriptionName = s.SubscriptionName
WHERE NOT EXISTS (
	SELECT 1 
	FROM dbo.DonorSubscription dc
	WHERE d.DonorID = dc.DonorID
	AND s.SubscriptionID = dc.SubscriptionID
)
	
INSERT dbo.GiftType (
	GiftTypeDesc
	)
SELECT DISTINCT gs.GiftTypeDesc
FROM stg.GiftSubscriptionInfo gs
WHERE gs.GiftTypeDesc <> 'nan'
AND NOT EXISTS (
	SELECT 1 
	FROM dbo.GiftType gt
	WHERE gs.GiftTypeDesc = gt.GiftTypeDesc
)
	
INSERT dbo.Gift (
	GiftTypeID,
	SubscriptionID,
	GiftDate,
	GiftAmount
	)
SELECT gt.GiftTypeID,
	s.SubscriptionID,
	gs.GiftDate,
	gs.GiftAmount
FROM stg.GiftSubscriptionInfo gs
JOIN dbo.GiftType gt ON gs.GiftTypeDesc = gt.GiftTypeDesc
LEFT JOIN dbo.Subscription s ON gs.SubscriptionName = s.SubscriptionName
WHERE gs.GiftAmount > 0
AND NOT EXISTS (
	SELECT 1 
	FROM dbo.Gift g
	WHERE gt.GiftTypeID = g.GiftTypeID
	AND gs.GiftDate = g.GiftDate
	AND gs.GiftAmount = g.GiftAmount
)

	
INSERT dbo.DonorGiftAssoc (
	DonorID,
	GiftID
	)
SELECT DISTINCT 
	d.DonorID, 
	g.GiftID
FROM stg.GiftSubscriptionInfo gs
JOIN dbo.Donor d ON gs.FirstName = d.FirstName AND gs.LastName = d.LastName
JOIN dbo.GiftType gt ON gs.GiftTypeDesc = gt.GiftTypeDesc
JOIN dbo.Gift g ON gt.GiftTypeID = g.GiftTypeID
	AND gs.GiftDate = g.GiftDate
	AND gs.GiftAmount = g.GiftAmount
WHERE NOT EXISTS (
	SELECT 1 
	FROM dbo.DonorGiftAssoc dga
	WHERE d.DonorID = dga.DonorID
	AND g.GiftID = dga.GiftID
)

	
INSERT dbo.Campaign ( 
	CampaignTitle,
	CampaignStart,
	CampaignEnd
	)
SELECT DISTINCT 
	ct.CampaignTitle,
	ct.CampaignStart,
	NULLIF(ct.CampaignEnd,'1900-01-01')
FROM stg.CampaignTransactionInfo ct
WHERE NOT EXISTS (
	SELECT 1 
	FROM dbo.Campaign c
	WHERE ct.CampaignTitle = c.CampaignTitle
)
	

INSERT dbo.Advertisement (
	CampaignID,
	ContactMethodID,
	AdvertisementTitle
	)
SELECT DISTINCT
	c.CampaignID,
	cm.ContactMethodID,
	ct.AdvertisementTitle
FROM stg.CampaignTransactionInfo ct
LEFT JOIN dbo.ContactMethod cm ON ct.ContactMethodTitle = cm.ContactMethodTitle
JOIN dbo.Campaign c ON ct.CampaignTitle = c.CampaignTitle
WHERE NOT EXISTS (
	SELECT 1 
	FROM dbo.Advertisement a
	WHERE ct.AdvertisementTitle = a.AdvertisementTitle
)
	


INSERT dbo.TransactionType (
	TransactionTypeCode,
	TransactionTypeDesc
	)
SELECT DISTINCT
	ct.TransactionTypeCode,
	ct.TransactionTypeDesc
FROM stg.CampaignTransactionInfo ct
WHERE ct.TransactionTypeDesc <> 'nan'
AND	NOT EXISTS (
	SELECT 1 
	FROM dbo.TransactionType a
	WHERE ct.TransactionTypeDesc = a.TransactionTypeDesc
)


INSERT dbo.AdvertisementLeadAssoc (
	AdvertisementID,
	LeadID
	)
SELECT DISTINCT
	a.AdvertisementID,
	l.LeadID
FROM stg.AttemptsEventsInfo ae
JOIN dbo.Advertisement a ON ae.AdvertisementTitle = a.AdvertisementTitle
JOIN dbo.Lead l ON ae.FirstName = l.FirstName AND ae.LastName = l.LastName
WHERE NOT EXISTS (
	SELECT 1 
	FROM dbo.AdvertisementLeadAssoc ala
	WHERE a.AdvertisementID = ala.AdvertisementID
	AND l.LeadID = ala.LeadID
)
	
INSERT dbo.ContactAttempt (
	AdvertisementLeadAssoc, 
	AttemptDate,
	AttemptCost
	)
SELECT DISTINCT ala.AdvertisementLeadAssocID,
	ae.AttemptDate,
	ae.AttemptCost
FROM stg.AttemptsEventsInfo ae
JOIN dbo.Advertisement a ON ae.AdvertisementTitle = a.AdvertisementTitle
JOIN dbo.Lead l ON ae.FirstName = l.FirstName AND ae.LastName = l.LastName
JOIN dbo.AdvertisementLeadAssoc ala ON a.AdvertisementID = ala.AdvertisementID AND l.LeadID = ala.LeadID
WHERE ae.AttemptDate <> '1900-01-01'
AND NOT EXISTS (
	SELECT 1
	FROM dbo.ContactAttempt ca
	WHERE ala.AdvertisementLeadAssocID = ca.AdvertisementLeadAssoc
	AND ae.AttemptDate = ca.AttemptDate
)

	
INSERT dbo.EventType (
	EventTypeName
	)  
SELECT DISTINCT EventTypeName
FROM stg.AttemptsEventsInfo ae
WHERE ae.EventTypeName <> 'nan'
AND NOT EXISTS (
	SELECT 1
	FROM dbo.EventType et
	WHERE ae.EventTypeName = et.EventTypeName
)
	


INSERT dbo.ContactEvent (
	EventTypeID, 
	EventDate,
	ContactAttemptID,
	WebsiteID
	)
SELECT et.EventTypeID,
	ae.EventDate,
	ca.ContactAttemptID,
	w.WebsiteID
FROM stg.AttemptsEventsInfo ae
LEFT JOIN dbo.Advertisement a ON ae.AdvertisementTitle = a.AdvertisementTitle
LEFT JOIN dbo.Lead l ON ae.FirstName = l.FirstName AND ae.LastName = l.LastName
LEFT JOIN dbo.AdvertisementLeadAssoc ala ON a.AdvertisementID = ala.AdvertisementID AND l.LeadID = ala.LeadID
LEFT JOIN dbo.Website w ON ae.WebsiteName = w.WebsiteName
LEFT JOIN dbo.ContactAttempt ca ON ae.AttemptDate = ca.AttemptDate AND ala.AdvertisementLeadAssocID = ca.AdvertisementLeadAssoc
LEFT JOIN dbo.EventType et ON ae.EventTypeName = et.EventTypeName
WHERE ae.EventDate <> '1900-01-01'
AND NOT EXISTS (
	SELECT 1
	FROM dbo.ContactEvent ce
	WHERE et.EventTypeID = ce.EventTypeID
	AND ae.EventDate = ce.EventDate
)
	
INSERT dbo.AdvertisementTransaction (
	TransactionTypeID,
	AdvertisementID,
	TransactionAmount
	)
SELECT tt.TransactionTypeID,
	a.AdvertisementID,
	ct.TransactionAmount
FROM stg.CampaignTransactionInfo ct
JOIN dbo.TransactionType tt ON ct.TransactionTypeCode = tt.TransactionTypeCode
JOIN dbo.Advertisement a ON ct.AdvertisementTitle = a.AdvertisementTitle
WHERE ct.TransactionAmount <> 0
AND NOT EXISTS (
	SELECT 1 FROM dbo.AdvertisementTransaction at
	WHERE tt.TransactionTypeID = at.TransactionTypeID
	AND a.AdvertisementID = at.AdvertisementID
	AND ct.TransactionAmount = at.TransactionAmount
)
