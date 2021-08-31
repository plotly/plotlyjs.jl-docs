using Dash
using DashCoreComponents
using DashHtmlComponents
using DashDaq
using PlotlyJS, CSV, DataFrames
df = dataset(DataFrame, "iris")

app = dash(external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"])

init_fig = plot(
    df,
    mode="markers",
    x=:sepal_length,
    y=:sepal_width,
    color=:species,
    Layout(
        height=250, 
        title_text="Playing with Fonts",
        font_family="Courier New",
        title_font_family="Times New Roman"
    )
)

picker_style = (float="left", margin="auto")

app.layout = html_div() do 
    dcc_graph(id="graph", figure=init_fig),
    daq_colorpicker(
        id="font", 
        label="Font Color",
        size=150,
        style=picker_style,
        value=(hex="#119dff",)
    ),

     daq_colorpicker(
        id="title", 
        label="Title Color",
        size=150,
        style=picker_style,
        value=(hex="#2A0203",)
    )
end

callback!(
    app, 
    Output("graph", "figure"),
    [Input("font", "value"), Input("title", "value")]
) do font, title
    fig = init_fig
    relayout!(fig, font_color=font.hex, title_font_color=title.hex)

    return fig
end

run_server(app, "0.0.0.0", 8080)
