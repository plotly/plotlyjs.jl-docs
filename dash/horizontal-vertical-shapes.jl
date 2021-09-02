using Dash
using DashHtmlComponents
using DashCoreComponents
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "iris")



app = dash(external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"])

app.layout = html_div() do 
    dcc_graph(id="graph"),
    html_p("Position of vline"),
    dcc_slider(
        id="slider-position",
        min=1, max=7, value=2.5, step=0.1,
        marks=Dict("1"=>"1", "7" => "7")
        )
    end
    
callback!(app, Output("graph", "figure"), Input("slider-position", "value")) do val
    p = plot(df, kind="scatter", mode="markers", x=:petal_length, y=:petal_width)
    
    add_vline!(p, val, line_width=3, line_dash="dash", line_color="green")
    add_hrect!(p, 0.9, 2.6, line_width=0, fillcolor="red", opacity=0.2)
    return p
end

run_server(app, "0.0.0.0", 8080)
