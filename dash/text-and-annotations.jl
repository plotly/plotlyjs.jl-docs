using Dash
using DashCoreComponents
using DashHtmlComponents
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "gapminder")
df_07 = df[df.year .== 2007, :]

app = dash(external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"])

app.layout = html_div() do 
    dcc_graph(id="graph"),
    html_p("Text Position"),
    dcc_radioitems(
        id="pos-x",
        options=[
            (label=x, value=x)
            for x in ["left", "center", "right"]
        ],
        value="center",
        labelStyle=(display="inline-block",)
    ),
    dcc_radioitems(
        id="pos-y",
        options=[
            (label=x, value=x)
            for x in ["top", "bottom"]
        ],
        value="top",
        labelStyle=(display="inline-block",)
    )
end

callback!(
    app, 
    Output("graph", "figure"),
    [Input("pos-x", "value"), Input("pos-y", "value")]
) do pos_x, pos_y
    print(string(pos_y, " " ,pos_x))
    fig = plot(
        df_07,
        mode="markers+text",
        x=:gdpPercap, y=:lifeExp,
        text=:country,
        size_max=60,
        textposition=string(pos_y, " " ,pos_x),
        Layout(
            xaxis_log=true,
            title="GDP and Life Expectancy, 2007"
        )
    )
end

run_server(app, "0.0.0.0", 8080)
