using Dash
using DashCoreComponents
using DashHtmlComponents
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "gapminder")
oceania = df[df.continent .== "Oceania", :]

default_fig = plot(
    oceania, 
    mode="markers+lines",
    hovertemplate=nothing,
    x=:year, 
    y=:lifeExp, 
    color=:country, 
    title="Hover over points to see the change",
    Layout(hovermode="closest")
)

app = dash(external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"])

app.layout = html_div() do 
    html_p("Hovermode"),
    dcc_radioitems(
        id="hovermode",
        labelStyle=(display="inline-block",),
        options=[
            (label=x, value=x)
            for x in ["x", "x unified", "closest"]
        ],
        value="closest"
    ),
    dcc_graph(id="graph", figure=default_fig)
    
end

callback!(
    app,
    Output("graph", "figure"),
    Input("hovermode", "value"),
    State("graph" ,"figure")
) do hovermode, fig
    fig.layout.hovermode = hovermode
    return fig
end

run_server(app, "0.0.0.0", 8080)
