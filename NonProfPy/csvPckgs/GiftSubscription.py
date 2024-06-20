import pandas as pd
import os


def loadGiftSubscriptionCSV(cnxn, myDir):

    myGiftSubscriptionCsv = 'GiftSubscription.csv'
    
    cursor = cnxn.cursor()

    dfGiftSubscription = pd.read_csv(os.path.join(myDir, myGiftSubscriptionCsv), delimiter= "|")
    #print(dfGiftSubscription.head())

    dfGiftSubscription['StartDate']  =  dfGiftSubscription['StartDate'].fillna(value='01/01/1900')
    dfGiftSubscription['SubscriptionAmount']  =  dfGiftSubscription['SubscriptionAmount'].fillna(value=0)
    dfGiftSubscription['SubscriptionTypeCode']  =  dfGiftSubscription['SubscriptionTypeCode'].fillna(value='Na')

    dfGiftSubscription = dfGiftSubscription.astype({
        'FirstName':str,
        'LastName':str,
        'GiftTypeDesc':str,
        'GiftDate':str,
        'GiftAmount':float,
        'SubscriptionName':str,
        'SubscriptionTypeCode':str,
        'SubscriptionTypeDesc':str,
        'StartDate':str,
        'SubscriptionAmount':float})

    #print(dfGiftSubscription.dtypes)

    for index,row in dfGiftSubscription.iterrows():
        cursor.execute("""\
    INSERT stg.GiftSubscriptionInfo (
        FirstName,
        LastName,
        GiftTypeDesc,
        GiftDate,
        GiftAmount,
        SubscriptionName,
        SubscriptionTypeCode,
        SubscriptionTypeDesc,
        StartDate,
        SubscriptionAmount)
        VALUES (?,?,?,?,?,?,?,?,?,?);""",
        (row.FirstName,
        row.LastName,
        row.GiftTypeDesc,
        row.GiftDate,
        row.GiftAmount,
        row.SubscriptionName,
        row.SubscriptionTypeCode,
        row.SubscriptionTypeDesc,
        row.StartDate,
        row.SubscriptionAmount)
        )

    cnxn.commit()
