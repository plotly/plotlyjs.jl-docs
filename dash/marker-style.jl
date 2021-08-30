using Dash
using DashCoreComponents
using DashDaq
using DashHtmlComponents
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "iris")

app = dash(external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"])

default_fig = plot(
    df,
    mode="markers",
    x=:sepal_width,
    y=:sepal_length,
    color=:species,
    marker_size=12,
    Layout(
        height=350
    )
)
app.layout = html_div() do 
    dcc_graph(id="graph", figure=default_fig),
    daq_colorpicker(
        id="color",
        label="Border Color",
        value=(hex="#2f4f4f",),
        size=164
    )


end

callback!(app, Output("graph", "figure"), Input("color", "value")) do val
    fig = default_fig
    restyle!(
        fig, 
        marker_size=12, 
        marker_line=attr(width=2, color=val.hex), 
    )
    return fig
end

run_server(app, "0.0.0.0", 8080)
