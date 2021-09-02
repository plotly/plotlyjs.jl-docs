using Dash
using DashHtmlComponents
using DashCoreComponents
using PlotlyJS, CSV, DataFrames
using Distributions
app = dash(external_stylesheets=["https://codepen.io/chriddyp/pen/bWLwgP.css"])

app.layout = html_div() do
    dcc_graph(id="graph"),
    html_p("Mean:"),
    dcc_slider(
        id="mean",
        min=-3, max=3, value=0,
        marks=Dict("-3" => "-3", "3" => "3")
    ),
    html_p("Standard Deviation:"),
    dcc_slider(
        id="std",
        min=1, max=3, value=1,
        marks=Dict("1" => "1", "3" => "3")
    )
end

callback!(
    app,
    Output("graph", "figure"),
    [Input("mean", "value"), Input("std", "value")]
) do mean, std
    data = rand(Normal(mean, std), 500)
    fig = plot(histogram(
        x=data, nbins=30, range_x=[-10,10]
    ))
    return fig
end


run_server(app, "0.0.0.0", 8080)
