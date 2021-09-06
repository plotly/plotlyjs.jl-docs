using Dash
using DashCoreComponents
using DashHtmlComponents
using PlotlyJS, CSV, DataFrames
using Base64

app = dash(external_stylesheets=["https://codepen.io/chriddyp/pen/bWLwgP.css"])

df = dataset(DataFrame, "iris")

b = IOBuffer()
iob64_encode = Base64EncodePipe(b)

fig = plot(
    df,
    mode="markers",
    x=:sepal_width,
    y=:sepal_length,
    color=:species
)
PlotlyBase.to_html(iob64_encode, fig.plot)
str = String(take!(b))

app.layout = html_div() do 
    dcc_graph(id="graph", figure=fig),
    html_a(
        html_button("Download HTML"),
        id="download",
        href=string("data:text/html;base64,", str),
        download="plotly_graph.html"
    )
    
end

run_server(app, "0.0.0.0", 8080)
