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
    description: Visualize Principle Component Analysis (PCA) of your high-dimensional
      data in Julia with PlotlyJS.jl.
    display_as: ai_ml
    language: python
    layout: base
    name: PCA Visualization
    order: 4
    page_type: example_index
    permalink: julia/pca-visualization/
    thumbnail: thumbnail/ml-pca.png
---

This page first shows how to visualize higher dimension data using various
Plotly figures combined with dimensionality reduction (aka projection). Then, we
dive into the specific details of our projection algorithm.

We will use [MLJ.jl](https://alan-turing-institute.github.io/MLJ.jl/dev/) to apply
dimensionality reduction. MLJ is a popular Machine Learning (ML)
library that offers various tools for creating and training ML algorithms,
feature engineering, data cleaning, and evaluating and testing models. It was
designed to be accessible, and to work seamlessly with many libraries in the
Julia package ecosystem.

## High-dimensional PCA Analysis with  `plot(::DataFrame, kind="splom", ...)`

The dimensionality reduction technique we will be using is called the [Principal
Component Analysis
(PCA)](https://scikit-learn.org/stable/modules/decomposition.html#pca). It is a
powerful technique that arises from linear algebra and probability theory. In
essence, it computes a matrix that represents the variation of your data
([covariance matrix/eigenvectors][covmatrix]), and rank them by their relevance
(explained variance/eigenvalues). For a video tutorial, see [this segment on
PCA](https://youtu.be/rng04VJxUt4?t=98) from the Coursera ML course

[covmatrix]: https://stats.stackexchange.com/questions/2691/making-sense-of-principal-component-analysis-eigenvectors-eigenvalues#:~:text=As%20it%20is%20a%20square%20symmetric%20matrix%2C%20it%20can%20be%20diagonalized%20by%20choosing%20a%20new%20orthogonal%20coordinate%20system%2C%20given%20by%20its%20eigenvectors%20(incidentally%2C%20this%20is%20called%20spectral%20theorem)%3B%20corresponding%20eigenvalues%20will%20then%20be%20located%20on%20the%20diagonal.%20In%20this%20new%20coordinate%20system%2C%20the%20covariance%20matrix%20is%20diagonal%20and%20looks%20like%20that%3A

### Visualize all the original dimensions

First, let's plot all the features and see how the `species` in the Iris dataset
are grouped. In a [Scatter Plot Matrix
(splom)](https://plotly.com/julia/reference/splom/), each subplot displays a
feature against another, so if we have $N$ features we have a $N \times N$
matrix.

In our example, we are plotting all 4 features from the Iris dataset, thus we
can see how `sepal_width` is compared against `sepal_length`, then against
`petal_width`, and so forth. Keep in mind how some pairs of features can more
easily separate different species.


```julia
using PlotlyJS, CSV, DataFrames

df = dataset(DataFrame, "iris")
features = [:sepal_width, :sepal_length, :petal_width, :petal_length]
plot(df, dimensions=features, color=:species, kind="splom")
```


###  Visualize all the principal components

Now, we apply `PCA` the same dataset, and retrieve **all** the components. We
use the same `"splom"` trace to display our results, but this time our features
are the resulting *principal components*, ordered by how much variance they are
able to explain.

The importance of explained variance is demonstrated in the example below. The
subplot between PC3 and PC4 is clearly unable to separate each class, whereas
the subplot between PC1 and PC2 shows a clear separation between each species.

```julia
using PlotlyJS, CSV, DataFrames, MLJ

df = dataset(DataFrame, "iris")
features = [:sepal_width, :sepal_length, :petal_width, :petal_length]

# load and fit PCA
PCA = @load PCA pkg="MultivariateStats"
mach = machine(PCA(pratio=1), df[!, features])
fit!(mach)

# compute explained variance for each dimension
explained_variance = report(mach).principalvars
explained_variance ./= sum(explained_variance)
explained_variance .*= 100

# transform data to get components
components = MLJ.transform(mach, df[!, features])
dimensions = Symbol.(names(components))
components.species = df.species

labels = attr(;
    [
        dimensions[i] => "PC $i ($v%)"
        for (i, v) in enumerate(round.(explained_variance, digits=1))
    ]...
)

# plot
plot(components, dimensions=dimensions, labels=labels, color=:species, kind="splom")
```

### Visualize a subset of the principal components

When you will have too many features to visualize, you might be interested in
only visualizing the most relevant components. Those components often capture a
majority of the [explained
variance](https://en.wikipedia.org/wiki/Explained_variation), which is a good
way to tell if those components are sufficient for modelling this dataset.

In the example below, our dataset contains 12 features, but we choose to keep
the minimum number of components needed to explain 99% of the variance (see
usage of the `pratio` parameter below).


```julia
using PlotlyJS, MLJ

boston_features, boston_target = @load_boston

# load and fit PCA
PCA = @load PCA pkg="MultivariateStats"
mach = machine(PCA(pratio=0.99), boston_features)
fit!(mach)

# compute total explained variance
explained_variance = report(mach).principalvars
explained_variance ./= sum(explained_variance)
total_variance = sum(explained_variance)

# transform data to get components
components = DataFrame(MLJ.transform(mach, boston_features))
dimensions = Symbol.(names(components))
labels = attr(;
    [dimensions[i] => "PC $i" for i in 1:length(dimensions)]...
)
plot(
    components, dimensions=dimensions, labels=labels, kind="splom",
    marker=attr(color=boston_target, coloraxis="coloraxis"),
    Layout(
        title="Total explained variance: $(round(total_variance, digits=2))",
        coloraxis=attr(showscale=true, colorscale=colors.magma)
    )
)
```

## 2D PCA Scatter Plot

In the previous examples, you saw how to visualize high-dimensional PCs. In this
example, we show you how to simply visualize the first two principal components
of a PCA, by reducing a dataset of 4 dimensions to 2D.

```julia
using PlotlyJS, CSV, DataFrames, MLJ

df = dataset(DataFrame, "iris")
features = [:sepal_width, :sepal_length, :petal_width, :petal_length]

# load and fit PCA
PCA = @load PCA pkg="MultivariateStats"
mach = machine(PCA(maxoutdim=2), df[!, features])
fit!(mach)

components = MLJ.transform(mach, df[!, features])
components.species = df.species

plot(components, x=:x1, y=:x2, color=:species, mode="markers")
```

## Visualize PCA with `scatter3d`

With the `scatter_3d` trace type, you can visualize an additional dimension, which let you capture even more variance.

```julia
using PlotlyJS, CSV, DataFrames, MLJ

df = dataset(DataFrame, "iris")
features = [:sepal_width, :sepal_length, :petal_width, :petal_length]

# load and fit PCA
PCA = @load PCA pkg="MultivariateStats"
mach = machine(PCA(maxoutdim=3), df[!, features])
fit!(mach)

components = MLJ.transform(mach, df[!, features])
components.species = df.species
total_var = report(mach).tprincipalvar / report(mach).tvar

plot(
    components, x=:x1, y=:x2, z=:x3, color=:species,
    kind="scatter3d", mode="markers",
    labels=attr(;[Symbol("x", i) => "PC $i" for i in 1:3]...),
    Layout(
        title="Total explained variance: $(round(total_var, digits=2))"
    )
)
```

## Plotting explained variance

Often, you might be interested in seeing how much variance PCA is able to explain as you increase the number of components, in order to decide how many dimensions to ultimately keep or analyze. This example shows you how to quickly plot the cumulative sum of explained variance for a high-dimensional dataset like [spectrometer](https://www.openml.org/d/313).

With a higher explained variance, you are able to capture more variability in your dataset, which could potentially lead to better performance when training your model. For a more mathematical explanation, see this [Q&A thread](https://stats.stackexchange.com/questions/22569/pca-and-proportion-of-variance-explained).

```julia
using PlotlyJS, DataFrames, MLJ

spectrometer = OpenML.load(313, parser=:auto)
skip = [Symbol("LRS-name"), Symbol("LRS-class"), Symbol("ID-type")]
_, X = unpack(spectrometer, x -> x in skip, colname->true)
df = Float64.(DataFrame(X))

PCA = @load PCA pkg="MultivariateStats"
mach = machine(PCA(pratio=0.995), df)
fit!(mach)

explained_variance = report(mach).principalvars
explained_variance ./= sum(explained_variance)
cum_ev = cumsum(explained_variance)

plot(
    cum_ev, stackgroup=1,
    Layout(
        xaxis_title="Number of components",
        yaxis_title="Cumulative explained variance"
    )
)

```

## Visualize Loadings

It is also possible to visualize loadings using `shapes`, and use `annotations` to indicate which feature a certain loading original belong to. Here, we define loadings as:

$$
loadings = eigenvectors \cdot \sqrt{eigenvalues}
$$

For more details about the linear algebra behind eigenvectors and loadings, see this [Q&A thread](https://stats.stackexchange.com/questions/143905/loadings-vs-eigenvectors-in-pca-when-to-use-one-or-another).

```julia
using PlotlyJS, CSV, DataFrames, MLJ

df = dataset(DataFrame, "iris")
features = [:sepal_width, :sepal_length, :petal_width, :petal_length]

# load and fit PCA
PCA = @load PCA pkg="MultivariateStats"
mach = machine(PCA(maxoutdim=2), df[!, features])
fit!(mach)

components = MLJ.transform(mach, df[!, features])
components.species = df.species
projection = fitted_params(mach).projection
loadings = projection' .* report(mach).principalvars

plot(
    components, x=:x1, y=:x2, color=:species, mode="markers",
    Layout(
        shapes=[
            line(x0=0, y0=0, x1=loadings[1, i], y1=loadings[2, i])
            for i in 1:length(features)
        ],
        annotations=[
            attr(
                x=loadings[1, i], y=loadings[2, i], text=features[i],
                xanchor="center", yanchor="bottom"
            )
            for i in 1:length(features)
        ]
    )
)
```

## References

The following resources offer an in-depth overview of PCA and explained variance:
* https://en.wikipedia.org/wiki/Explained_variation
* https://scikit-learn.org/stable/modules/decomposition.html#pca
* https://stats.stackexchange.com/questions/2691/making-sense-of-principal-component-analysis-eigenvectors-eigenvalues/140579#140579
* https://stats.stackexchange.com/questions/143905/loadings-vs-eigenvectors-in-pca-when-to-use-one-or-another
* https://stats.stackexchange.com/questions/22569/pca-and-proportion-of-variance-explained
