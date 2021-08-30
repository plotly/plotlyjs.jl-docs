using Dash
using DashHtmlComponents
using DashCoreComponents
using PlotlyJS, CSV, DataFrames
using Distributions
app = dash(external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"])

df = dataset(DataFrame, "stocks")

app.layout = html_div() do
    dcc_dropdown(
        id="ticker",
        options=[(label= x, value= x)
                 for x in names(df)[2:end]],
        value=names(df)[2],
        clearable=false
    ),
    dcc_graph(id="graph")
end

callback!(app, Output("graph", "figure"), Input("ticker", "value")) do ticker
    fig = plot(df, x=:date, y=df[!, ticker], mode="lines")
    return fig
end


run_server(app, "0.0.0.0", 8080)
