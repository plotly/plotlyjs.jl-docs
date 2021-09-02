using Dash
using DashCoreComponents
using DashHtmlComponents
using PlotlyJS, HTTP, DataFrames, CSV

df = CSV.File(
    HTTP.get("https://raw.githubusercontent.com/plotly/datasets/master/finance-charts-apple.csv").body
) |> DataFrame

app = dash(external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"])

app.layout = html_div() do 
    dcc_checklist(
        id="toggle-rangeslider",
        options=[
            (label="Include Rangeslider", value="slider")
        ],
        value=["slider"],
    ),
    dcc_graph(id="graph")
end


callback!(app, Output("graph", "figure"), Input("toggle-rangeslider", "value")) do val
    fig = plot(
        df,
        kind="candlestick",
        x=:Date,
        open=df[!, "AAPL.Open"],
        high=df[!, "AAPL.High"],
        close=df[!, "AAPL.Close"],
        low=df[!, "AAPL.Low"]
    )

    relayout!(fig, xaxis_rangeslider_visible=("slider" in val))

    return fig
end

run_server(app, "0.0.0.0", 8080)
