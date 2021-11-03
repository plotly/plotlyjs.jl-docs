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
    description: We will make Receiver Operating Characteristics (ROC) and Precision-Recall (PR) curves to Plotly with the Julia language.
    display_as: ai_ml
    language: julia
    layout: base
    name: ROC and PR Curves
    order: 3
    page_type: example_index
    permalink: julia/roc-and-pr-curves/
    thumbnail: ml-roc-pr.png
---

**Packages Used**: PlotlyJS, MLJBase, MLJLinearModels, *Random*, CategoricalArrays, DataFrames

*Italic* packages are Julia Standard Library Packages as of **v1.6**.

**Note**: The examples below are encapsulated in functions since it is best practice in Julia.


# Preliminary plots

Before diving into the receiver operating characteristic (ROC) curve, we will look at two plots that will give some context to the thresholds mechanism behind the ROC and PR curves.

In the histogram, we observe that the score spread such that most of the positive labels are binned near 1, and a lot of the negative labels are close to 0. When we set a threshold on the score, all of the bins to its left will be classified as 0's, and everything to the right will be 1's. There are obviously a few outliers, such as negative samples that our model gave a high score, and positive samples with a low score. If we set a threshold right in the middle, those outliers will respectively become false positives and false negatives.

As we adjust thresholds, the number of positive positives will increase or decrease, and at the same time the number of true positives will also change; this is shown in the second plot. As you can see, the model seems to perform fairly well, because the true positive rate decreases slowly, whereas the false positive rate decreases sharply as we increase the threshold. Those two lines each represent a dimension of the ROC curve.


We first plot the number of the distribution of prediction probabilities for two categories from the artificial `make_blobs` dataset from **MLJBase**. We have 5000 entries in our dataset. The model is from **MLJLinearModels**, and we use `histogram` plot the distributions.

```julia
using PlotlyJS, MLJBase, MLJLinearModels, Random

function display_binary_score_histogram()
    Random.seed!(42) # for reproducibility
    X, y = make_blobs(5000, 2; centers=2, cluster_std=1.5)
    mach = machine(LogisticClassifier(), X, y)
    fit!(mach)
    ŷ = predict(mach, X)
    
    fprs_trace = histogram(; x=pdf.(ŷ,1), name="Category 1", opacity=0.50)
    tprs_trace = histogram(; x=pdf.(ŷ,2), name="Category 2", opacity=0.50)
    layout = Layout(xaxis_title="Threshold", yaxis_title="Percentage", 
                    font=attr(family="Veranda", size=14,color="Black"))
    Plot([tprs_trace,fprs_trace], layout)
end

display_binary_score_histogram()
```
The following plot we look plot the false positive rate, `fprs`, and true positive rate, `tprs`, with **MLBase**'s roc function. **PlotlyJS** provides the scatter trace, so we can plot both.

```julia
using PlotlyJS, MLJBase, MLJLinearModels, Random

function display_binary_score_rate_threshold()
    Random.seed!(42) # for reproducibility
    X, y = make_blobs(5000, 2; centers=2, cluster_std=1.5)
    mach = machine(LogisticClassifier(), X, y)
    fit!(mach)
    
    fprs, tprs, ts = roc(predict(mach, X), y)
    fprs_trace = scatter(; x=ts, y=fprs, name="(fprs) False Positive Rate")
    tprs_trace = scatter(; x=ts, y=tprs, name="(tprs) True Positive Rate")
    layout = Layout(xaxis_title="Threshold", font=attr(family="Veranda", size=14,color="Black"))
    Plot([tprs_trace,fprs_trace], layout)
end

display_binary_score_rate_threshold()
```

# Basic Binary ROC Curve

Here we use the previous code with slight modifications. **MLJBase** offers a nice function `auc` to calculate the Area Under Curve Score, `aucs`. Nevertheless, **PlotlyJS**, allows one to make use of various styling options for line plots constructed from `scatter`.

Notice how this ROC curve looks similar to the True Positive Rate curve from the previous plot. This is because they are the same curve, except the x-axis consists of increasing values of FPR instead of threshold, which is why the line is flipped and distorted.

We also display the area under the ROC curve (ROC AUC), which is fairly high, thus consistent with our interpretation of the previous plots.

```julia

using DataFrames
using PlotlyJS
using ScikitLearn
@sk_import datasets: make_classification
@sk_import linear_model: LogisticRegression
@sk_import metrics: (roc_curve, auc)

X, y = make_classification(n_samples=500, random_state=0)

model = LogisticRegression()
model.fit(X, y)
y_score = model.predict_proba(X)[:, 2]

fpr, tpr, thresholds = roc_curve(y, y_score)

fig = plot(
    scatter(
        x=fpr,
        y=tpr,
        fill="tozeroy",
        width=700, height=500
    ),
    Layout(
        title_text="ROC Curve (AUC=$((auc(fpr, tpr))))",
        xaxis=attr(constrain="domain"),
        yaxis=attr(
            scaleanchor="x",
            scaleratio=1
        )
    )
)

add_shape!(
    fig,
    line(
        x0=0, x1=1, y0=0, y1=1,
        line=attr(dash="dash")
    )
)

fig
```

# Multiclass ROC Curve

In other languages, there are functions for calculating the multiclass ROC curves. For the time being Julia lacks a library with such a function. Nevertheless, the following code implements the simple logic for calculating multiclass ROC curves. Here we use the iris data set from **PlotlyJS**. **CategoricalArrays** is used to prepare the labels to be fed into `machine`. Similar to before, the plotting is simply more curves with `scatter`.

```julia
using PlotlyJS, MLJBase, MLJLinearModels, Random, CategoricalArrays, DataFrames

function display_multiclass_roc()
    Random.seed!(42) # for reproducibility
    df = DataFrame(dataset("iris"))
    df = df[shuffle(1:nrows(df)),:]
    X, y = unpack(df, x -> x!=:species && x!=:species_id, ==(:species))
    y = categorical(y)
    X = coerce(X, :petal_length => Continuous, :petal_width => Continuous, 
              :sepal_length => Continuous, :sepal_width => Continuous)
    
    train, test = partition(1:nrows(X), 0.5)
    mach = machine(LogisticClassifier(), X, y)
    fit!(mach; rows = train)
    
    ŷ = predict(mach, X[test, :])
    yt = y[test]
    
    ts = 0:0.01:1
    
    tprs = []
    fprs = []
    
    count_true_pos(preds, gts, thhold, class) = count(yy -> class==yy[1] && pdf(yy[2],class)>thhold, zip(gts,preds))
    count_false_pos(preds, gts, thhold, class) = count(yy -> class!=yy[1] && pdf(yy[2],class)>thhold, zip(gts,preds))
    
    for lvl in levels(yt)
        push!(tprs, [count_true_pos(ŷ, yt, t, lvl)/count(==(lvl),yt) for t in ts])
        push!(fprs, [count_false_pos(ŷ, yt, t, lvl)/count(!=(lvl),yt) for t in ts])
    end
    
    roc_traces = [scatter(; x=fprs[i], y=tprs[i], name=levels(yt)[i], opacity=0.65) for i in 1:length(levels(yt))]
    diagonal_trace = scatter(; x=0:0.1:1, y=0:0.1:1, mode="lines", line=attr(dash="dash", color="black"), 
                               name="baseline")
    layout = Layout(xaxis_title="False Positive Rate", yaxis_title="True Positive Rate", 
                    title = "Multiclass ROCs", 
                    font=attr(family="Veranda", size=14,color="Black"))
    Plot([roc_traces..., diagonal_trace], layout)
end

display_multiclass_roc()
```

# Precision-Recall Curves

In addition to ROC curves, one can also plot Precision-Recall (PR) curves. We use the previous code with a slight modification to plot PR curves instead of ROC curves.

```julia
using PlotlyJS, MLJBase, MLJLinearModels, Random, CategoricalArrays, DataFrames

function display_multiclass_roc()
    Random.seed!(42) # for reproducibility
    df = DataFrame(dataset("iris"))
    df = df[shuffle(1:nrows(df)),:]
    X, y = unpack(df, x -> x!=:species && x!=:species_id, ==(:species))
    y = categorical(y)
    X = coerce(X, :petal_length => Continuous, :petal_width => Continuous, 
              :sepal_length => Continuous, :sepal_width => Continuous)
    
    train, test = partition(1:nrows(X), 0.5)
    mach = machine(LogisticClassifier(), X, y)
    fit!(mach; rows = train)
    
    ŷ = predict(mach, X[test, :])
    yt = y[test]
    
    ts = 0:0.01:1
    
    precs = []
    reclls = []
    
    count_true_pos(preds, gts, thhold, class) = count(yy -> class==yy[1] && pdf(yy[2],class)>thhold, zip(gts,preds))
    count_false_pos(preds, gts, thhold, class) = count(yy -> class!=yy[1] && pdf(yy[2],class)>thhold, zip(gts,preds))
    count_correct(preds, gts, thhold, class) = count(yy -> class==yy[1] && pdf(yy[2],class)>thhold, zip(gts,preds)) + count(yy -> class!=yy[1] && pdf(yy[2],class)<thhold, zip(gts,preds))
    
    for lvl in levels(yt)
        push!(precs, [count_true_pos(ŷ, yt, t, lvl)/count(x -> pdf(x,lvl)>t, ŷ) for t in ts])
        push!(reclls, [count_true_pos(ŷ, yt, t, lvl)/count_correct(ŷ, yt, t, lvl) for t in ts])
    end
    
    roc_traces = [scatter(; x=reclls[i], y=precs[i], name=levels(yt)[i], opacity=0.65) for i in 1:length(levels(yt))]
    diagonal_trace = scatter(; x=0:0.1:1, y=1:-0.1:0, mode="lines", line=attr(dash="dash", color="black"), 
                               name="baseline")
    layout = Layout(xaxis_title="Recall", yaxis_title="Precision", 
                    title = "Multiclass ROCs", 
                    font=attr(family="Veranda", size=14,color="Black"))
    Plot([roc_traces..., diagonal_trace], layout)
end

display_multiclass_roc()
```

# ROC curve in Dash

```julia
using PlotlyJS
using Dash, DashCoreComponents, DashHtmlComponents
using ScikitLearn
using ScikitLearn.CrossValidation: train_test_split
@sk_import linear_model: LogisticRegression
@sk_import datasets: (load_iris, make_classification)
@sk_import metrics: (roc_curve, auc)
@sk_import tree: DecisionTreeClassifier
@sk_import neighbors: KNeighborsClassifier

X, y = make_classification(n_samples=1500, random_state=0)
X_train, X_test, y_train, y_test = train_test_split(
    X, y, random_state=42)

MODELS=Dict("Logistic" .=> LogisticRegression(),
            "Decision Tree" .=> DecisionTreeClassifier(),
            "k-NN" .=> KNeighborsClassifier())

app = dash()

app.layout = html_div(
    [
        html_p("Train Model:"),
        dcc_dropdown(
            id="model-name",
            options=[(label=k, value=k) for (k,v) in MODELS],
            value="Logistic",
            clearable=false
        ),
        dcc_graph(id="graph")
    ]
)

callback!(
    app,
    Output("graph", "figure"),
    Input("model-name", "value")
) do name 
    model = MODELS[name]
    model.fit(X_train, y_train)
    
    y_score = model.predict_proba(X)[:, 2]
    fpr, tpr, thresholds = roc_curve(y, y_score)
    score = auc(fpr, tpr)

    fig = plot(
        scatter(
            x=fpr,
            y=tpr,
            fill="tozeroy",
        ),
        Layout(
            title_text="ROC Curve (AUC=$(score))",
            xaxis_title="False Positive Rate",
            yaxis_title="True Positive Rate"           
        )
    )

    add_shape!(
    fig,
        line(
            x0=0, x1=1, y0=0, y1=1,
            line=attr(dash="dash")
        )
    )

    return fig
end

run_server(app, "0.0.0.0", debug=false)
```

# Further Reading

- [PlotlyJS Julia Documentation](http://juliaplots.org/PlotlyJS.jl/stable/)
	- [PlotlyJS Julia scatter](https://plotly.com/julia/line-and-scatter/)
- [Julia MLJ](https://alan-turing-institute.github.io/MLJ.jl/dev/)
- [MLJ Evaluating_Model_Performance](https://alan-turing-institute.github.io/MLJ.jl/dev/evaluating_model_performance/)
- [MLJ Machines](https://alan-turing-institute.github.io/MLJ.jl/dev/machines/)
- [MLJ Linear Models](https://juliaai.github.io/MLJLinearModels.jl/dev/)
- [Julia Categorical Arrays](https://categoricalarrays.juliadata.org/v0.2/index.html)
- [Julia Docs](https://docs.julialang.org/en/v1/)
    - [Julia Random](https://docs.julialang.org/en/v1/stdlib/Random/)
- [Julia Dataframes](https://dataframes.juliadata.org/stable/)
- [Julia make_blobs dataset](https://alan-turing-institute.github.io/MLJ.jl/dev/generating_synthetic_data/#Regression-data-generated-from-noisy-linear-models)
- [Google ROC Background](https://developers.google.com/machine-learning/crash-course/classification/roc-and-auc)