using Dash
using DashCoreComponents
using DashHtmlComponents
using PlotlyJS, HTTP, JSON

app = dash(external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"])

response=HTTP.get("https://raw.githubusercontent.com/plotly/plotly.js/master/test/image/mocks/sankey_energy.json")
data=JSON.parse(String(response.body))

app.layout = html_div() do 
    dcc_graph(id="graph"),
    html_p("Opacity"),
    dcc_slider(id="opacity", min=0, max=1, value=0.5, step=0.1)
end

callback!(app, Output("graph", "figure"), Input("opacity", "value")) do val
    node = data["data"][1]["node"]
    link = data["data"][1]["link"]

    node["color"] = [
        c == "magenta" ? 
        string("rbga(255,0,255,", val,")") :
        replace(c, "0.8" => val)
        for c in node["color"]    
    ]

    link["color"] = [
        node["color"][src+1] # account for 1 based index
        for src in link["source"]
    ]

    fig = plot(
        sankey(
            valueformat = ".0f",
            valuesuffix = "TWh",
            # Define nodes
            node = attr(
                pad = 15,
                thickness = 15,
                line = attr(color = "black", width = 0.5),
                label =  data["data"][1]["node"]["label"],
                color =  data["data"][1]["node"]["color"]
            ),
            # Add links
            link = attr(
                source =  data["data"][1]["link"]["source"],
                target =  data["data"][1]["link"]["target"],
                value =  data["data"][1]["link"]["value"],
                label =  data["data"][1]["link"]["label"],
                color =  data["data"][1]["link"]["color"]
            )
        )
    )
    return fig
end

run_server(app, "0.0.0.0", 8080)
