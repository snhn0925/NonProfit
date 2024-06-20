import pandas as pd
import os


def loadCampaignTransactionsCSV(cnxn, myDir):

    myCampaignTransactionsCsv = 'CampaignTransactions.csv'
    
    cursor = cnxn.cursor()

    dfCampaignTransactions = pd.read_csv(os.path.join(myDir, myCampaignTransactionsCsv), delimiter= "|")
    #print(dfCampaignTransactions.head())
    
    #print(dfCampaignTransactions.dtypes)

    dfCampaignTransactions[['CampaignStart','CampaignEnd']]  =  dfCampaignTransactions[['CampaignStart','CampaignEnd']].fillna(value='01/01/1900')

    dfCampaignTransactions = dfCampaignTransactions.astype({
       'CampaignTitle':str,
       'CampaignStart':str,
       'CampaignEnd':str,
       'AdvertisementTitle':str,
       'ContactMethodTitle':str,
       'TransactionAmount':float,
       'TransactionTypeCode':str,
       'TransactionTypeDesc':str})


    for index,row in dfCampaignTransactions.iterrows():
       cursor.execute("""\
    INSERT stg.CampaignTransactionInfo (
       CampaignTitle,
       CampaignStart,
       CampaignEnd,
       AdvertisementTitle,
       ContactMethodTitle,
       TransactionAmount,
       TransactionTypeCode,
       TransactionTypeDesc)
       VALUES (?,?,?,?,?,?,?,?);""",
       (row.CampaignTitle,
       row.CampaignStart,
       row.CampaignEnd,
       row.AdvertisementTitle,
       row.ContactMethodTitle,
       row.TransactionAmount,
       row.TransactionTypeCode,
       row.TransactionTypeDesc)
       )

    cnxn.commit()
   
