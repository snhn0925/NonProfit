import requests
import json
import pandas as pd
import re
import Constants
import os



zCsv = 'ZipDataSet.csv'
iCsv = 'ZipIncomeScore2.csv'
dpCsv = 'DogParks.csv'
psCsv = 'PetStores.csv'
zCsvext = 'ZipDataSetExt.csv'

zDf = pd.read_csv(os.path.join(Constants.myDir, zCsv), delimiter= "|",header=0)
dpDf = pd.read_csv(os.path.join(Constants.myDir, dpCsv), delimiter= ",",header=0)
psDf = pd.read_csv(os.path.join(Constants.myDir, psCsv), delimiter= ",",header=0)
iDf = pd.read_csv(os.path.join(Constants.myDir, iCsv), delimiter= "|",header=0)
zextDf = pd.read_csv(os.path.join(Constants.myDir, zCsvext), delimiter= "|",header=0)

print(zDf.columns)
print(dpDf.columns)
print(psDf.columns)
print(iDf.columns)

dpDf.drop_duplicates()

psDf.drop_duplicates()

#zDf['latitude'] = zDf['latitude'].astype(str)
#zDf['longitude'] = zDf['longitude'].astype(str)
#dpDf['lat'] = dpDf['lat'].astype(str)
#dpDf['lng'] = dpDf['lng'].astype(str)
#psDf['lat'] = psDf['lat'].astype(str)
#psDf['lng'] = psDf['lng'].astype(str)
#
#zDf['location'] =  zDf[['latitude', 'longitude']].agg(','.join, axis=1)
#dpDf['location'] =  dpDf[['lat', 'lng']].agg(','.join, axis=1)
#psDf['location'] =  psDf[['lat', 'lng']].agg(','.join, axis=1)

print(zDf.head())
print(dpDf.head())
print(psDf.head())
print(iDf.head())

iDf.rename(columns={'Zip': 'zip'}, inplace=True)

zdpDf = zDf.merge(dpDf, how='cross')

zdpDf.drop_duplicates()

def scoreDistance(x):
        if x<=5:
            return 3
        elif x<=10:
            return 2
        elif x<=25:
            return 1
        else:
            return 0
        
    
def dogParkTranslate(x):
        if x>=1000000:
            return 10
        elif x>=800000:
            return 9
        elif x>=600000:
            return 8
        elif x>=500000:
            return 7
        elif x>=300000:
            return 6
        elif x>=100000:
            return 5
        elif x>=75000:
            return 4
        elif x>=50000:
            return 3
        elif x>=25000:
            return 2
        else:
            return 1
        

def petStoreTranslate(x):
        if x>=3000:
            return 10
        elif x>=2500:
            return 9
        elif x>=1700:
            return 8
        elif x>=1500:
            return 7
        elif x>=1000:
            return 6
        elif x>=500:
            return 5
        elif x>=300:
            return 4
        elif x>=200:
            return 3
        elif x>=100:
            return 2
        else:
            return 1

print(zdpDf.head()) 

zdpDf['distance'] = zdpDf.apply(lambda x: Constants.distance(origin=[x.latitude,x.longitude],destination=[x.lat,x.lng]),axis=1)
#print(zdpDf.head())

zdpDf['distanceScore'] = zdpDf.apply(lambda x: scoreDistance(x.distance),axis=1)
#print(zdpDf.head())

zdpDf['parkScore'] = zdpDf.apply(lambda x: x.distanceScore*x.parkrating,axis=1)
#print(zdpDf.head())

zdpDf = zdpDf[zdpDf.parkScore > 0]

zdpDfagg = zdpDf.groupby(['zip_x'])['parkScore'].agg('sum').reset_index(name="dogParkScore")

#zdpDf[['location_x','location_y']].apply(lambda x: print(x['location_x'],x['location_y'],),axis=1)

print(zdpDfagg.head())


zpsDf = zDf.merge(psDf, how='cross')

zpsDf.drop_duplicates()

#print(zpsDf.head()) 

zpsDf['distance'] = zpsDf.apply(lambda x: Constants.distance(origin=[x.latitude,x.longitude],destination=[x.lat,x.lng]),axis=1)
#print(zdpDf.head())

zpsDf['distanceScore'] = zpsDf.apply(lambda x: scoreDistance(x.distance),axis=1)
print(zpsDf.head())

#zpsDf = zpsDf[zpsDf.distanceScore > 0]

zpsDfagg = pd.DataFrame({'zip': pd.Series(dtype='int'),
                   'distanceScore': pd.Series(dtype='str')})

zpsDfagg = zpsDf.groupby(['zip_x'])['distanceScore'].agg('sum').reset_index(name="petStoreScore")
#print(zpsDfagg.head())

#zdpDf[['location_x','location_y']].apply(lambda x: print(x['location_x'],x['location_y'],),axis=1)

#print(zpsDfagg.head())

zdpDfagg.rename(columns={'zip_x': 'zip'}, inplace=True)
zpsDfagg.rename(columns={'zip_x': 'zip'}, inplace=True)

print(zdpDfagg.head())
print(zpsDfagg.head())


zDf2 = zDf.merge(zdpDfagg, how='inner')
zDf3 = zDf2.merge(zpsDfagg, how='inner')
sdf = iDf.merge(zDf3, how='inner')
print(sdf.loc[-2:].describe().transpose())

sdf['dogParkFinalScore'] = sdf.apply(lambda x: dogParkTranslate(x.dogParkScore),axis=1)
sdf['petStoreFinalScore'] = sdf.apply(lambda x: petStoreTranslate(x.petStoreScore),axis=1)



sdf['ZipScore'] = sdf.apply(lambda row: ((row['dogParkFinalScore']*1.5) + (row['Pop Score']*.75) + (row['Inc Score']) + (row['petStoreFinalScore']*1.25))/4.5, axis=1)

zextDf = zextDf[['zip','primary_city']]

sdf = sdf.merge(zextDf, how='inner')

print(sdf[['zip','primary_city','ZipScore','dogParkFinalScore','petStoreFinalScore','Inc Score','Pop Score']].sort_values('ZipScore',ascending=False))

zcrOutName = "ZipCodesRanked2.csv"

zcrOutDir = './dir'
if not os.path.exists(zcrOutDir):
    os.mkdir(zcrOutDir)

zcrfullname = os.path.join(zcrOutDir, zcrOutName)    

sdf.to_csv(zcrfullname)