using Dash
using DashCoreComponents
using DashHtmlComponents
using PlotlyJS

app = dash(external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"])

app.layout = html_div() do 
    dcc_graph(id="graph"),
    dcc_checklist(
        id="tick",
        options=[
            (label="Enable Linear Ticks", value="linear")
        ],
        value=["linear"]
    )
    
end

callback!(app, Output("graph", "figure"), Input("tick", "value")) do val

    fig = plot(
        scatter(
            x = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
            y = [
                    28.8, 28.5, 37, 56.8, 69.7, 79.7, 78.5, 
                    77.8, 74.1, 62.6, 45.3, 39.9
                ]
        )
    )
    if "linear" in val
        relayout!(fig, xaxis=(
            tickmode="linear",
            tick0=0.5,
            dtick=0.75
        ))
    end
    
    return fig
end

run_server(app, "0.0.0.0", 8080)
