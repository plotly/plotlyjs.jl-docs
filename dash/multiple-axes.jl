using Dash
using DashCoreComponents
using DashHtmlComponents
using PlotlyJS

app = dash(external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"])

app.layout = html_div() do 
    dcc_graph(id="graph"),
    html_p("Red line's axes"),
    dcc_radioitems(
        id="radio",
        value="Secondary",
        options=[
            (label=x, value=x)
            for x in ["Primary", "Secondary"]
        ]
    )
    
end

callback!(app, Output("graph", "figure"), Input("radio", "value")) do val

    if val == "Primary"
        fig = plot(
            [
                scatter(x=[1,2,3], y=[40, 50, 60], name="yaxis data"),
                scatter(x=[2,3,4], y=[4,5,6], name="yaxis2 data")
            ]
        )
    else
        fig = plot(
            [
                scatter(x=[1,2,3], y=[40, 50, 60], name="yaxis data"),
                scatter(
                    x=[2,3,4], 
                    y=[4,5,6], 
                    name="yaxis2 data",
                    yaxis="y2"
                )
            ],
            Layout(
                yaxis2=attr(
                    yaxis2_title="Secondary y axis",
                    overlaying="y",
                    side="right"
                )
            )
        )
    end

    relayout!(fig, title_text="Double y axis example", xaxis_title="xaxis title")

    return fig

end

run_server(app, "0.0.0.0", 8080)
