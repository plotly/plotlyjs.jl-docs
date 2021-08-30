using Dash
using DashHtmlComponents
using DashCoreComponents
using PlotlyJS, CSV, DataFrames

app = dash(external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"])

df = dataset(DataFrame, "tips")
days = unique(df.day)

app.layout = html_div() do
    dcc_dropdown(id="dropdown", options=[(label=x, value=x) for x in days], value=days[1]),
    dcc_graph(
        id = "barchart"
    )
end

callback!(app, Output("barchart", "figure"), Input("dropdown", "value")) do val
   mask = df[df.day .== val, :]
   fig = plot(mask, kind="bar", x=:sex, y=:total_bill, color=:smoker, barmode="group")
   return fig
end


run_server(app, "0.0.0.0", 8080)
