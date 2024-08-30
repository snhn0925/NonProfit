import numpy as np
import pandas as pd
import Constants
import pyodbc

cnxn = pyodbc.connect(Constants.cnxnString)

cursor = cnxn.cursor()

sql = """SELECT d.FirstName, DATEDIFF(YEAR,d.DateOfBirth,GETDATE()) AS Age, SUM(g.GiftAmount) AS TotalGiven
FROM dbo.Donor d
JOIN dbo.DonorGiftAssoc dga ON d.DonorID = dga.DonorID
JOIN dbo.Gift g ON dga.GiftID = g.GiftID
GROUP BY d.FirstName, DATEDIFF(YEAR,d.DateOfBirth,GETDATE())"""

data = pd.read_sql(sql,cnxn)

print(data)