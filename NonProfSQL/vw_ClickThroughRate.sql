CREATE VIEW vw_ClickThroughRate
AS
SELECT w.WebsiteName,
	w.URL,
	SUM(CASE WHEN et.EventTypeName = 'View' THEN 1 ELSE 0 END) AS VisitCnt,
	SUM(CASE WHEN et.EventTypeName = 'Click' THEN 1 ELSE 0 END) AS ClickCnt,
	CAST(((CAST(SUM(CASE WHEN et.EventTypeName = 'Click' THEN 1 ELSE 0 END) AS NUMERIC(10,2))/
	CAST(SUM(CASE WHEN et.EventTypeName = 'View' THEN 1 ELSE 0 END) AS NUMERIC(10,2)))*100) AS NUMERIC(10,2)) AS ClickThroughRate
FROM dbo.Website w
JOIN dbo.ContactEvent ce ON w.WebsiteID = ce.WebsiteID
JOIN dbo.EventType et ON ce.EventTypeID = et.EventTypeID
GROUP BY w.WebsiteName, w.URL