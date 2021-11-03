---
jupyter:
  jupytext:
    notebook_metadata_filter: all
    text_representation:
      extension: .md
      format_name: markdown
      format_version: '1.2'
      jupytext_version: 1.6.0
  plotly:
    description: Visualize regression in Julia with PlotlyJS.jl.
    display_as: ai_ml
    language: julia
    layout: base
    name: PCA Visualization
    order: 4
    page_type: example_index
    permalink: julia/pca-visualization/
    thumbnail: thumbnail/ml-pca.png
---

**Packages Used**: PlotlyJS, DataFrames, Tables, MLJ, MultivariateStats, MLJMultivariateStatsInterface

**Note**: The examples below are encapsulated in functions since it is best practice in Julia.

# Visualize all the original dimensions with a Scatter Plot Matrix

For datasets with more than 3 dimensions, it is convenient to use **PlotlyJS**'s `splom` trace. We can see all the dimensions here. We pull the iris dataset with **PlotlyJS**'s `dataset` and plot with `splom`.

```julia
using PlotlyJS
using DataFrames: DataFrame

function display_iris_all_dimensions()
    df = DataFrame(dataset("iris"))
    axes = [:petal_length, :petal_width, :sepal_length, :sepal_width]
    
    layout = Layout(font=attr(family="Courier New", size=9,color="Black"))
    Plot(df, layout; dimensions=axes, color=:species, kind="splom", opacity=0.65)
end

display_iris_all_dimensions()
```

# Visualize all the principal components

To see the effects of PCA, we plot a `splom` of the iris dataset. For the PCA model, we will use the **MultivariateStats**. **MLJ** interfaces with **MultivariateStats** via a special package, **MLJMultivariateStatsInterface**, so note the `@load` macro used to load the PCA model. Nevertheless, we use the `machine` binding of `MLJ` to set up the model and fit it. The pratio is a hyperparameter of PCA that determines the amount of variance to explain. Of course the output dimension of the iris dataset from **PCA** is ridiculous (the output dimensions is the same as the feature dimension), but one can see that for `x3` and `x4` dimensions, one cane see that the PCA lacks predictive power.

```julia
using PlotlyJS, MLJ
using DataFrames: DataFrame, insertcols!

PCA = @load PCA pkg="MultivariateStats" verbosity=0

function display_iris_all_pca_components()
    df = DataFrame(dataset("iris"))
    axes = [:petal_length, :petal_width, :sepal_length, :sepal_width]
    X, = unpack(df, ∈(axes))
    coerce!(X, Any => Continuous)
    
    mach = machine(PCA(pratio=0.999), X)
    fit!(mach)
    
    Xpca = transform(mach, X)
    insertcols!(Xpca, :species=>df[!,:species])
    
    axes_pca = Symbol.(filter!(∋('x'), names(Xpca)))
    
    layout = Layout(font=attr(family="Courier New", size=14,color="Black"))
    Plot(Xpca, layout; dimensions=axes_pca, color=:species, kind="splom", opacity=0.65)
end

display_iris_all_pca_components()
```

# Visualize a subset of the principal components

Here we use PCA on the Boston dataset from **MLJ**'s `@load_boston` macro. Using the same model as before, set the variance to be explained to 99.9%. Nevertheless, one is able to select the subset of dimensions to visualize the PCA projects components of interest. This is done by manual choosing `axes_pca`.
```julia
using PlotlyJS, MLJ
using DataFrames: DataFrame, insertcols!

PCA = @load PCA pkg="MultivariateStats" verbosity=0

function display_boston_subset_pca_components()
    X, y = @load_boston
    df = DataFrame(X)

    coerce!(df, Any => Continuous)
    
    mach = machine(PCA(pratio=0.999), X)
    fit!(mach)
    
    Xpca = DataFrame(transform(mach, X))
    insertcols!(Xpca,:Medv => y)
    
    axes_pca = [:x1,:x2,:x3]
    
    layout = Layout(font=attr(family="Courier New", size=14, color="Black"))
    Plot(Xpca, layout; dimensions=axes_pca, kind="splom", opacity=0.65, 
                       marker=attr(color=:Medv, coloraxis="coloraxis"))
end

display_boston_subset_pca_components()
```

# 2D PCA Scatter Plot

Here, we use the `maxoutdim` to limit the max number of projected dimensions. The data visualized is the iris dataset.


```julia
using PlotlyJS, MLJ
using DataFrames: DataFrame, insertcols!

PCA = @load PCA pkg="MultivariateStats" verbosity=0

function display_iris_2D_pca()
    df = DataFrame(dataset("iris"))
    axes = [:petal_length, :petal_width, :sepal_length, :sepal_width]
    X, = unpack(df, ∈(axes))
    coerce!(X, Any => Continuous)
    
    mach = machine(PCA(pratio=0.999,maxoutdim=2), X)
    fit!(mach)
    
    Xpca = transform(mach, X)
    insertcols!(Xpca, :species=>df[!,:species])
    
    axes_pca = Symbol.(filter!(∋('x'), names(Xpca)))
    
    layout = Layout(font=attr(family="Courier New", size=14, color="Black"))
    Plot(Xpca, layout; x=:x1, y=:x2, mode="markers", color=:species, kind="scatter", opacity=0.65)
end

display_iris_2D_pca()
```

# Visualize PCA with scatter3d

We repeat the same visualization as be for but for three dimensions.

```julia
using PlotlyJS, MLJ
using DataFrames: DataFrame, insertcols!

PCA = @load PCA pkg="MultivariateStats" verbosity=0

function display_iris_3D_pca()
    df = DataFrame(dataset("iris"))
    axes = [:petal_length, :petal_width, :sepal_length, :sepal_width]
    X, = unpack(df, ∈(axes))
    coerce!(X, Any => Continuous)
    
    mach = machine(PCA(pratio=0.999,maxoutdim=3), X)
    fit!(mach)
    
    Xpca = transform(mach, X)
    insertcols!(Xpca, :species=>df[!,:species])
    
    axes_pca = Symbol.(filter!(∋('x'), names(Xpca)))
    
    layout = Layout(font=attr(family="Courier New", size=14, color="Black"))
    Plot(Xpca, layout; x=:x1, y=:x2, z=:x3, mode="markers", color=:species, kind="scatter3d", opacity=0.65)
end

display_iris_3D_pca()
```

# Visualize Transformed

It is also possible to visualize loadings using `shapes`, and use `annotations` to indicate which feature a certain loading original belong to. Here, we define loadings as:

$\text{loadings} = \text{eigenvectors} \cdot \sqrt{\\text{eigenvalues}}$

```julia
using PlotlyJS, MLJ
using DataFrames: DataFrame, insertcols!, filter
using Tables: rowtable

PCA = @load PCA pkg="MultivariateStats" verbosity=0

function display_iris_2D_pca_before_after()
    df = DataFrame(dataset("iris"))
    axes = [:petal_length, :petal_width, :sepal_length, :sepal_width]
    X, = unpack(df, ∈(axes))
    coerce!(X, Any => Continuous)
    
    mach = machine(PCA(pratio=0.999,maxoutdim=2), X)
    fit!(mach)
    
    Xpca = transform(mach, X)
    insertcols!(Xpca, :species=>df[!,:species])
    
    projection = fitted_params(mach).projection
    loadings = projection' .* report(mach).principalvars
    
    axes_pca = Symbol.(filter!(∋('x'), names(Xpca)))
    scatter_pca_traces = [
                      scatter(
                       filter(:species=>==(sps),Xpca); x=:x1, y=:x2, mode="markers", name=sps) 
                     for sps in unique(df[!,:species])]
    
    annotations=[attr(x=loadings[1, i], y=loadings[2, i], text=axes[i], xanchor="center", yanchor="bottom") 
                 for i in 1:length(axes)]
    shapes=[line(x0=0, y0=0, x1=loadings[1, i], y1=loadings[2, i]) for i in 1:length(axes)]
    
    layout = Layout(font=attr(family="Courier New", size=14, color="Black"), 
                    shapes=shapes, annotations=annotations)
    Plot([scatter_pca_traces...], layout)
end

display_iris_2D_pca_before_after()
```

# Further Reading

- [PlotlyJS Julia Documentation](http://juliaplots.org/PlotlyJS.jl/stable/)
	- [PlotlyJS Julia scatter](https://plotly.com/julia/line-and-scatter/)
	- [PlotlyJS Julia splom](https://plotly.com/julia/reference/splom/#splom)
	- [PlotlyJS Julia scatter3d](https://plotly.com/julia/3d-scatter-plots/)
	- [PlotlyJS Julia shapes](https://plotly.com/julia/shapes/)
	- [PlotlyJS Julia annotations](https://plotly.com/julia/text-and-annotations/)
- [Julia Docs](https://docs.julialang.org/en/v1/)
- [Julia MLJ](https://alan-turing-institute.github.io/MLJ.jl/dev/)
- [Julia MultivariateStats](https://juliastats.org/MultivariateStats.jl/dev/)
- [Julia Tables (Closely Related to DataFrames)](https://tables.juliadata.org/stable/)
- [Julia Dataframes](https://dataframes.juliadata.org/stable/)
- [linear algebra behind eigenvectors and loadings Q&A](https://stats.stackexchange.com/questions/143905/loadings-vs-eigenvectors-in-pca-when-to-use-one-or-another)