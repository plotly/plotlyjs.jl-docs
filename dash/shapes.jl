using Dash
using DashCoreComponents
using DashHtmlComponents
using PlotlyJS

app = dash(external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"])

app.layout = html_div() do 
    dcc_graph(id="graph"),
    html_button("Move Up", id="btn-up", n_clicks=0),
    html_button("Move Down", id="btn-down", n_clicks=0)
end

callback!(
    app, 
    Output("graph","figure"),
    [
        Input("btn-up", "n_clicks"),
        Input("btn-down", "n_clicks")
    ]
) do n_up, n_down
    n = n_up - n_down
    fig = plot(scatter(x=[1,0,2,1], y=[2,0,n,2], fill="toself"))

    return fig
end

run_server(app, "0.0.0.0", 8080)