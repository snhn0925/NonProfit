import requests
import json
import pandas as pd
import re
import plotly.graph_objects as px
import Constants
import os


myCsv1 = 'ZipIncomeScore.csv'
myCsv2 = 'ZipPetScore.csv'

df = pd.read_csv(os.path.join(Constants.myDir, myCsv1), delimiter= "|",header=0)
df2 = pd.read_csv(os.path.join(Constants.myDir, myCsv2), delimiter= "|",header=0)

print(df.columns)
print(df2.columns)

df3 = df.merge(df2, on='Zip', how='inner');

print(df3[['Zip','DogParkScore','PetStoreScore','PopScore','IncScore']].head())

df3['ZipScore'] = df3.apply(lambda row: (row['DogParkScore'] + row['PopScore'] + row['IncScore'] + row['PetStoreScore'])/4, axis=1)

print(df3[['Zip','ZipScore','DogParkScore','PetStoreScore','PopScore','IncScore']].sort_values('ZipScore',ascending=False))

