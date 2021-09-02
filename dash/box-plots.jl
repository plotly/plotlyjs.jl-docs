using Dash
using DashHtmlComponents
using DashCoreComponents
using PlotlyJS, CSV, DataFrames

app = dash(external_stylesheets=["https://codepen.io/chriddyp/pen/bWLwgP.css"])

df = dataset(DataFrame, "tips")

app.layout = html_div() do
    html_p("x-axis:"),
    dcc_checklist(
        id="x-axis",
        options=[
            (value = x, label = x)
            for x in ["smoker", "day", "time", "sex"]
        ],
        value=["time"],
        labelStyle=(display = "inline-block",)
    ),
    html_p("y-axis:"),
    dcc_radioitems(
        id="y-axis",
        options=[
            (value = x, label = x)
            for x in ["total_bill", "tip", "size"]
        ],
        value="total_bill",
        labelStyle=(display = "inline-block",)
    ),
    dcc_graph(id="box-plot")
end

callback!(
    app,
    Output("box-plot", "figure"),
    [Input("x-axis", "value"), Input("y-axis", "value")]
) do x, y
    fig = plot(
        [
            box(x=df[!, x_col], y=df[!, y])
            for x_col = x
        ]
    )
    return fig
end
run_server(app, "0.0.0.0", 8080)
