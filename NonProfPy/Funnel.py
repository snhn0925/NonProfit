import pandas as pd
import plotly.express as px
import Constants
import os


myCsv = 'Funnel.csv'

df = pd.read_csv(os.path.join(Constants.myDir, myCsv), delimiter= "|")

print(df.head())

df2 = df.melt(id_vars='Website',var_name='Stage',value_name='value')

print(df2.head())

fig = px.funnel(df2, x=df2['value'],y=df2['Stage'],color=df2['Website'])

fig.show()