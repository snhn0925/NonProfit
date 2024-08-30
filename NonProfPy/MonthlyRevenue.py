import yfinance as yf
from plotly.subplots import make_subplots
import plotly.graph_objects as go

colors = {
    "background": "#f5f5f5",
    "text": "#000000"
}

df = yf.download("AAPL", start="2021-01-01", end="2022-07-01")
df.reset_index(inplace=True)

def get_stock_price_fig(df):
    
    fig = make_subplots(specs=[[{"secondary_y": True}]])
    
    
    fig.add_trace(go.Bar(
        x=df["Date"],
        y=df["Volume"],
        name='Volume',
    ), secondary_y=False)

    fig.add_trace(go.Line(
        x=df["Date"],
        y=df["Close"],
        name='Close',
    ), secondary_y=True)

    fig.update_layout(
        plot_bgcolor=colors['background'],
        paper_bgcolor=colors['background'],
        font_color=colors['text']
    )
    fig.update_xaxes(
        rangeslider_visible=False,

        rangeselector=dict(
            buttons=
                list([
                dict(count=14, label="2w", step="day", stepmode="backward"),
                dict(count=30, label="1m", step="day", stepmode="backward"),
                dict(count=6, label="6m", step="month", stepmode="backward"),
                dict(count=1, label="1y", step="year", stepmode="backward"),
                dict(count=1, label="YTD", step="year", stepmode="todate"),
                dict(step="all",stepmode="backward"),
                #dict(count=1, label="1m", step="month", stepmode="backward"),
                ]

                )

        ))

    fig.update_xaxes(showgrid=True)
    #fig.update_xaxes(showgrid=True, tickfont_family="Arial Black")
    fig.update_yaxes()
    fig.update_layout(template="plotly_white")

    return fig

get_stock_price_fig(df)