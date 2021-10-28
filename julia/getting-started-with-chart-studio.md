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
    description: Installation and Initialization Steps for Using Chart Studio in Julia
    display_as: chart_studio
    language: julia
    layout: base
    name: Getting Started with Plotly
    order: 0.1
    page_type: example_index
    permalink: julia/getting-started-with-chart-studio/
    thumbnail: thumbnail/bubble.jpg
---

### Installation

To install Chart Studio's Julia package, use the built-in Julia package manager to install the `Plotly` package.

```julia
using Pkg
Pkg.add("Plotly")
```

Plotly's main Julia package is called PlotlyJS.jl. PlotlyJS.jl drives all the plot creation. Plotly.jl is an interface between PlotlyJS.jl and the chart-studio web service.

### Initialization for Online Plotting

Chart Studio provides a web-service for hosting graphs! Create a [free account](https://plotly.com/api_signup) to get started. Graphs are saved inside your online Chart Studio account and you control the privacy. Public hosting is free, for private hosting, check out our [paid plans](https://plotly.com/products/cloud/).

After installing the Plotly.jl package, you're ready to fire up julia:

`$ julia`

and set your credentials:

```julia
using Plotly
Plotly.signin("DemoAccount", "lr1c37zw81")
```

<!-- #region -->

You'll need to replace **"DemoAccount"** and **"lr1c37zw81"** with _your_ Plotly username and [API key](https://plotly.com/settings/api).
Find your API key [here](https://plotly.com/settings/api).

The initialization step places a special **.plotly/.credentials** file in your home directory. Your **~/.plotly/.credentials** file should look something like this:

```json
{
    "username": "DemoAccount",
    "api_key": "lr1c37zw81"
}
```

<!-- #endregion -->

### Online Plot Privacy

Plot can be set to three different type of privacies: public, private or secret.

- **public**: Anyone can view this graph. It will appear in your profile and can appear in search engines. You do not need to be logged in to Chart Studio to view this chart.
- **private**: Only you can view this plot. It will not appear in the Plotly feed, your profile, or search engines. You must be logged in to Plotly to view this graph. You can privately share this graph with other Chart Studio users in your online Chart Studio account and they will need to be logged in to view this plot.
- **secret**: Anyone with this secret link can view this chart. It will not appear in the Chart Studio feed, your profile, or search engines. If it is embedded inside a webpage or an IPython notebook, anybody who is viewing that page will be able to view the graph. You do not need to be logged in to view this plot.

By default all plots are set to **public**. Users with free account have the permission to keep one private plot. If you need to save private plots, [upgrade to a pro account](https://plotly.com/plans). If you're a [Personal or Professional user](https://plotly.com/settings/subscription/?modal=true&utm_source=api-docs&utm_medium=support-oss) and would like the default setting for your plots to be private, you can edit your Chart Studio configuration:

```julia
using Plotly
Plotly.set_config_file(
    world_readable=false,
    sharing="private"
)

```

### Special Instructions for [Chart Studio Enterprise](https://plotly.com/product/enterprise/) Users

Your API key for account on the public cloud will be different than the API key in Chart Studio Enterprise. Visit https://plotly.your-company.com/settings/api/ to find your Chart Studio Enterprise API key. Remember to replace "your-company.com" with the URL of your Chart Studio Enterprise server.
If your company has a Chart Studio Enterprise server, change the API endpoint so that it points to your company's Plotly server instead of Plotly's cloud.

In Julia, enter:

```julia
using Plotly
Plotly.set_config_file(
    plotly_domain="https://plotly.your-company.com",
    plotly_streaming_domain="https://stream-plotly.your-company.com"
)
```

Make sure to replace **"your-company.com"** with the URL of _your_ Chart Studio Enterprise server.

Additionally, you can set your configuration so that you generate **private plots by default**.

In pJulia, enter:

```julia
using Plotly
Plotly.set_config_file(
    plotly_domain="https://plotly.your-company.com",
    plotly_streaming_domain="https://stream-plotly.your-company.com",
    world_readable=false,
    sharing="private"
)

```

### Start Plotting Online

When plotting online, the plot and data will be saved to your cloud account. The main workflow for plotting on line is to first create a plot using any of the plotting commands from PlotlyJS.jl. Then, with the plot in hand, call the `Plotly.post` function. This will "post" the plot to your Chart Studio account.

Copy and paste the following example to create your first hosted Plotly graph using the Plotly Julia library:

```julia
using Plotly

trace0 = scatter(x=1:4, y=[10, 15, 13, 17])
trace1 = scatter(1:4, y=[16, 5, 11, 9])
p = plot([trace0, trace1])
Plotly.post(p, filename="basic-line")
```
