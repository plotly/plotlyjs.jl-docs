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
    description:
      Visualize scikit-learn's k-Nearest Neighbors (kNN) classification
      in Julia with Plotly.
    display_as: ai_ml
    language: juila
    layout: base
    name: kNN Classification
    order: 2
    page_type: u-guide
    permalink: julia/knn-classification/
    thumbnail: thumbnail/knn-classification.png
---

## Basic binary classification with kNN

This section gets us started with displaying basic binary classification using 2D data. We first show how to display training versus testing data using [various marker styles](https://plot.ly/julia/marker-style/), then demonstrate how to evaluate our classifier's performance on the **test split** using a continuous color gradient to indicate the model's predicted score.

We will use [Scikit-learn](https://scikit-learn.org/) for training our model and for loading and splitting data. Scikit-learn is a popular Machine Learning (ML) library that offers various tools for creating and training ML algorithms, feature engineering, data cleaning, and evaluating and testing models. It was designed to be accessible, and to work seamlessly with popular libraries like NumPy and Pandas.

We will train a [k-Nearest Neighbors (kNN)](https://scikit-learn.org/stable/modules/neighbors.html) classifier. First, the model records the label of each training sample. Then, whenever we give it a new sample, it will look at the `k` closest samples from the training set to find the most common label, and assign it to our new sample.

### Display training and test splits

Using Scikit-learn, we first generate synthetic data that form the shape of a moon. We then split it into a training and testing set. Finally, we display the ground truth labels using [a scatter plot](https://plotly.com/julia/line-and-scatter/).

In the graph, we display all the negative labels as squares, and positive labels as circles. We differentiate the training and test set by adding a dot to the center of test data.

```julia
using PlotlyJS, MLJ

X, y = make_moons(noise=0.3)
test, train = partition(eachindex(y), 0.75, shuffle=true)

df = DataFrame(X)
df.y = y

trace_specs = [
    (df[train, :], 0, "Train", "square"),
    (df[train, :], 1, "Train", "circle"),
    (df[test, :], 0, "Test", "square-dot"),
    (df[test, :], 1, "Test", "circle-dot"),
]

traces = [
    scatter(
        x=data[data.y .== label, :x1],
        y=data[data.y .== label, :x2],
        name=string(split, " Split, Label ", label),
        mode="markers",
        marker=attr(
            symbol=marker,
            color="lightyellow",
            size=12,
            line_width=1.5
        )
    ) for (data, label, split, marker) in trace_specs
]

plot(traces)
```

### Visualize predictions on test split

Now, we train the kNN model on the same training data displayed in the previous graph. Then, we predict the confidence score of the model for each of the data points in the test set. We will use shapes to denote the true labels, and the color will indicate the confidence of the model for assign that score.

Notice that `scatter` only require 1 function call to plot both negative and positive labels, and can additionally set a continuous color scale based on the `y_score` output by our kNN model.

```julia
using PlotlyJS, MLJ

X, y = make_moons(noise=0.3)
test, train = partition(eachindex(y), 0.75, shuffle=true)

df_X = DataFrame(X)

KNNClassifier = @load KNNClassifier
clf = KNNClassifier(K=15)
mach = machine(clf, X, y)
fit!(mach, rows=train)
yhat = predict(mach, df_X[test, :])
prob = map(x->x.prob_given_ref[2], yhat)
score = LogLoss(tol=1e-4)(yhat, y[test])

plot(scatter(
    mode="markers",
    df_X[test,:], x=:x1,y=:x2,
    marker=attr(
        color=prob,
        coloraxis="coloraxis",
        size=12,
        line_width=1.5,
        symbol=y[test],
        cmin=minimum(prob),
        cmax=maximum(prob)
    )
), Layout(showlegend=true, coloraxis_colorscale=colors.RdBu_8))
```

## Probability Estimates with `contour`

Just like the previous example, we will first train our kNN model on the training set.

Instead of predicting the conference for the test set, we can predict the confidence map for the entire area that wraps around the dimensions of our dataset.

Then, for each of those points, we will use our model to give a confidence score, and plot it with a [contour plot](https://plotly.com/julia/contour-plots/).

```julia
using PlotlyJS, MLJ, DataFrames

function mgrid(arrays...)
    lengths = collect(length.(arrays))
    uno = ones(Int, length(arrays))
    out = []
    for i in 1:length(arrays)
       repeats = copy(lengths)
       repeats[i] = 1

       shape = copy(uno)
       shape[i] = lengths[i]
       push!(out, reshape(arrays[i], shape...) .* ones(repeats...))
    end
    out
end

mesh_size = .02
margin = 0.25

X, y = make_moons(noise=0.3)
test, train = partition(eachindex(y), 0.75, shuffle=true)
df_X = DataFrame(X)

x_min, x_max = minimum(df_X[:, :x1]) - margin, maximum(df_X[:, :x1]) + margin
y_min, y_max = minimum(df_X[:, :x2]) - margin, maximum(df_X[:, :x2]) + margin

xrange = x_min:mesh_size:x_max
yrange = y_min:mesh_size:y_max

xx, yy = mgrid(xrange, yrange)

KNNClassifier = @load KNNClassifier
clf = KNNClassifier(K=15)
mach = machine(clf, X, y)
fit!(mach)
yhat = predict(mach, [xx[:] yy[:]])
Z = map(x->x.prob_given_ref[2], yhat)
Z = reshape(Z, size(xx))

plot(contour(
    x=xrange,
    y=yrange,
    z=Z,
    colorscale=colors.RdBu_8
))
```

Now, let's try to combine our `go.Contour` plot with the first scatter plot of our data points, so that we can visually compare the confidence of our model with the true labels.

```julia
using PlotlyJS, MLJ

function mgrid(arrays...)
    lengths = collect(length.(arrays))
    uno = ones(Int, length(arrays))
    out = []
    for i in 1:length(arrays)
       repeats = copy(lengths)
       repeats[i] = 1

       shape = copy(uno)
       shape[i] = lengths[i]
       push!(out, reshape(arrays[i], shape...) .* ones(repeats...))
    end
    out
end

# Load and split data
X, y = make_moons(noise=0.3)
test, train = partition(eachindex(y), 0.75, shuffle=true)
df = DataFrame(X)
df.y = y

# Create mesh grid
x_min, x_max = minimum(df[:, :x1]) - margin, maximum(df[:, :x1]) + margin
y_min, y_max = minimum(df[:, :x2]) - margin, maximum(df[:, :x2]) + margin
xrange = x_min:mesh_size:x_max
yrange = y_min:mesh_size:y_max
xx, yy = mgrid(xrange, yrange)

KNNClassifier = @load KNNClassifier
clf = KNNClassifier(K=15)
mach = machine(clf, X, y)
fit!(mach)
yhat = predict(mach, [xx[:] yy[:]])
Z = map(x->x.prob_given_ref[2], yhat)
Z = reshape(Z, size(xx))

trace_specs = [
    (df[train, :], 0, "Train", "square"),
    (df[train, :], 1, "Train", "circle"),
    (df[test, :], 0, "Test", "square-dot"),
    (df[test, :], 1, "Test", "circle-dot"),
]

traces = [
    scatter(
        x=data[data.y .== label, :x1],
        y=data[data.y .== label, :x2],
        name=string(split, " Split, Label ", label),
        mode="markers",
        marker=attr(
            symbol=marker,
            color="lightyellow",
            size=12,
            line_width=1.5
        )
    ) for (data, label, split, marker) in trace_specs
]

p = plot(traces)

add_trace!(p, contour(
    z=Z,
    x=xrange,
    y=yrange,
    showscale=false,
    colorscale=colors.RdBu_8,
    name="Score",
    opacity=0.4,
    hoverinfo="skip"
))

p
```

## Multi-class prediction confidence with [`heatmap`](https://plotly.com/julia/heatmaps/)

It is also possible to visualize the prediction confidence of the model using [heatmaps](https://plotly.com/julia/heatmaps/). In this example, you can see how to compute how confident the model is about its prediction at every point in the 2D grid. Here, we define the confidence as the difference between the highest score and the score of the other classes summed, at a certain point.

```python
import plotly.express as px
import plotly.graph_objects as go
import numpy as np
from sklearn.neighbors import KNeighborsClassifier

mesh_size = .02
margin = 1

# We will use the iris data, which is included in px
df = px.data.iris()
df_train, df_test = train_test_split(df, test_size=0.25, random_state=0)
X_train = df_train[['sepal_length', 'sepal_width']]
y_train = df_train.species_id

# Create a mesh grid on which we will run our model
l_min, l_max = df.sepal_length.min() - margin, df.sepal_length.max() + margin
w_min, w_max = df.sepal_width.min() - margin, df.sepal_width.max() + margin
lrange = np.arange(l_min, l_max, mesh_size)
wrange = np.arange(w_min, w_max, mesh_size)
ll, ww = np.meshgrid(lrange, wrange)

# Create classifier, run predictions on grid
clf = KNeighborsClassifier(15, weights='distance')
clf.fit(X_train, y_train)
Z = clf.predict(np.c_[ll.ravel(), ww.ravel()])
Z = Z.reshape(ll.shape)
proba = clf.predict_proba(np.c_[ll.ravel(), ww.ravel()])
proba = proba.reshape(ll.shape + (3,))

# Compute the confidence, which is the difference
diff = proba.max(axis=-1) - (proba.sum(axis=-1) - proba.max(axis=-1))

fig = px.scatter(
    df_test, x='sepal_length', y='sepal_width',
    symbol='species',
    symbol_map={
        'setosa': 'square-dot',
        'versicolor': 'circle-dot',
        'virginica': 'diamond-dot'},
)
fig.update_traces(
    marker_size=12, marker_line_width=1.5,
    marker_color="lightyellow"
)
fig.add_trace(
    go.Heatmap(
        x=lrange,
        y=wrange,
        z=diff,
        opacity=0.25,
        customdata=proba,
        colorscale='RdBu',
        hovertemplate=(
            'sepal length: %{x} <br>'
            'sepal width: %{y} <br>'
            'p(setosa): %{customdata[0]:.3f}<br>'
            'p(versicolor): %{customdata[1]:.3f}<br>'
            'p(virginica): %{customdata[2]:.3f}<extra></extra>'
        )
    )
)
fig.update_layout(
    legend_orientation='h',
    title='Prediction Confidence on Test Split'
)
fig.show()
```

```julia
using PlotlyJS, MLJ, DataFrames, CSV, CategoricalArrays

function mgrid(arrays...)
    lengths = collect(length.(arrays))
    uno = ones(Int, length(arrays))
    out = []
    for i in 1:length(arrays)
       repeats = copy(lengths)
       repeats[i] = 1

       shape = copy(uno)
       shape[i] = lengths[i]
       push!(out, reshape(arrays[i], shape...) .* ones(repeats...))
    end
    out
end

mesh_size = .02
margin = 1
# load iris dataset
df = dataset(DataFrame, "iris")

# Split into test and train sets
test, train = partition(eachindex(df.species_id), 0.75, shuffle=true)

# create a mesh grid on which we will run our model
lmin = minimum(df.sepal_length) - margin
lmax = maximum(df.sepal_length) + margin
wmin = minimum(df.sepal_width) - margin
wmax = maximum(df.sepal_width) + margin

lrange = lmin:mesh_size:lmax
wrange = wmin:mesh_size:wmax

ll, ww = mgrid(lrange, wrange)

# create classifier, run predictions on grid
KNNClassifier = @load KNNClassifier
clf = KNNClassifier(K=15)
mach = machine(
    clf,
    df[:, [:sepal_length,:sepal_width]],
    CategoricalArray(df[:, :species_id])
)
fit!(mach, rows=train)
yhat = predict(mach, [ll[:] ww[:]])
# Get predicted classification
Z = map(x->Int(argmax(x.prob_given_ref)), yhat)
# Get prediction probabilities
proba = map(x->[
    x.prob_given_ref[1],
    x.prob_given_ref[2],
    x.prob_given_ref[3]
],
    yhat
)
proba = reshape(proba, size(ll))
# Compute confidence
diff = maximum.(proba) .- (sum.(proba) .- maximum.(proba))

p = plot(
    df[test, :],
    x=:sepal_length,
    y=:sepal_width,
    mode="markers",
    marker=attr(
        symbol=:species_id,
        size=12, line_width=1.5,
        color="lightyellow"
    ),
    Layout(
        legend_orientation="h",
        title="Prediction Configdence on Test Split"
    )
)

add_trace!(p, heatmap(
    x=lrange,
    y=wrange,
    z=diff,
    opacity=0.25,
    customdata=proba,
    colorscale=colors.RdBu_8,
    hovertemplate=string(
        "sepal length: %{x} <br>",
        "sepal width: %{y} <br>",
        "p(setosa): %{customdata[0]:.3f}<br>",
        "p(versicolor): %{customdata[1]:.3f}<br>",
        "p(virginica): %{customdata[2]:.3f}<extra></extra>"
    )
))

p
```

### Reference

Learn more about `contour` and `heatmap` here:

- https://plot.ly/julia/heatmaps/
- https://plot.ly/julia/contour-plots/

This tutorial was inspired by amazing examples from the official scikit-learn docs:

- https://scikit-learn.org/stable/auto_examples/neighbors/plot_classification.html
- https://scikit-learn.org/stable/auto_examples/classification/plot_classifier_comparison.html
- https://scikit-learn.org/stable/auto_examples/datasets/plot_iris_dataset.html
