using Dash
using DashCoreComponents
using DashHtmlComponents
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "iris")

app = dash(external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"])

app.layout = html_div() do 
    dcc_graph(id="scatter-plot"),
    html_p("Petal Width:"),
    dcc_rangeslider(
        id="range-slider",
        min=0, max=2.5, step=0.1,
        marks=Dict("0"=> "0", "2.5"=> "2.5"),
        value=[0.5, 2]
    )    
end

callback!(app, Output("scatter-plot", "figure"), Input("range-slider", "value")) do val
    low = val[1]
    high= val[2]
    mask = df[df.petal_width .> low, :]
    mask = mask[mask.petal_width .< high, :]

    fig = plot(kind="scatter3d", mode="markers", mask, x=:sepal_length, y=:sepal_width, z=:petal_width, color=:species, hover_data=[:petal_width])

    return fig
end

run_server(app, "0.0.0.0", 8080)