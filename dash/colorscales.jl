using Dash
using DashCoreComponents
using DashHtmlComponents
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "iris")

app = dash(external_stylesheets=["https://codepen.io/chriddyp/pen/bWLwgP.css"])

app.layout = html_div() do
    html_p("Color scale"),
    dcc_dropdown(
        id="colorscale",
        options=[(label = x, value = x) for x in sort(collect(keys(colors.all)))],
        value=Symbol("tableau_hue_circle")
    ),
    dcc_graph(id="graph")

end

callback!(app, Output("graph", "figure"), Input("colorscale", "value")) do val
    fig = plot(
        df,
        mode="markers",
        x=:sepal_width,
        y=:sepal_length,
        marker=attr(
            color=df.sepal_length,
            coloraxis="coloraxis",
            showscale=true
        ),
        Layout(coloraxis_colorscale=colors.all[Symbol(val)])
    )
end

run_server(app, "0.0.0.0", 8080)
