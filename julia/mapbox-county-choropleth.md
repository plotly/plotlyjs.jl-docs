---
jupyter:
  jupytext:
    notebook_metadata_filter: all
    text_representation:
      extension: .md
      format_name: markdown
      format_version: "1.2"
      jupytext_version: 1.4.2
  kernelspec:
    display_name: Julia 1.6.0
    language: julia
    name: julia-1.6
  plotly:
    description: How to make a Mapbox Choropleth Map of US Counties in Julia with
      Plotly.
    display_as: maps
    language: julia
    layout: base
    name: Mapbox Choropleth Maps
    order: 1
    page_type: example_index
    permalink: julia/mapbox-county-choropleth/
    thumbnail: thumbnail/mapbox-choropleth.png
---

A [Choropleth Map](https://en.wikipedia.org/wiki/Choropleth_map) is a map composed of colored polygons.
It is used to represent spatial variations of a quantity. This page documents how to build **tile-map**
choropleth maps, but you can also build [**outline** choropleth maps using our non-Mapbox trace types](/julia/choropleth-maps).

Below we show how to create Choropleth Maps using `choroplethmapbox`

#### Mapbox Access Tokens and Base Map Configuration

To plot on Mapbox maps with Plotly you _may_ need a Mapbox account and a public [Mapbox Access Token](https://www.mapbox.com/studio). See our [Mapbox Map Layers](/julia/mapbox-layers/) documentation for more information.

### Introduction: main parameters for choropleth tile maps

Making choropleth Mapbox maps requires two main types of input:

1. GeoJSON-formatted geometry information where each feature has either an `id` field or some identifying value in `properties`.
2. A list of values indexed by feature identifier.

The GeoJSON data is passed to the `geojson` argument, and the data is passed into the `z` argument of `choroplethmapbox`, in the same order as the IDs are passed into the `location` argument.

**Note** the `geojson` attribute can also be the URL to a GeoJSON file, which can speed up map rendering in certain cases.

#### GeoJSON with `feature.id`

Here we load a GeoJSON file containing the geometry information for US counties, where `feature.id` is a [FIPS code](https://en.wikipedia.org/wiki/FIPS_county_code).

```julia
using PlotlyJS, JSON, HTTP

response = HTTP.get("https://raw.githubusercontent.com/plotly/datasets/master/geojson-counties-fips.json")
counties = JSON.parse(String(response.body))

counties["features"][1]
```

#### Data indexed by `id`

Here we load unemployment data by county, also indexed by [FIPS code](https://en.wikipedia.org/wiki/FIPS_county_code).

```julia
using PlotlyJS, CSV, HTTP, DataFrames
df = CSV.File(
    HTTP.get("https://raw.githubusercontent.com/plotly/datasets/master/fips-unemp-16.csv").body
) |> DataFrame
```

### Choropleth map using carto base map (no token needed)

With `choroplethmapbox`, each row of the DataFrame is represented as a region of the choropleth.

```julia
using PlotlyJS, CSV, JSON, HTTP, DataFrames

response = HTTP.get("https://raw.githubusercontent.com/plotly/datasets/master/geojson-counties-fips.json")
counties = JSON.parse(String(response.body))

df = CSV.File(
    HTTP.get("https://raw.githubusercontent.com/plotly/datasets/master/fips-unemp-16.csv").body,
    types=Dict("fips" => String)
) |> DataFrame

f = open("./.mapbox_token") # you will need your own
token = String(read(f))
close(f)

trace = choroplethmapbox(
    geojson=counties,
    locations=df.fips,
    z=df.unemp,
    featureidkey="id",
    coloraxis="coloraxis",
    range_color=[0,12],
    marker_opacity=0.5,
)

plot(trace, 
    Layout(
        mapbox=attr(
            accesstoken=token, 
            style="carto-positron", 
            center=attr(lat=37.0902, lon=-95.7129),
            zoom=3,
        ),
        coloraxis_colorscale=colors.viridis,
        margin=attr(r=0,t=0,l=0,b=0)
    )
)
```

### Indexing by GeoJSON Properties

If the GeoJSON you are using either does not have an `id` field or you wish you use one of the keys in the `properties` field, you may use the `featureidkey` parameter to specify where to match the values of `locations`.

In the following GeoJSON object/data-file pairing, the values of `properties.district` match the values of the `district` column:

```julia
using PlotlyJS, CSV, JSON, DataFrames

df = dataset(DataFrame, "election")
geojson = dataset("election_geo")

df.district[3]
geojson["features"][1]["properties"]
```

To use them together, we set `locations` to `district` and `featureidkey` to `"properties.district"`. The `z` is set to the number of votes by the candidate named Bergeron.

```julia
using PlotlyJS, CSV, JSON, DataFrames

df = dataset(DataFrame, "election")
geojson = dataset("election_geo")

trace = choroplethmapbox(
    geojson=geojson,
    z=df.Bergeron,
    locations=df.district,
    featureidkey="properties.district"
)

plot(trace,
    Layout(
        mapbox=attr(
            center=attr(lat=45.5517, lon=-73.7073),
            style="carto-positron",
            zoom=9
        ),
        margin=attr(t=0,b=0,r=0,l=0)
    )
)
```

<!-- TODO: This is python magic functionality -->
### Discrete Colors

In addition to [continuous colors](/julia/colorscales/), we can [discretely-color](/julia/discrete-color/)
our choropleth maps by setting `z` to a non-numerical column, like the name of the winner of an election.

<!-- ```python
import plotly.express as px

df = px.data.election()
geojson = px.data.election_geojson()

fig = px.choropleth_mapbox(df, geojson=geojson, color="winner",
                           locations="district", featureidkey="properties.district",
                           center={"lat": 45.5517, "lon": -73.7073},
                           mapbox_style="carto-positron", zoom=9)
fig.update_layout(margin={"r":0,"t":0,"l":0,"b":0})
fig.show()
``` -->

```julia
using PlotlyJS, CSV, JSON, DataFrames

df = dataset(DataFrame, "election")
geojson = dataset("election_geo")

trace = choroplethmapbox(
    geojson=geojson,
    z=df.winner,
    locations=df.district,
    featureidkey="properties.district"
)

plot(trace,
    Layout(
        mapbox=attr(
            center=attr(lat=45.5517, lon=-73.7073),
            style="carto-positron",
            zoom=9
        ),
        margin=attr(t=0,b=0,r=0,l=0)
    )
)
```

TODO: Python specific?
<!-- ### Using GeoPandas Data Frames

`px.choropleth_mapbox` accepts the `geometry` of a [GeoPandas](https://geopandas.org/) data frame as the input to `geojson` if the `geometry` contains polygons.

```python
import plotly.express as px
import geopandas as gpd

df = px.data.election()
geo_df = gpd.GeoDataFrame.from_features(
    px.data.election_geojson()["features"]
).merge(df, on="district").set_index("district")

fig = px.choropleth_mapbox(geo_df,
                           geojson=geo_df.geometry,
                           locations=geo_df.index,
                           color="Joly",
                           center={"lat": 45.5517, "lon": -73.7073},
                           mapbox_style="open-street-map",
                           zoom=8.5)
fig.show()
``` -->

#### Mapbox Light base map: free token needed

```python
token = open(".mapbox_token").read() # you will need your own token


from urllib.request import urlopen
import json
with urlopen('https://raw.githubusercontent.com/plotly/datasets/master/geojson-counties-fips.json') as response:
    counties = json.load(response)

import pandas as pd
df = pd.read_csv("https://raw.githubusercontent.com/plotly/datasets/master/fips-unemp-16.csv",
                   dtype={"fips": str})

import plotly.graph_objects as go

fig = go.Figure(go.Choroplethmapbox(geojson=counties, locations=df.fips, z=df.unemp,
                                    colorscale="Viridis", zmin=0, zmax=12, marker_line_width=0))
fig.update_layout(mapbox_style="light", mapbox_accesstoken=token,
                  mapbox_zoom=3, mapbox_center = {"lat": 37.0902, "lon": -95.7129})
fig.update_layout(margin={"r":0,"t":0,"l":0,"b":0})
fig.show()
```

```julia
using PlotlyJS, CSV, JSON, HTTP, DataFrames

response = HTTP.get("https://raw.githubusercontent.com/plotly/datasets/master/geojson-counties-fips.json")
counties = JSON.parse(String(response.body))

df = CSV.File(
    HTTP.get("https://raw.githubusercontent.com/plotly/datasets/master/fips-unemp-16.csv").body,
    types=Dict("fips" => String)
) |> DataFrame

f = open("./.mapbox_token") # you will need your own
token = String(read(f))
close(f)

# TODO: Looks like zmin and zmax aren't doing anything
trace = choroplethmapbox(
    geojson=counties,
    locations=df.fips,
    z=df.unemp,
    zmin=0,
    zmax=12,
    featureidkey="id",
    coloraxis="coloraxis",
    range_color=[0,12],
    marker_line_width=0,
    marker_opacity=0.5,
)

plot(trace, 
    Layout(
        mapbox=attr(
            accesstoken=token, 
            style="light", 
            center=attr(lat=37.0902, lon=-95.7129),
            zoom=3,
        ),
        coloraxis_colorscale=colors.viridis,
        margin=attr(r=0,t=0,l=0,b=0)
    )
)

```

#### Reference

See [function reference for `(choropleth_mapbox)`](https://plotly.com/python/reference/choroplethmapbox/) for more information about mapbox and their attribute options.
