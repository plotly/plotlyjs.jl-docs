using Dash
using DashHtmlComponents
using DashCoreComponents
using PlotlyJS, CSV, DataFrames

app = dash(external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"])

df = dataset(DataFrame, "tips")

app.layout = html_div() do
    html_p("Names:"),
    dcc_dropdown(
        id="names", 
        value="day", 
        options=[
            (value= x, label= x)
            for x in ["smoker", "day", "time", "sex"]
        ],
        clearable=false
    ),
    html_p("Values:"),
    dcc_dropdown(
        id="values", 
        value="total_bill", 
        options=[
            (value= x, label=x)
            for x in ["total_bill", "tip", "size"]
        ],
        clearable=false
    ),
    dcc_graph(id="pie-chart")
end

callback!(
    app, 
    Output("pie-chart", "figure"), 
    [Input("values", "value"), Input("names", "value")]
) do v, n
    fig = plot(pie(values=df[!,v], labels=df[!, n]))
    return fig
end
run_server(app, "0.0.0.0", 8080)
