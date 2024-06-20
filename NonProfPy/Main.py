import pyodbc
import Constants
from csvPckgs.Leads import loadLeadsCSV
from csvPckgs.CampaignTransactions import loadCampaignTransactionsCSV
from csvPckgs.GiftSubscription import loadGiftSubscriptionCSV
from csvPckgs.AttemptsEvents import loadAttemptsEventsCSV

cnxn = pyodbc.connect(Constants.cnxnString)

loadLeadsCSV(cnxn=cnxn,myDir=Constants.myDir)

loadCampaignTransactionsCSV(cnxn=cnxn,myDir=Constants.myDir)

loadGiftSubscriptionCSV(cnxn=cnxn,myDir=Constants.myDir)

loadAttemptsEventsCSV(cnxn=cnxn,myDir=Constants.myDir)
