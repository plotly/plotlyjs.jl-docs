using Dash
using DashCoreComponents
using DashHtmlComponents
using PlotlyJS

app = dash(external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"])

app.layout = html_div() do 
    dcc_graph(id="graph", figure=plot(
        bar(
            x=[0,1,2],
            y=[2,1,3]
        )
    ))
end

run_server(app, "0.0.0.0", 8080, debug=true)