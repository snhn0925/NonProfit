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

dfDogPark = pd.DataFrame({'name': pd.Series(dtype='str'),
                   'lat': pd.Series(dtype='str'),
                   'lng': pd.Series(dtype='str'),
                   'zip': pd.Series(dtype='str'),
                   'parkrating': pd.Series(dtype='float')})

dfPetStore = pd.DataFrame({'name': pd.Series(dtype='int'),
                   'lat': pd.Series(dtype='str'),
                   'lng': pd.Series(dtype='str'),
                   'zip': pd.Series(dtype='str')})

#df["DogParkrating"] = ""
#df["PetStoreCount"] = ""

#search_query = "Dog park"

api_key = "AIzaSyDR76CV1Vf6YBQHsfd6MBEEZLuCTc0dKGA"

search_url = "https://maps.googleapis.com/maps/api/place/textsearch/json?parameters"

details_url = "https://maps.googleapis.com/maps/api/place/details/json?parameters"
# Parameters in a dictionary

for index, row in df.iterrows():
    
    search_query = "Dog park"
    
    params = {
    "query": search_query,
    "location":row['location'],
    "radius": 100000,
    #"type": "park",
    "key": api_key
    }
    
    # Send request and capture response
    response = requests.get(search_url, params=params)
    
    dpPlaces = response.json()
    
    dfParks = pd.json_normalize(dpPlaces['results'])
    #print(df.head())
    #print(dfParks[['rating','user_ratings_total','formatted_address']].head())
    
    print(dfParks.columns)
    
    dfParks['zip'] = dfParks['formatted_address'].apply(lambda x: re.sub('[^0-9]','', x)[-5:])
    
    dfParks['lat'] = dfParks['geometry.location.lat'].astype(str)
    
    dfParks['lng'] = dfParks['geometry.location.lng'].astype(str)
    
    #dfParks['location'] = dfParks[['lat', 'lng']].agg(','.join, axis=1)
    
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
    
    dfParks['parkrating'] = dfParks['rating'].mul(dfParks['user_ratings_total'])

    print(dfParks[['name','lat','lng','zip','parkrating']].head())
    
    dfParkStg = dfParks[['name','lat','lng','zip','parkrating']]
    
    #df.loc[df['zip'] == row['zip'], 'DogParkrating'] = dfParks['Parkrating'].sum()
    
    #print( df.loc[df['zip'] == row['zip'], ['zip','DogParkrating']])
    
    dfDogPark = dfDogPark._append(dfParkStg, ignore_index=True)
    
    print(dfDogPark.tail(5))
    
    del dfParks
    
    del dfParkStg
    
    search_query = "Pet store"
    
    params = {
    "query": search_query,
    "location":row['location'],
    "radius": 100000,
    #"type": "park",
    "key": api_key
    }
    # Send request and capture response
    response = requests.get(search_url, params=params)
    
    psPlaces = response.json()
    dfStores = pd.json_normalize(psPlaces['results'])
    #print(df.head())
    #print(dfParks[['rating','user_ratings_total','formatted_address']].head())
    
    dfStores['zip'] = dfStores['formatted_address'].apply(lambda x: re.sub('[^0-9]','', x)[-5:])
    
    dfStores['lat'] = dfStores['geometry.location.lat'].astype(str)
    
    dfStores['lng'] = dfStores['geometry.location.lng'].astype(str)
    
    #dfStores['location'] = dfStores[['lat', 'lng']].agg(','.join, axis=1)

    print(dfStores[['name','lat','lng','zip']].head())
    
    dfStoreStg = dfStores[['name','lat','lng','zip']]
    
    #df.loc[df['zip'] == row['zip'], 'DogParkrating'] = dfParks['Parkrating'].sum()
    
    #print( df.loc[df['zip'] == row['zip'], ['zip','DogParkrating']])
    
    dfPetStore = dfPetStore._append(dfStoreStg, ignore_index=True)
    
    print(dfPetStore.tail(5))
    
    del dfStores
    
    del dfStoreStg



dfDogPark.drop_duplicates()
dfPetStore.drop_duplicates()

   
#print("C:/Users/sky031891/Documents/KnowledgeBase/NonProfit/NonProfPy/NonProfCSV/")


dpOutName = "DogParks.csv"

dpOutDir = './dir'
if not os.path.exists(dpOutDir):
    os.mkdir(dpOutDir)

dpfullname = os.path.join(dpOutDir, dpOutName)    

dfDogPark.to_csv(dpfullname)


psOutName = "PetStores.csv"

psOutDir = './dir'
if not os.path.exists(psOutDir):
    os.mkdir(psOutDir)

psfullname = os.path.join(psOutDir, psOutName)    

dfPetStore.to_csv(psfullname)
