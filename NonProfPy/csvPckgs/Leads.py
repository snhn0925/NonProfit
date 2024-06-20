import pandas as pd
import os


def loadLeadsCSV(cnxn, myDir):

    myLeadsCsv = 'Leads.csv'
    
    cursor = cnxn.cursor()

    dfLeads = pd.read_csv(os.path.join(myDir, myLeadsCsv), delimiter= "|")
    #print(dfLeads.head())

    dfLeads[['Zip','Phone']]  =  dfLeads[['Zip','Phone']].fillna(value=0)

    dfLeads = dfLeads.astype({
        'FirstName':str,
        'LastName':str,
        'EmailTypeDesc':str,
        'Email':str,
        'AddressTypeDesc':str,
        'State':str,
        'City':str,
        'Zip':int,
        'Address1':str,
        'Address2':str,
        'PhoneTypeDesc':str,
        'Phone':int,
        'LeadSourceTitle':str})

    #print(dfLeads.dtypes)

    for index,row in dfLeads.iterrows():
        cursor.execute("""\
    INSERT stg.LeadInfo (
        FirstName,
        LastName,
        EmailTypeDesc,
        Email,
        AddressTypeDesc,
        State,
        City,
        Zip,
        Address1,
        Address2,
        PhoneTypeDesc,
        Phone,
        LeadSourceTitle)
        VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?);""",
        (row.FirstName,
        row.LastName,
        row.EmailTypeDesc,
        row.Email,
        row.AddressTypeDesc,
        row.State,
        row.City,
        row.Zip,
        row.Address1,
        row.Address2,
        row.PhoneTypeDesc,
        row.Phone,
        row.LeadSourceTitle)
        )

    cnxn.commit()
