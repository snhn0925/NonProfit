CREATE TABLE stg.LeadInfo (
	FirstName VARCHAR(100) NULL,
	LastName VARCHAR(100) NULL,
	EmailTypeDesc VARCHAR(30) NULL,
	Email VARCHAR(100) NULL,
	AddressTypeDesc VARCHAR(30) NULL,
	State VARCHAR(2) NULL,  
	City VARCHAR(100) NULL ,
	Zip NUMERIC(5) NULL ,
	Address1 VARCHAR(250) NULL,
	Address2 VARCHAR(250) NULL,
	PhoneTypeDesc VARCHAR(30) NULL,
	Phone NUMERIC(12) NULL,
	LeadSourceTitle VARCHAR(30) NULL
)


CREATE TABLE stg.CampaignTransactionInfo (
	CampaignTitle VARCHAR(250) NULL,
	CampaignStart DATETIME NULL,
	CampaignEnd DATETIME NULL,
	AdvertisementTitle VARCHAR(250) NULL,
	ContactMethodTitle VARCHAR(30) NULL ,
	TransactionAmount DECIMAL(19,4) NULL,
	TransactionTypeCode VARCHAR(2) NULL,
	TransactionTypeDesc VARCHAR(30) NULL
)


CREATE TABLE stg.AttemptsEventsInfo (
	FirstName VARCHAR(100) NULL,
	LastName VARCHAR(100) NULL,
	AdvertisementTitle VARCHAR(250) NULL,
	AttemptCost DECIMAL(19,4) NULL,
	AttemptDate DATETIME NULL,
	EventDate DATETIME NULL,
	EventTypeName VARCHAR(30) NULL ,
	URL VARCHAR(MAX) NULL,
	WebsiteName VARCHAR(30) NULL
)

DROP TABLE IF EXISTS stg.GiftSubscriptionInfo
CREATE TABLE stg.GiftSubscriptionInfo (
	FirstName VARCHAR(100) NULL,
	LastName VARCHAR(100) NULL,
	GiftTypeDesc VARCHAR(30) NULL,
	GiftDate DATETIME NULL,
	GiftAmount DECIMAL(19,4) NULL,
	SubscriptionName VARCHAR(250) NULL,
	SubscriptionTypeCode VARCHAR(2) NULL,
	SubscriptionTypeDesc VARCHAR(30) NULL,
	StartDate DATETIME NULL,
	SubscriptionAmount DECIMAL(19,4) NULL
)
