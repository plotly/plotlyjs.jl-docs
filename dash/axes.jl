using Dash
using DashHtmlComponents
using DashCoreComponents
using PlotlyJS, CSV, DataFrames

app = dash(external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"])

df = dataset(DataFrame, "tips")

app.layout = html_div() do
    dcc_graph(id = "graph"),
    html_button("Rotate", id="button", n_clicks=0)
end

callback!(app, Output("graph", "figure"), Input("button", "n_clicks")) do val
   fig = plot(df, x=:sex, height=500, kind="histogram")
   update_xaxes!(fig, tickangle=val*45)
   return fig
end


run_server(app, "0.0.0.0", 8080)