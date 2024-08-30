import numpy as np
import pandas as pd
import Constants
import pyodbc
from sklearn.linear_model import LinearRegression
import matplotlib.pyplot as plt


cnxn = pyodbc.connect(Constants.cnxnString)

cursor = cnxn.cursor()

sql = """SELECT d.FirstName, DATEDIFF(YEAR,d.DateOfBirth,GETDATE()) AS Age, SUM(g.GiftAmount) AS TotalGiven
FROM dbo.Donor d
JOIN dbo.DonorGiftAssoc dga ON d.DonorID = dga.DonorID
JOIN dbo.Gift g ON dga.GiftID = g.GiftID
GROUP BY d.FirstName, DATEDIFF(YEAR,d.DateOfBirth,GETDATE())"""

data = pd.read_sql(sql,cnxn)

#print(data)

x = np.array(data['Age']).reshape((-1,1))
y = np.array(data['TotalGiven'])

print(x)
print(y)

model = LinearRegression().fit(x, y)

x_new = np.linspace(0, 150, 100)

y_new = model.predict(x_new[:, np.newaxis])

r_sq = model.score(x, y)
#print(f"coefficient of determination: {r_sq}")
#print(f"intercept: {model.intercept_}")
#print(f"slope: {model.coef_}")

#plt.figure(figsize=(4, 3))
ax = plt.axes()
ax.scatter(x, y)
ax.plot(x_new, y_new)

ax.set_xlabel('Age')
ax.set_ylabel('Total Amount Given ($)')

plt.title("Lifetime Gift Totals by Age of Donor")

ax.axis('tight')

plt.annotate("r-squared = " + str(r_sq), xy =(1, 20000000))

plt.show()
