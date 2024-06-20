import pandas as pd
import os


def loadAttemptsEventsCSV(cnxn, myDir):

    myAttemptsEventsCsv = 'AttemptsEvents.csv'
    
    cursor = cnxn.cursor()

    dfAttemptsEvents = pd.read_csv(os.path.join(myDir, myAttemptsEventsCsv), delimiter= "|")
    #print(dfAttemptsEvents.head())

    dfAttemptsEvents[['AttemptDate','EventDate']]  =  dfAttemptsEvents[['AttemptDate','EventDate']].fillna(value='01/01/1900')
    dfAttemptsEvents['AttemptCost']  =  dfAttemptsEvents['AttemptCost'].fillna(value=0)

    dfAttemptsEvents = dfAttemptsEvents.astype({
        'FirstName':str,
        'LastName':str,
        'AdvertisementTitle':str,
        'AttemptCost':float,
        'AttemptDate':str,
        'EventDate':str,
        'EventTypeName':str,
        'URL':str,
        'WebsiteName':str})

    #print(dfAttemptsEvents.dtypes)

    for index,row in dfAttemptsEvents.iterrows():
        cursor.execute("""\
    INSERT stg.AttemptsEventsInfo (
        FirstName,
        LastName,
        AdvertisementTitle,
        AttemptCost,
        AttemptDate,
        EventDate,
        EventTypeName,
        URL,
        WebsiteName)
        VALUES (?,?,?,?,?,?,?,?,?);""",
        (row.FirstName,
        row.LastName,
        row.AdvertisementTitle,
        row.AttemptCost,
        row.AttemptDate,
        row.EventDate,
        row.EventTypeName,
        row.URL,
        row.WebsiteName)
        )

    cnxn.commit()
