import requests
import json
import pandas as pd
import re
import plotly.graph_objects as px
import Constants
import os


myCsv = 'ZipDataSet.csv'

df = pd.read_csv(os.path.join(Constants.myDir, myCsv), delimiter= "|")



df['location'] = df[['latitude','longitude']].apply(
    lambda x: ','.join(x.dropna().astype(str)),
    axis=1
)
df

print(df.head())

df["DogParkrating"] = ""
df["PetStoreCount"] = ""

search_query = "Dog park"


api_key = "AIzaSyDR76CV1Vf6YBQHsfd6MBEEZLuCTc0dKGA"

search_url = "https://maps.googleapis.com/maps/api/place/textsearch/json?parameters"

details_url = "https://maps.googleapis.com/maps/api/place/details/json?parameters"
# Parameters in a dictionary

for index, row in df.iterrows():
    params = {
    "query": search_query,
    "location":row['location'],
    "radius": 100000,
    #"type": "park",
    "key": api_key
    }
# Send request and capture response
    response = requests.get(search_url, params=params)
    
    places = response.json()
    dfParks = pd.json_normalize(places['results'])
    #print(df.head())
    #print(dfParks[['rating','user_ratings_total','formatted_address']].head())
    
    dfParks['zip'] = dfParks['formatted_address'].apply(lambda x: re.sub('[^0-9]','', x)[-5:])
    
    # Defining all the conditions inside a function
    def translateRating(x):
        if x>=4:
            return 2
        elif x>=3:
            return 1
        elif x>=2:
            return -1
        else:
            return -2
    
    dfParks['rating'] = dfParks['rating'].apply(translateRating)
    
    dfParks['Parkrating'] = dfParks['rating'].mul(dfParks['user_ratings_total'])

    print(dfParks[['zip','Parkrating','formatted_address']].head())
    
    df.loc[df['zip'] == row['zip'], 'DogParkrating'] = dfParks['Parkrating'].sum()
    
    print( df.loc[df['zip'] == row['zip'], ['zip','DogParkrating']])
    
search_query = "Pet store"
    
for index, row in df.iterrows():
    params = {
    "query": search_query,
    "location":row['location'],
    "radius": 100000,
    #"type": "park",
    "key": api_key
    }
    # Send request and capture response
    response = requests.get(search_url, params=params)
    
    places = response.json()
    dfStores = pd.json_normalize(places['results'])
    #print(df.head())
    #print(dfParks[['rating','user_ratings_total','formatted_address']].head())
    
    dfStores['zip'] = dfStores['formatted_address'].apply(lambda x: re.sub('[^0-9]','', x)[-5:])
    
    dfStores["count"] = dfStores.groupby(["zip"])["formatted_address"].transform("count")

    
    #print(dfStores[['zip','count']].head())
    
    df.loc[df['zip'] == row['zip'], 'count'] = dfStores['count'].sum()
    
    print( df.loc[df['zip'] == row['zip'], ['zip','count']])

   # print(dfStores[['zip','PetSoreCnt']].head())
    

   
print("C:/Users/sky031891/Documents/KnowledgeBase/NonProfit/NonProfPy/NonProfCSV/")

outname = "googleResults.csv"
outdir = './dir'
if not os.path.exists(outdir):
    os.mkdir(outdir)

fullname = os.path.join(outdir, outname)    

df.to_csv(fullname)
