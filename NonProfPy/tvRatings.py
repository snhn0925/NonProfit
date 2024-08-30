import pandas as pd
import os
import seaborn as sns
import Constants
import matplotlib.pyplot as plt

myTvCsv = 'data_TV.csv'

dfTv = pd.read_csv(os.path.join(Constants.myDir, myTvCsv), delimiter= ",")

#print(dfTv.head())

dfTv = dfTv.drop(['overview'],axis=1)

print(dfTv.shape)

dfTv = dfTv.dropna()

print(dfTv.isna().sum())

dfTv['first_air_date'] = pd.to_datetime(dfTv['first_air_date'])

dfTv['first_air_date'] = dfTv['first_air_date'].dt.year

dfTv['first_air_date'] = dfTv['first_air_date'].astype(int)

dfTv = dfTv.rename(columns={'original_language' : 'Original Language'})

g = sns.scatterplot(data=dfTv, x='first_air_date',y='popularity',hue='Original Language')
plt.title('Netflix Series Popularity')
g.set(xlabel='Year first aired', ylabel='Popularity score (circa 2022)')

dfTvTop5 = dfTv.sort_values('popularity',ascending=False)[['name','popularity','first_air_date']].head(5)

for i, row in dfTvTop5.iterrows():
    g.text(x=(row['first_air_date']),y=(row['popularity']+10),s=row['name'],horizontalalignment='right')

#-(len(row['name'])*.5)
#print(dfTvTop5)

plt.show()

