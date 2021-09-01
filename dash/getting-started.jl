using Dash
using DashCoreComponents
using DashHtmlComponents
using PlotlyJS

app = dash(external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"])

app.layout = html_div() do
    html_p("Color:"),
    dcc_dropdown(
        id="dropdown",
        options=[
            (label=x, value=x)
            for x in ["Gold", "MediumTurquoise", "LightGreen"]
        ],
        value="Gold",
        clearable=false
    ),
    dcc_graph(id="graph")
end

callback!(app, Output("graph", "figure"), Input("dropdown", "value")) do val
    fig = plot(
        bar(
            x=[0,1,2],
            y=[2,3,1],
            marker_color=val
        )
    )
    return fig
end

run_server(app, "0.0.0.0", 8080)
