using Dash
using DashCoreComponents
using DashHtmlComponents
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "tips")

app = dash(external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"])

app.layout = html_div() do 
    html_p("Color mode: "),
    dcc_radioitems(
        id="colormode",
        value="discrete",
        options=[
            (label=x, value=x)
            for x in ["discrete", "continuous"]
        ]
    ),
    dcc_graph(id="graph")
    
end

callback!(app, Output("graph", "figure"), Input("colormode", "value")) do val
    if val == "discrete"
        fig = plot(
            df,
            mode="markers",
            x=:total_bill,
            y=:tip, 
            color=:size
        )
        return fig
    else
        fig = plot(
            df,
            mode="markers",
            x=:total_bill,
            y=:tip,
            marker=attr(
                color=Float64.(df.size),
                coloraxis="coloraxis",
                showscale=true
            ),
            Layout(coloraxis_colorscale=colors.plasma)     
        )
        return fig
    end
end

run_server(app, "0.0.0.0", 8080)
