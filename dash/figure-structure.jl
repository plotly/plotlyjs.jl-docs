using Dash
using DashCoreComponents
using DashHtmlComponents
using PlotlyJS
using JSON

app = dash(external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"])

fig = plot(
    scatter(        
        x=["a","b","c"],
        y=[1,2,3],
    ),
    Layout(title="Sample figure", height=325)
)

app.layout = html_div() do 
    dcc_graph(id="graph", figure=fig),
    html_pre(
        id="structure",
        style=(
            border="thin lightgrey solid",
            overflowY="scroll",
            height="275px"
        )
    )
end

callback!(app, Output("structure", "children"), Input("graph", "figure")) do val
    return json(val, 2)
end

run_server(app, "0.0.0.0", 8080)
