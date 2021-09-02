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
    description:  Getting Started with Plotly for Julia.
    language: julia
    layout: base
    name: Getting started with Plotly
    page_type: example_index
    permalink: julia/getting-started/
    has_thumbnail: false
---

The [`PlotlyJS` Julia library](/julia/) is an interactive,
[open-source](/julia#is-plotly-free) plotting library that supports over 40
unique chart types covering a wide range of statistical, financial, geographic,
scientific, and 3-dimensional use-cases.

Built on top of the Plotly JavaScript library
([plotly.js](https://plotly.com/javascript/)), `PlotlyJS` enables Julia users to
create beautiful interactive web-based visualizations that can be displayed in
Jupyter notebooks, saved to standalone HTML files, or served as part of pure
Julia-built web applications using Dash.jl.

Thanks to deep integration with our
[Kaleido](https://medium.com/plotly/introducing-kaleido-b03c4b7b1d81) image
export utility, `PlotlyJS` also provides great support for non-web contexts
including desktop editors (e.g. QtConsole, Spyder, PyCharm) and static document
publishing (e.g. exporting notebooks to PDF with high-quality vector images).

This Getting Started guide explains how to install `PlotlyJS` and related optional
pages. Once you've installed, you can use our documentation in three main ways:

For information on using Julia to build web applications containing plotly
figures, see the [_Dash User Guide_](https://dash-julia.plotly.com/).

We also encourage you to join the [Plotly Community
Forum](http://community.plotly.com/) if you want help with anything related to
plotly.

### Installation

To install PlotlyJS.jl, open up a Julia REPL, press `]` to enter package mode
and type:

```
(v1.6) pkg> add PlotlyJS
```

For existing users you can run `up PlotlyJS` from the package manager REPL mode to get
the latest release. If after doing this plots do not show up in your chosen
frontend, please run `build PlotlyJS` (again from pkg REPL mode) to tell Julia
to download the latest release of the plotly.js javascript library.

Once installation is complete, you are ready to create beautiful plotly.js
powered charts!

#### Basic Usage

```julia
using PlotlyJS

p = plot(rand(10, 4))
```

If you are working at the Julia REPL, a dedicated plotting window (powered by
[electron](https://www.electronjs.org/) and driven by
[Blink.jl](https://juliagizmos.github.io/Blink.jl/latest/)) will be used to
display your plot. If you are working in a Jupyter notebook or Jupyter lab, the
plot will appear inline.

If instead, you would like to save the chart for external viewing you can do so
using the `savefig(p, filename::String)` method. The type of file will be
inferred from the extension on the filename (e.g. `myplot.pdf` will produce a
pdf, while `yourplot.html` will produce a standalone html file).

#### Optional Dependencies

`PlotlyJS` makes use of
[Requires.jl](https://github.com/JuliaPackaging/Requires.jl) to build
optional integrations with other parts of the Julia package ecosystem. These
optional dependencies include:

- [DataFrames.jl](https://github.com/JuliaData/DataFrames.jl): A widely used
  implementation of the DataFrame standard for tabular data in Julia. The
  PlotlyJS.jl integration with DataFrames is deep, yet elegant. By implementing
  a method `plot(::DataFrame, args...; kwargs...)`, PlotlyJS.jl obtains many
  advanced functionalities present in other libraries, such as
  [`plotly.express`](https://plotly.com/julia#plotly-express/) from the
  `plotly.py` python library. Many examples throughout the documentation here
  use this method for the `plot` function.
- [CSV.jl](https://juliadata.github.io/CSV.jl/stable/): The de-facto standard
  for reading csv data files in Julia. After importing `PlotlyJS` and `CSV`, a
  `dataset(dataset_name::String)` function is defined that can load a handful of
  datasets commonly used in plotting examples. If you have also loaded
  `DataFrames`, an additional `dataset(DataFrame, dataset_name::String)` method
  is defined that will automatically load the desired dataset into a DataFrame
- [IJulia.jl](https://github.com/JuliaLang/IJulia.jl): The Jupyter kernel
  implementation for Julia. If you use jupyter notebooks (or Jupyter lab!),
  PlotlyJS.jl will be ready to go right out of the box thanks to our integration
  with IJulia
- [Distributions.jl](https://juliastats.org/Distributions.jl/stable/): The
  canonical way to represent and work with probability distributions in Julia.
  The integration with Distributions.jl adds the method
  `plot(d::ContinuousUnivariateDistribution)` to quickly and easily view the pdf
  of the distribution `d`. Appropriate ranges are automatically selected based
  on the quantiles of the distribution.
- [Colors.jl](https://juliagraphics.github.io/Colors.jl/stable/): A very feature
  complete library for representing and working with colors in Julia. Anywhere
  plotly.js accepts a color (for example `marker.color`, or `marker.line.color`,
  `layout.title.font.color`, etc.) Julia users can also pass an instance of any
  type from the Colors.jl library. This
- [ColorSchemes.jl](https://juliagraphics.github.io/ColorSchemes.jl/stable/): a
  collection of over 800 ready to use color schemes. All schemes from the
  ColorSchemes.jl package are ready to be used. They are all exposed under the
  `colors` object that is imported when you run `using PlotlyJS`. To access the
  `vidiris` colorscheme you would use `colors.viridis`. If you aren't sure which
  color scheme you'd like to use, you can use tab completion to inspect the many
  available color schemes. The `colors` object also has helpful categorizations
  of families of color schemes such as `colors.sequential`, `colors.diverging`,
  `colors.cyclical` and `colors.discrete`. Most often, a color scheme is used to
  define the `layout.coloraxis.colorscale` property.

To use any of these optional integrations, all you need to do is import both
`PlotlyJS` and the desired package in your Julia code.

For example:

```julia
using PlotlyJS
using CSV, DataFrames  # automatically loads these integrations

df = dataset(DataFrame, "tips")
plot(df, y=:tip, facet_row=:sex, facet_col=:smoker, color=:day, kind="violin")
```

### Where to next?

Once you've installed, you can use our documentation in two main ways:

1. Jump right in to and see **examples** of how to make [basic
   charts](/julia#basic-charts/), [statistical
   charts](/julia#statistical-charts/), [scientific
   charts](/julia#scientific-charts/), [financial
   charts](/julia#financial-charts/), and [3-dimensional
   charts](/julia#3d-charts/).
2. Read through our documentation on the [fundamentals](/julia#fundamentals) of
   using plotly from Julia.
3. Check out our exhaustive **reference** guide, the [Figure
   Reference](/julia/reference)

For information on using Julia to build web applications containing plotly
figures, see the [_Dash User Guide_](https://dash-julia.plotly.com/).

We also encourage you to join the [Plotly Community
Forum](http://community.plotly.com/) if you want help with anything related to
`plotly`.
