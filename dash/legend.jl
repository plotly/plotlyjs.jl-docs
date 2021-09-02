using Dash
using DashHtmlComponents
using DashCoreComponents
using PlotlyJS, CSV, DataFrames

app = dash(external_stylesheets=["https://codepen.io/chriddyp/pen/bWLwgP.css"])

df = filter(x -> x.year == 2007, dataset(DataFrame, "gapminder"))

app.layout = html_div() do
    dcc_graph(id="graph"),
    html_p("Legend position"),
    dcc_radioitems(
        id="xanchor",
        options=[(label = "left", value = 0), (label = "right", value = 1)],
        value=0,
        labelStyle=(display = "inline-block",)
    ),
    dcc_radioitems(
        id="yanchor",
        options=[(label = "top", value = 1), (label = "bottom", value = 0)],
        value=1,
        labelStyle=(display = "inline-block",)
    )
end

callback!(app, Output("graph", "figure"), [Input("xanchor", "value"), Input("yanchor", "value")]) do pos_x, pos_y
    fig = plot(
        mode="markers",
        df, x=:gdpPercap, y=:lifeExp,
        color=:continent, marker_size=:pop,
        marker_sizeref=2 * maximum(df.pop) / (40^2),
        marker_sizemode="area",
        size_max=45, log_x=true
    )
    relayout!(fig, legend_x=pos_x, legend_y=pos_y)

    return fig
end


run_server(app, "0.0.0.0", 8080, debug=true)
