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
    description: Visualize k-Nearest Neighbors (kNN) classification in Julia with PlotlyJS.jl.
    display_as: ai_ml
    language: julia
    layout: base
    name: kNN Classification
    order: 2
    page_type: example_index
    permalink: julia/knn-classification/
    thumbnail: thumbnail/knn-classification.png
---

**Packages Used**: DataFrames, MLJBase, NearestNeighborModels, *Random*, PlotlyJS

*Italic* packages are Julia Standard Library Packages as of **v1.6**.

**Note**: The examples below are encapsulated in functions, since it is best practice in Julia.

# Binary Classification

kNN(Nearest Neighbors) uses voting of k nearest neighbors to classify data. Within Julia there is the **MLJ** library that offers an interface to use/search for various machine learning models. We will be using **MLJBase** which offers the minimum functions for data manipulation, sample data, and model construction (as machines in MLJ lingo). The kNN model to be used is from the **NearestNeighborModels** Julia package.

## Test/Train Data Visualization with a Scatter Plot

We will use a scatter plot to visualize some artificial moons data (from the make_moons method), separated into test/train datasets. The moons dataset has binary categories 0 and 1. Since **PlotlyJS** is easier to use with DataFrames, we change the moons data's form into a DataFrame. The train/test dataset are arrays of indices to be used later to select the correct DataFrame rows. options, A list of NamedTuples, is used to construct an array of scatter traces. We use the array of traces with a layout object to construct a Plot, which is returned.

```julia
using DataFrames, MLJBase, Random, PlotlyJS

function display_binary_test_train_scatter_plot()
    Random.seed!(42) # for reproducibility
    X, y = make_moons(100; noise=0.1)
    train, test = partition(1:nrows(X), 0.8, shuffle=true)
    df = DataFrame(X)
    insertcols!(df, :y=>y)
    
    options = ((name="Train 0", color="Blue", part=train, symbol="circle-open", y=0),
               (name="Train 1", color="Red",  part=train, symbol="circle-open", y=1),
               (name="Test 0",  color="Blue", part=test,  symbol="square-open", y=0),
               (name="Test 1",  color="Red",  part=test,  symbol="square-open", y=1))
    
    test_train_traces = GenericTrace[]
    for opt in options
        trace_df = filter(r->r.y == opt.y, df[opt.part,:]) # filters for y value and test/train rows
        test_train_trace = scatter(trace_df; x=:x1, y=:x2, mode="markers", name=opt.name,  
                                   marker=attr(size=10,color=opt.color, symbol=opt.symbol))
        push!(test_train_traces, test_train_trace)
    end

    layout = Layout(xaxis_title="x₁", yaxis_title="x₂", font=attr(family="Veranda", size=14,color="Black"))
    Plot(test_train_traces,layout)
end

display_binary_test_train_scatter_plot()
```

## Visualization of Test Data/Performance

Using the same data as before, one can also visualize performance on the test dataset. A notable difference is the model, knnc, and its machine binding, `knnc_mach`. We train the model with the `fit`! method. For convenience, the predictions on the test data is added as a column to the DataFrame, df. A color scale `blue_red_cs` is generated, passed for the value `colorscale`.

We generate two scatter plots. One is for the test data, and one is for the prediction. With PlotlyJS, one can plot these on top of each other using different `size` values for both plots. The orientation is the same as before, but the legend orientation is altered, so it's not hidden by the color bar.

```julia
using DataFrames, MLJBase, NearestNeighborModels, Random, PlotlyJS

function display_binary_test_pred_scatter_plot()
    Random.seed!(42) # for reproducibility
    X, y = make_moons(100; noise=0.1)
    train, test = partition(1:nrows(X), 0.8, shuffle=true)
    
    knnc = KNNClassifier(weights = Inverse(); K=5)
    knnc_mach = machine(knnc, X, y)
    fit!(knnc_mach, rows=train)
    
    df = DataFrame(X)[test,:]
    insertcols!(df, :y_test=>y[test], :y_pred=>predict(knnc_mach, rows=test))
    
    blue_red_cs = [[0, "Blue"], [1, "Red"]]
    
    test_trace = scatter(df; x=:x1, y=:x2, mode="markers", name="Tests",
                    marker=attr(color=:y_test, size=10, opacity=0.65, colorscale=blue_red_cs))
    
    pred_trace = scatter(df; x=:x1, y=:x2, mode="markers", name="Predictions",
                    marker=attr(color=pdf.(df.y_pred,1), size=15, opacity=0.70, colorscale=blue_red_cs, 
                                symbol="square", showscale=true))
    
    layout = Layout(xaxis_title="x₁", yaxis_title="x₂", legend=attr(orientation='h'),
                    font=attr(family="Veranda", size=14,color="Black"))
    
    Plot([pred_trace,test_trace], layout)
end

display_binary_test_pred_scatter_plot()
```

## Classification Visualization with a Contour Plot

For a more comprehensive visualization of the model. One can used heatmap to evaluate the confidence of the model. We use **MLJBase**'s `pdf` and `predict` to construct an array of probabilities a location is the 1 category.

**NOTE**: There is no test/train data split here.

```julia
using DataFrames, MLJBase, NearestNeighborModels, Random, PlotlyJS

function display_binary_probability_contour()
    Random.seed!(42) # for reproducibility
    X, y = make_moons(100; noise=0.1)
    
    knnc = KNNClassifier(weights = Inverse(); K=5)
    knnc_mach = machine(knnc, X, y)
    fit!(knnc_mach, rows=1:nrows(X))
    
    div_length=100
    x_divs = range(-1.5,stop=3,length=div_length)
    y_divs = range(-3,stop=3,length=div_length)
    
    z_values = pdf.(predict(knnc_mach, [(x1=x,x2=y) for x in x_divs for y in y_divs]),1)
    z_array = reshape(z_values, (div_length,div_length))
    prob_contour_trace = contour(x=x_divs, y=y_divs, z=z_array; colorscale="RdBu")
    
    layout = Layout(xaxis_title="x₁", yaxis_title="x₂", legend=attr(orientation='h'),
                    font=attr(family="Veranda", size=14,color="Black"))
    
    Plot([prob_contour_trace], layout)
end

display_binary_probability_contour()
```

# Multi-class Classification

kNN can also be used for multiclass classification. We will be using the same model from the **NearestNeighborModels**, but with a different dataset. The dataset is the well-known iris dataset. We will use the one from PlotlyJS via dataset.

## Test/Train Classification Visualization with a Scatter Plot

Instead of using shapes to distiguished betwen testing and training, we will be using colors. Using Julia's "dot notation", one can contruct a string arrary made that labels all the instances of our training data. Instead of `scatter`, the `Plot` constructor is used. This has the convinience of automatically coloring our categories. Since we have three class and test/train parts, that makes six difference categories to plot.

**Note**: With Plot objects, one can manually change aspects of the plot. This was done with the legend title.

```julia
using DataFrames, MLJBase, Random, PlotlyJS

function display_multiclass_scatter_plot()
    Random.seed!(42) # for reproducibility
    df = DataFrame(dataset("iris"))
    
    train, test = partition(1:nrows(df), 0.7; shuffle=true)
    
    testortrain(x) = x in test ? "Test" : "Train"
    DataFrames.insertcols!(df, :species_tt => (uppercasefirst.(df.species) .* '-' .* testortrain.(1:nrows(df))))
    
    layout = Layout(xaxis_title="Sepal Length", yaxis_title="Petal Width",
                    font=attr(family="Veranda", size=14,color="Black"))
    
    out_plot = Plot(df,layout; x=:sepal_length, y=:petal_width, mode="markers", color=:species_tt,
                               marker=attr(symbol="square", size=10))
    out_plot.layout["legend"][:title][:text] = "Species-(Test/Train)"
    
    out_plot
end

display_multiclass_scatter_plot()
```

## Probability Plot with a Heatmap

Here we use a heatmap to visualize the confidence of the data (ie the max probability) of a given probabilistic prediction. We continue to use the iris dataset. Nevertheless, in order to get the data into the correct for we used unpack and `coerce` from `MLJBase` and `ScientificTypes` respectively. The heatmap values generated from **MLJBase**'s `predict`, `pdf`, and `levels`. A helper function, is used to get the confidence from predict's output. A `heatmap` and `scatter` plot are used to visualize the confidence and the iris dataset.

```julia
using DataFrames, MLJBase, NearestNeighborModels, Random, PlotlyJS

function display_multiclass_heatmap()
    Random.seed!(42) # for reproducibility
    df = DataFrame(dataset("iris"))
    
    X, y = unpack(df, x -> x==:sepal_length || x==:petal_width, ==(:species); :species=>Multiclass)
    Xc = coerce(X, Any =>Continuous)
    
    knnc = KNNClassifier(weights = Inverse(); K=10)
    knnc_mach = machine(knnc, Xc, y)
    fit!(knnc_mach, rows=1:nrows(Xc))
    
    div_length=200
    x_divs = range(-0.1,stop=3,length=div_length)
    y_divs = range(4,stop=9,length=div_length)
    predictions = predict(knnc_mach, [(sepal_length=x,petal_width=y) for x in x_divs for y in y_divs])
    
    getconfidence(x) = maximum(pdf(x,levels(x)))
    confidence_values = getconfidence.(predictions)
    confidence_array = reshape(confidence_values, (div_length,div_length))
    
    heatmap_trace = heatmap(x=x_divs,y=y_divs,z=confidence_array, colorscale="RdBu")
    scatter_trace = scatter(df; x=:petal_width, y=:sepal_length, mode="markers", text=:species,
                                marker=attr(color="Black", size=5))
    
    layout = Layout(xaxis_title="Sepal Length", yaxis_title="Petal Width", title="kNN (k=5) Confidence Heatmap",
                    font=attr(family="Veranda", size=14,color="Black"))
    
    Plot([heatmap_trace,scatter_trace], layout)
end

display_multiclass_heatmap()
```

# Further Reading

- [PlotlyJS Julia Documentation](http://juliaplots.org/PlotlyJS.jl/stable/)
	- [PlotlyJS Julia scatter](https://plotly.com/julia/line-and-scatter/)
    - [PlotlyJS Julia contour plots](https://plotly.com/julia/contour-plots/)
    - [PlotlyJS Julia heatmap](https://plotly.com/julia/heatmaps/)
- [Julia Docs](https://docs.julialang.org/en/v1/)
    - [Julia Random](https://docs.julialang.org/en/v1/stdlib/Random/)
    - [Julia's dot notation (broadcasting)](https://docs.julialang.org/en/v1/manual/arrays/#Broadcasting)
- [NearestNeighborModels.jl (kNN classifier model)](https://juliaai.github.io/NearestNeighborModels.jl/dev/)
 - [Julia MLJ (the ML interface)](https://alan-turing-institute.github.io/MLJ.jl/dev/)
    - [MLJ Getting Started](https://alan-turing-institute.github.io/MLJ.jl/dev/getting_started/)
    - [MLJ Cheatsheet](https://alan-turing-institute.github.io/MLJ.jl/dev/mlj_cheatsheet/)
    - [MLJ Working with Multiclass Data](https://alan-turing-institute.github.io/MLJ.jl/dev/working_with_categorical_data/)
- [Moons \"Dataset\"](https://juliaai.github.io/MLJBase.jl/stable/datasets/#MLJBase.make_moons)
- [iris data set](https://github.com/plotly/datasets)
- [Julia Dataframes](https://dataframes.juliadata.org/stable/)