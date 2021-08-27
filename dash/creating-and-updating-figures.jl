using Dash
using DashHtmlComponents
using DashCoreComponents
using PlotlyJS, CSV, DataFrames
using JSON

app = dash(external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"])

df = dataset(DataFrame, "tips")

fig = plot(
    scatter(mode="lines", x=["a","b","c"], y=[1,3,2]), 
    Layout(title="sample figure", height=325, template=Template())
)

app.layout = html_div() do
    dcc_graph(id = "graph", figure=fig),
    html_pre(
        id="structure",
        style=Dict(
            "border"=>"thin lightgrey solid", 
            "overflowY"=>"scroll",
            "height"=>"275px"
        )
    )
end

# TODO: Can't pretty print json
callback!(app, Output("structure", "children"), Input("graph", "figure")) do val
    return json(val, 2)
end


run_server(app, "0.0.0.0", 8080)
