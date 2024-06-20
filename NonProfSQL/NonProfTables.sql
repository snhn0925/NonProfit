CREATE TABLE dbo.SUBSCRIPTION (
	SubscriptionID INT IDENTITY(1,1) NOT NULL,
	SubscriptionName VARCHAR(250) NOT NULL,
	SubscriptionTypeID INT NOT NULL,
	SubscriptionAmount DECIMAL(19,4) NOT NULL
	)
	
CREATE TABLE dbo.SubscriptionType (
	SubscriptionTypeID INT IDENTITY(1,1) NOT NULL,
	SubscriptionTypeCode VARCHAR(2) NOT NULL,
	SubscriptionTypeDesc VARCHAR(30) NOT NULL
	)
	
CREATE TABLE dbo.DonorSubscription (
	DonorSubscriptionID INT IDENTITY(1,1) NOT NULL,
	DonorID INT NOT NULL,
	SubscriptionID INT NOT NULL,
	StartDate DATETIME NOT NULL
	)

CREATE TABLE dbo.Donor (
	DonorID INT IDENTITY(1,1) NOT NULL,
	FirstName VARCHAR(100) NOT NULL,
	LastName VARCHAR(100) NOT NULL,
	CreatedDate DATETIME NOT NULL
	)
	
DROP TABLE IF EXISTS dbo.DonorContact
CREATE TABLE dbo.DonorContact (
	DonorContactID INT IDENTITY(1,1) NOT NULL,
	DonorID INT NOT NULL,
	ContactMethodID INT NOT NULL,
	IsPrimary BIT NOT NULL,
	ID INT NOT NULL
	)
	
CREATE TABLE dbo.DonorGiftAssoc (
	DonorGiftAssoc INT IDENTITY(1,1) NOT NULL,
	DonorID INT NOT NULL,
	GiftID INT NOT NULL
	)
	
CREATE TABLE dbo.Gift (
	GiftID INT IDENTITY(1,1) NOT NULL,
	GiftTypeID INT NOT NULL,
	SubscriptionID INT NULL,
	GiftDate DATETIME NOT NULL,
	GiftAmount DECIMAL(19,4) NOT NULL
	)
	
CREATE TABLE dbo.GiftType (
	GiftTypeID INT IDENTITY(1,1) NOT NULL,
	GiftTypeDesc VARCHAR(30) NOT NULL
	)
	
DROP TABLE IF EXISTS dbo.Campaign
CREATE TABLE dbo.Campaign ( 
	CampaignID INT IDENTITY(1,1) NOT NULL,
	CampaignTitle VARCHAR(250) NOT NULL,
	CampaignStart DATETIME NOT NULL,
	CampaignEnd DATETIME NULL
	)
	

CREATE TABLE dbo.Advertisement (
	AdvertisementID INT IDENTITY(1,1) NOT NULL,
	CampaignID INT NOT NULL,
	ContactMethodID INT NULL,
	AdvertisementTitle VARCHAR(250) NOT NULL
	)
	
CREATE TABLE dbo.AdvertisementTransaction (
	AdvertisementTransactionID INT IDENTITY(1,1) NOT NULL,
	TransactionTypeID INT NOT NULL,
	AdvertisementID INT NOT NULL,
	TransactionAmount DECIMAL(19,4) NOT NULL
	)
	
CREATE TABLE dbo.TransactionType (
	TransactionTypeID INT IDENTITY(1,1) NOT NULL,
	TransactionTypeCode VARCHAR(2) NOT NULL,
	TransactionTypeDesc VARCHAR(30) NOT NULL
	)

CREATE TABLE dbo.AdvertisementLeadAssoc (
	AdvertisementLeadAssocID INT IDENTITY(1,1) NOT NULL,
	AdvertisementID INT NOT NULL,
	LeadID INT NOT NULL
	)
	
CREATE TABLE dbo.LeadSource (
	LeadSourceID INT IDENTITY(1,1) NOT NULL,
	LeadSourceTitle VARCHAR(30) NOT NULL 
	)

DROP TABLE IF EXISTS dbo.Lead
CREATE TABLE dbo.Lead (
	LeadID INT IDENTITY(1,1) NOT NULL,
	LeadSourceID INT NULL,
	FirstName VARCHAR(100) NOT NULL,
	LastName VARCHAR(100) NOT NULL,
	CreatedDate DATETIME NOT NULL
	)

DROP TABLE IF EXISTS dbo.LeadContact
CREATE TABLE dbo.LeadContact (
	LeadContactID INT IDENTITY(1,1) NOT NULL,
	LeadID INT NOT NULL,
	ContactMethodID INT NOT NULL,
	IsPrimary BIT NOT NULL,
	ID INT NOT NULL
	)
	
CREATE TABLE dbo.ContactAttempt (
	ContactAttemptID INT IDENTITY(1,1) NOT NULL,
	AdvertisementLeadAssoc INT NOT NULL, 
	AttemptDate DATETIME NOT NULL,
	AttemptCost DECIMAL(19,4) NOT NULL
	)
	
CREATE TABLE dbo.ContactEvent (
	ContactEventID INT IDENTITY(1,1) NOT NULL, 
	EventTypeID INT NOT NULL, 
	EventDate DATETIME NOT NULL,
	ContactAttemptID INT NULL,
	WebsiteID INT NULL
	)
	
CREATE TABLE dbo.EventType (
	EventTypeID INT IDENTITY(1,1) NOT NULL,
	EventTypeName VARCHAR(30) NOT NULL
	)  

CREATE TABLE dbo.ContactMethod (
	ContactMethodID INT IDENTITY(1,1) NOT NULL,
	ContactMethodTitle VARCHAR(30) NOT NULL 
	) 

CREATE TABLE dbo.Email (
	EmailID INT IDENTITY(1,1) NOT NULL,
	EmailTypeID INT NOT NULL, 
	Email VARCHAR(100) NOT NULL
	)
	
CREATE TABLE dbo.EmailType (
	EmailTypeID INT IDENTITY(1,1) NOT NULL,
	EmailTypeDesc VARCHAR(30) NOT NULL 
	)

DROP TABLE IF EXISTS dbo.Address
CREATE TABLE dbo.Address (
	AddressID INT IDENTITY(1,1) NOT NULL,
	AddressTypeID INT NOT NULL, 
	State VARCHAR(2) NOT NULL,  
	City VARCHAR(100) NOT NULL ,
	Zip NUMERIC(5) NULL ,
	Address1 VARCHAR(250) NULL,
	Address2 VARCHAR(250) NULL
	)

CREATE TABLE dbo.AddressType (
	AddressTypeID INT IDENTITY(1,1) NOT NULL,
	AddressTypeDesc VARCHAR(30) NOT NULL 
	)

CREATE TABLE dbo.Phone (
	PhoneID INT IDENTITY(1,1) NOT NULL,
	PhoneTypeID INT NOT NULL, 
	Phone NUMERIC(12) NOT NULL
	)

CREATE TABLE dbo.PhoneType (
	PhoneTypeID INT IDENTITY(1,1) NOT NULL,
	PhoneTypeDesc VARCHAR(30) NOT NULL 
	)

DROP TABLE IF EXISTS dbo.Website
CREATE TABLE dbo.Website (
	WebsiteID INT IDENTITY(1,1) NOT NULL,
	WebsiteName VARCHAR(30) NOT NULL, 
	URL VARCHAR(MAX) NOT NULL,
	AdvertisementID INT NULL
	)