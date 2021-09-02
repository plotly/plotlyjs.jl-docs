using Dash
using DashHtmlComponents
using DashCoreComponents
using PlotlyJS, CSV, DataFrames

app = dash(external_stylesheets=["https://codepen.io/chriddyp/pen/bWLwgP.css"])

df = dataset(DataFrame, "iris")

app.layout = html_div() do
    dcc_graph(id="scatter-plot"),
    html_p("Petal Width:"),
    dcc_rangeslider(
        id="rangeslider",
        min=0,
        max=2.5,
        step=0.1,
        marks=Dict("0" => "0", "2.5" => "2.5"),
        value=[0.5, 2]
    )
end

callback!(app, Output("scatter-plot", "figure"), Input("rangeslider", "value")) do val
    low = val[1]
    high = val[2]
    mask = df[df.petal_width .> low, :]
    mask = mask[mask.petal_width .< high, :]
    fig = plot(mask,
        kind="scatter",
        mode="markers",
        x=:sepal_width,
        y=:sepal_length,
        color=:species,
        marker=attr(
            size=:petal_length,
            sizeref=2 * maximum(df.petal_length) / (40^2),
            sizemode="area",
        ),
    )
    return fig
end


run_server(app, "0.0.0.0", 8080)
