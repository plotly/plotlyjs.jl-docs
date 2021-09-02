using Dash
using DashCoreComponents
using DashHtmlComponents
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "medals")
long_df = DataFrames.stack(df, Not([:nation]), variable_name="medal", value_name="count")

app = dash(external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"])

app.layout = html_div() do 
    html_p("Medals Included:"),
    dcc_checklist(
        id="medals",
        options=[
            (label=x, value=x)
            for x in ["gold", "silver", "bronze"]
        ],
        value=["gold","silver","bronze"]
    ),
    dcc_graph(id="graph")
    
end

callback!(
    app,
    Output("graph", "figure"),
    Input("medals", "value")
) do val
    data = long_df[[x in val for x in long_df.medal], :]
    fig = plot(
        data,
        kind="heatmap",
        x=:medal,
        y=:nation,
        z=:count,
        colorscale=colors.plasma
    )

    return fig
end

run_server(app, "0.0.0.0", 8080)
