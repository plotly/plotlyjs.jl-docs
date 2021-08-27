using Dash
using DashHtmlComponents
using DashCoreComponents
using PlotlyJS, CSV, DataFrames

app = dash(external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"])

df = dataset(DataFrame, "gapminder")
continents = unique(df.continent)

app.layout = html_div() do
    dcc_checklist(
        id="checklist", 
        options=[(label=x, value=x) for x in continents], 
        labelStyle=(display="inline-block",), 
        value=["Europe", "Oceania"]
    ),
    dcc_graph(id = "linechart")
end

callback!(app, Output("linechart", "figure"), Input("checklist", "value")) do val
    mask = df[ [x in val for x in df.continent], :]
    fig = plot(
        mask, kind="line", mode="lines", 
        x=:year, y=:lifeExp, color=:country, 
    )
    return fig
end


run_server(app, "0.0.0.0", 8080) 
