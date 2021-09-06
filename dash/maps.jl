using Dash
using DashCoreComponents
using DashHtmlComponents
using PlotlyJS, CSV, DataFrames

app = dash(external_stylesheets=["https://codepen.io/chriddyp/pen/bWLwgP.css"])

df = dataset(DataFrame, "election")
candidates = unique(df.winner)
election_geo = dataset("election_geo")

app.layout = html_div() do 
    html_p("Candidates"),
    dcc_radioitems(
        id="candidates",
        options=[
            (label = x, value = x)
            for x in candidates
        ],
        value=candidates[1]
    ),
    dcc_graph(id="graph")
end

callback!(app, Output("graph", "figure"), Input("candidates", "value")) do val
    fig = plot(
        df,
        geojson=election_geo,
        kind="choropleth",
        range_color=[0,6500],
        featureidkey="properties.district",
        locations=:district,
        z=df[!, val],
        Layout(
            geo_fitbounds="locations",
            geo_projection_type="mercator",
            geo_visible=false
        )
    )
    
    return fig
end

run_server(app, "0.0.0.0", 8080)
