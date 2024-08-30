import pandas as pd
import os
import seaborn as sns
import Constants
import matplotlib.pyplot as plt

myCsv = 'LeadScore.csv'

df = pd.read_csv(os.path.join(Constants.myDir, myCsv), delimiter= "|")

print(df.head())

rowdrop = df[((df['Past Donations (25%)'] == '25%'))].index

df.drop(rowdrop, inplace=True)

df.set_index(df.columns[0],inplace=True)

df = df.astype({
        'Lead Score':float,
        'Past Donations (25%)':float,
        'Contact Info (15%)':float,
        'Occupation (15%)':float,
        'Media Views (15%)':float,
        'Event Attendance (10%)':float,
        'Engagement (10%)':float,
        'Source (10%)':float})

print(df.head())
print(df.dtypes)
g = sns.heatmap(df, cmap="coolwarm", linewidth=.5)
g.xaxis.tick_top()
g.axvline(x=1, linewidth=2, color="black")
plt.xticks(rotation=30)
plt.tight_layout()
plt.show()





