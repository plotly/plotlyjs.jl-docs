using Dash
using DashCoreComponents
using DashHtmlComponents
using PlotlyJS, CSV, DataFrames, HTTP

df = CSV.File(
    HTTP.get("https://raw.githubusercontent.com/plotly/datasets/master/2014_apple_stock.csv").body
) |> DataFrame


app = dash(external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"])

app.layout = html_div() do
    dcc_graph(id="graph"),
    html_button("Switch Axis", id="btn", n_clicks=0)
end

callback!(app, Output("graph", "figure"), Input("btn", "n_clicks")) do val

    if val % 2 == 0
        x = "AAPL_x"
        y = "AAPL_y"
    else
        x = "AAPL_y"
        y = "AAPL_x"
    end

    fig = plot(scatter(mode="lines", x=df[!,x], y=df[!, y]))
    return fig
end

run_server(app, "0.0.0.0", 8080)
