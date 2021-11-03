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
    description: Visualize t-SNE and UMAP projections in Julia with PlotlyJS.jl.
    display_as: ai_ml
    language: julia
    layout: base
    name: t-SNE and UMAP projections
    order: 4
    page_type: example_index
    permalink: julia/t-sne-and-umap-projections/
    thumbnail: thumbnail/tsne-umap-projections.png
---

**Packages Used**: PlotlyJS, TSne, *Statistics*, PyCall

**Note**: The examples below are encapsulated in functions since it is best practice in Julia.

**Note**: In order to run the umap examples, a working installation of *python2*/*python3* must be installed with *umap-learn* package.

# Basic t-SNE Projections

t-distributed stochastic neighbor embedding (t-SNE) is a dimension reduction algorithm that works on large dimension dataset with non-linear behavior. In contrast to Principal Component Analysis (PCA), t-SNE works on a large set of data. We will create several visuals of t-SNE, using the iris dataset. We will be using the dataset provided by the **PlotlyJS** package.

## Visualizing high-dimensional data with a Scatter Plot Matrix

For datasets with more than 3 dimensions, it is convenient to use **PlotlyJS**'s `splom` trace. Here the code is relatively short. We pull the iris dataset with **PlotlyJS**'s dataset and plot with `splom`.


```julia
using PlotlyJS, DataFrames

function display_iris_splom()
    df = DataFrame(dataset("iris"))
    axes = [:petal_length, :petal_width, :sepal_length, :sepal_width]
    
    layout = Layout(font=attr(family="Courier New", size=14,color="Black"))
    Plot(df; dimensions=axes, color=:species, kind="splom", opacity=0.65, layout=layout)
end

display_iris_splom()
```

## Project data into 2D with t-SNE

Within the Julia ML ecosystem, there is the **TSne** library for the t-SNE algorithm. We will use the `scatter` method to plot the output of `tsne`. Like before, we pull the iris dataset. Then, with the features of interest, we feed that data into the tnse function, inserting the data into the DataFrame for convenience. The plot is a scatter plot, with the species signifying the color.

**Note**: The features are rescaled. This is usually done for t-SNE for better results and performance. The rescaled helper function is defined for that purpose.

```julia
using PlotlyJS, DataFrames, TSne, Statistics

function display_iris_tsne_2d()
    df = DataFrame(dataset("iris"))
    
    features = [:petal_length, :petal_width, :sepal_length, :sepal_width]
    
    rescale(A; dims=1) = (A .- mean(A, dims=dims)) ./ max.(std(A, dims=dims), eps())

    rescaled_features = rescale(Array(df[!,features]))
    tnse_features = tsne(rescaled_features, 2, 0, 1000, 30.0)
    insertcols!(df, :x_tsne => tnse_features[:,1], :y_tsne => tnse_features[:,2])
    
    layout = Layout(xaxis_title="x (t-SNE)", yaxis_title="x (t-SNE)", 
                    font=attr(family="Courier New", size=14,color="Black"))
    Plot(df, layout; x=:x_tsne, y=:y_tsne, color=:species, mode="markers", opacity=0.65)
end

display_iris_tsne_2d()
```

# Project data into 3D with t-SNE

We repeat the previous visualization, but with a 3D scatter plot trace, `scatter3d`, instead. Notice that the second argument of tnse is now 3, this is the output dimension of the projection.


```julia
using PlotlyJS, DataFrames, TSne, Statistics

function display_iris_tsne_3d()
    df = DataFrame(dataset("iris"))
    
    features = [:petal_length, :petal_width, :sepal_length, :sepal_width]
    
    rescale(A; dims=1) = (A .- mean(A, dims=dims)) ./ max.(std(A, dims=dims), eps())
    
    rescaled_features = rescale(Array(df[!,features]))
    tnse_features = tsne(rescaled_features, 3, 0, 1000, 30.0)
    insertcols!(df, :x_tsne => tnse_features[:,1], :y_tsne => tnse_features[:,2], :z_tsne => tnse_features[:,3])
    
    layout = Layout(xaxis_title="x (t-SNE)", yaxis_title="y (t-SNE)", zaxis_title="z (t-SNE)", 
                    font=attr(family="Courier New", size=14,color="Black"))
    Plot(df, layout; x=:x_tsne, y=:y_tsne, z=:z_tsne, color=:species, mode="markers", opacity=0.65,
             kind="scatter3d", marker_size=2)
end

display_iris_tsne_3d()
```

# Projections with UMAP

Similar t-SNE, Uniform Manifold Approximation and Projection (UMAP) is a dimensionality reduction specifically designed for visualizing complex data in low dimensions (2D or 3D). In contrast to t-SNE, UMAP is more efficient, speed-wise and memory-wise, for larger datasets. For this reason, UMAP is the now more widely used than t-SNE.

## Project data into 2D with UMAP

For the UMAP algorithm, we use Python's **umap-learn** library. The workflow is similar to t-sne, but with a different function called.

**Note**: Within the Julia ML ecosystem, there is the UMAP library for the **UMAP** algorithm. However, the author of this page was not able to use that library, therefore the Python library was used.

```julia
using PlotlyJS, DataFrames, Statistics, PyCall
@pyimport umap as py_umap

function display_iris_umap_2d()
    df = DataFrame(dataset("iris"))
    
    features = [:petal_length, :petal_width, :sepal_length, :sepal_width]
    
    rescale(A; dims=1) = (A .- mean(A, dims=dims)) ./ max.(std(A, dims=dims), eps())
    
    rescaled_features = rescale(Array(df[!,features]))
    
    umap_features = py_umap.UMAP(n_neighbors=15, min_dist=0.1, n_epochs=200)[:fit_transform](rescaled_features)
    insertcols!(df, :x_umap => umap_features[:,1], :y_umap => umap_features[:,2])
    
    layout = Layout(xaxis_title="x (UMAP)", yaxis_title="y (UMAP)", 
                    font=attr(family="Courier New", size=14,color="Black"))
    
    Plot(df, layout; x=:x_umap, y=:y_umap, color=:species, mode="markers", opacity=0.65)
end

display_iris_umap_2d()
```

## Project data into 3D with UMAP

We repeat the previous visualization, but with a 3D scatter plot trace, scatter3d, and an output dimension of 3 instead.

```julia
using PlotlyJS, DataFrames, Statistics, PyCall
@pyimport umap as py_umap

function display_iris_umap_3d()
    df = DataFrame(dataset("iris"))
    
    features = [:petal_length, :petal_width, :sepal_length, :sepal_width]
    
    rescale(A; dims=1) = (A .- mean(A, dims=dims)) ./ max.(std(A, dims=dims), eps())
    
    rescaled_features = rescale(Array(df[!,features]))
    
    umap_features = py_umap.UMAP(n_components=3, n_neighbors=15, 
                                 min_dist=0.1, n_epochs=200)[:fit_transform](rescaled_features)
    
    insertcols!(df, :x_umap => umap_features[:,1], :y_umap => umap_features[:,2], :z_umap => umap_features[:,3])
    
    layout = Layout(xaxis_title="x (UMAP)", yaxis_title="x (UMAP)", zaxis_title="z (UMAP)", 
                    font=attr(family="Courier New", size=14,color="Black"))
    
    Plot(df, layout; x=:x_umap, y=:y_umap, z=:z_umap, color=:species, mode="markers", 
                     kind="scatter3d", opacity=0.65, marker_size=5)
end

display_iris_umap_3d()
```

## Visualizing an Image Dataset

We will use the UMAP to visualize the MNIST dataset using `scattergl` (instead of scatter due to the large amount of data). The MNIST dataset is more challenging (compared to the iris dataset) to visualize because it's much higher dimensional and is a larger dataset. The MNIST training dataset is provided by the **MLDatasets** dataset package! Please note, the several lines of code are just for data preparation. The umap function call and plotting is the same.

```julia
using PlotlyJS, DataFrames, Statistics, PyCall, MLDatasets
@pyimport umap as py_umap

function display_mnist_umap()
    nsamples = 60000 # the whole dataset
    X, y = MNIST.traindata()
    X = Float16.(X[:,:,1:nsamples])
    X = reshape(X, (:,size(X)[end]))'
    
    umap_features = py_umap.UMAP(n_components = 2, n_neighbors=20)[:fit_transform](X)
    
    df = DataFrame(:x_umap=>umap_features[:,1],:y_umap=>umap_features[:,2],:label=>string.(y[1:nsamples]))
    
    layout = Layout(xaxis_title="x (UMAP)", yaxis_title="y (UMAP)", 
                font=attr(family="Courier New", size=14,color="Black"))
    
    scatter_trace = Plot(df, layout; x=:x_umap, y=:y_umap, color=:label, mode="markers", kind="scattergl",
                                     opacity=0.33)
end

display_mnist_umap()
```

# Further Reading

- [PlotlyJS Julia Documentation](http://juliaplots.org/PlotlyJS.jl/stable/)
	- [PlotlyJS Julia scatter](https://plotly.com/julia/line-and-scatter/)
	- [PlotlyJS Julia splom](https://plotly.com/julia/reference/splom/#splom)
	- [PlotlyJS Julia scatter3d](https://plotly.com/julia/3d-scatter-plots/)
- [Julia Docs](https://docs.julialang.org/en/v1/)
	- [Julia Statistics](https://docs.julialang.org/en/v1/stdlib/Statistics/)
- [Julia Dataframes](https://dataframes.juliadata.org/stable/)
- [Julia t-sne](https://github.com/lejon/TSne.jl)
- [MNIST Dataset and API](https://juliaml.github.io/MLDatasets.jl/stable/datasets/MNIST/)
- [Python umap](https://pypi.org/project/umap-learn/)