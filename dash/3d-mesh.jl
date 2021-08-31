using Dash
using DashCoreComponents
using DashHtmlComponents
using PlotlyJS, CSV, HTTP, DataFrames

base_url = "https://raw.githubusercontent.com/plotly/datasets/master/ply/"
mesh_names = ["sandal", "scissors", "shark", "walkman"]
dataframes = Dict(
    name => (CSV.File(HTTP.get(string(base_url, name, "-ply.csv")).body) |> DataFrame)
    for name in mesh_names
)

app = dash(external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"])

app.layout = html_div() do 
    html_p("Choose an object"),
    dcc_dropdown(
        id="dropdown",
        options=[
            (label=x, value=x)
            for x in mesh_names
        ],
        value=mesh_names[1], 
        clearable=false
    ),
    dcc_graph(id="graph")
    
end

callback!(app, Output("graph", "figure"), Input("dropdown", "value")) do val
    df = dataframes[val]
    fig = plot(
        df, 
        kind="mesh3d",
        x=:x, y=:y, z=:z,
        i=:i, j=:j, k=:k,
        facecolor=:facecolor
    )

    return fig
end

run_server(app, "0.0.0.0", 8080)
