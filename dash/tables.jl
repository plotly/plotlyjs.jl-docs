using Dash
using DashHtmlComponents
using DashCoreComponents
using DashTable
using HTTP
using PlotlyJS, CSV, DataFrames
using Distributions

app = dash(external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"])

data_url = "https://raw.githubusercontent.com/plotly/datasets/master/2014_usa_states.csv"

df = CSV.File(
    HTTP.get(data_url).body
) |> DataFrame

df_dict = [Dict(names(row) .=> values(row)) for row in eachrow(df)]
app.layout = html_div() do
    dash_datatable(
        id="table",
        columns=[
            Dict("name"=>i, "id"=>i) 
            for i in names(df)
        ],
        data=df_dict,
        style_cell=(textAlign="left"),
        style_header=(backgroundColor="paleturquoise"),
        style_data=(backgroundColor="lavender")
    )
end

run_server(app, "0.0.0.0", 8080)
