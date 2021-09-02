using Dash
using DashHtmlComponents
using DashCoreComponents
using PlotlyJS, CSV, DataFrames

app = dash(external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"])

df = dataset(DataFrame, "tips")

app.layout = html_div() do
    dcc_graph(id = "graph"),
    html_p("Subplots Width:"),
    dcc_slider(id="slider-width", min=0, max=1, value=0.5, step=0.01)
end

callback!(app, Output("graph", "figure"), Input("slider-width", "value")) do val
    fig = make_subplots(
        rows=1, 
        cols=2, 
        specs=[Spec(kind="scatter") Spec(kind="scatter")],
        column_widths=[val, 1-val]
    )
    add_trace!(fig, scatter(x=[1,2,3],y=[1,2,3]), row=1, col=1)
    add_trace!(fig, scatter(x=[1,2,3], y=[1,2,3]), row=1, col=2)
    return fig
end


run_server(app, "0.0.0.0", 8080)