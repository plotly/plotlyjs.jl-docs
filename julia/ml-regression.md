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
    name: ML Regression
    order: 1
    page_type: example_index
    permalink: julia/ml-regression/
    thumbnail: thumbnail/ml-regression.png
---

Plotly in Julia interfaces nicely with the **DataFrames** and **Tables** objects. Julia also supports Scikit-learn, so one can transfer knowledge from such a widespread package. This page will present several ways to plot some basic plots of regression. The **GLM** (pure Julia) and **Scikit-learn** (python library) will be used to fit the models. Also, this page includes a basic Dash app.

**Packages Used**: CSV, *Downloads*, DataFrames, PlotlyJS, GLM, SciKitLearn, *Printf*, *Random*, Dash

*Italic* packages are Julia Standard Library Packages as of **v1.6**.

**Note**: The examples below are encapsulated in functions since it is best practice in Julia.

# Basic Linear Regression Plots

These sections will show a linear regression model. This section will present several ways to plot basic linear regressor, using **GLM.jl** and **Scikit-learn.jl**.


## Ordinary Least Square with GLM.jl (Generalized Linear Models)


This section will plot a trend line with `scatter` and GLM. We will pull data from the **R** language dataset repository with **CSV.jl**, **Downloads.jl**, and **DataFrames.jl**. In **PlotlyJS** the plots are made up of building blocks, traces. A `scatter_trace` and `regression_trace` are defined with the PlotlyJS scatter method. Note that the `x` and `y` are set to Symbol variables which are two feature names of the data set, `tips`.

The linear regression model is made with **GLM**'s lm method and its macro, @formula. The resulting model can be used to construct a line plot. To finish, one can define a layout with **PlotlyJS**'s Layout struct. **DataFrames**'s insertcols! is used to add the linear regression predicted values.

The plot is plotted with **PlotlyJS**'s plot method.

```julia
using CSV, Downloads, DataFrames, PlotlyJS, GLM

function plot_linear_regression_glm_tips()
    tips = DataFrame(CSV.File(Downloads.download("https://git.io/J6x4j")))
    
    scatter_trace = scatter(tips; x=:bill, y=:tip, mode="markers", opacity=0.65, name="Tips")    
    
    linear_model = lm(@formula(tip ~ bill), tips)
    insertcols!(tips, :lr_tips => GLM.predict(linear_model, tips))

    regression_trace = scatter(tips; x=:bill, y=:lr_tips, 
                               mode = "lines", line_color = "darkblue", name="Linear Regression")
    
    layout = Layout(xaxis_title="Total Bill", yaxis_title="Tips",
                    font=attr(family="Times New Roman", size=14,color="Black"))
    
    plot([scatter_trace,regression_trace], layout)
end

plot_linear_regression_glm_tips()
```

## Ordinary Least Square with ScikitLearn.jl

Julia offers an interface to the Scikit-learn library from Python as **ScikitLearn.jl**. With some minor changes, one can follow the previous section, but using **ScikitLearn.jl**.


```julia
using CSV, Downloads, DataFrames, PlotlyJS, ScikitLearn

function plot_linear_regression_skl_tips()
    tips = DataFrame(CSV.File(Downloads.download("https://git.io/J6x4j")))
    
    scatter_trace = scatter(tips; x=:bill, y=:tip, mode="markers", opacity=0.65, name="Tips")
    
    X = tips.bill
    y = tips.tip
    linear_model = ScikitLearn.Models.LinearRegression()
    ScikitLearn.fit!(linear_model, X, y)
    
    insertcols!(tips, :lr_tips => reshape(ScikitLearn.predict(linear_model, X),(:,)) )
    regression_trace = scatter(tips; x=:bill, y=:lr_tips, 
                               mode = "lines", line_color = "darkblue", name="Linear Regression")
    
    layout = Layout(xaxis_title="Total Bill", yaxis_title="Tips",
                    font=attr(family="Times New Roman", size=14,color="Black"))
    
    plot([scatter_trace,regression_trace],layout)
end

plot_linear_regression_skl_tips()
```

# ML Regression in Dash

**Dash** in Julia allows for the creation of useful dashboards. Starting with the previous section, one import any model from the **Scikit-learn** python library, using **ScikitLearn**'s `@sk_import macro`. With that we construct a simple Dash app to explore three different models: LinearRegression, DecisionTreeRegressor, and KNeighborsRegressor. To define the app one can use Julia's **do…end** syntax. Note that the helper function partitionTrainTest has been defined, but one can also use **ScikitLearn**'s, `ScikitLearn.CrossValidation.train_test_split`.

```julia
using CSV, Downloads, DataFrames, PlotlyJS, Dash, ScikitLearn, Random

@sk_import linear_model: LinearRegression
@sk_import tree: DecisionTreeRegressor
@sk_import neighbors: KNeighborsRegressor

Random.seed!(42)

function partitionTrainTest(data, at = 0.7)
    n = nrow(data)
    idx = shuffle(1:n)
    train_idx = view(idx, 1:floor(Int, at*n))
    test_idx = view(idx, (floor(Int, at*n)+1):n)
    data[train_idx,:], data[test_idx,:]
end

function lr_dash_app()
    
    models = Dict("Regression"=>LinearRegression, "Decision Tree"=> DecisionTreeRegressor, 
                  "k-NN"=>KNeighborsRegressor)
    
    app = dash()
    
    app.layout = html_div() do
        html_h1("Model Exploration with Dash"),
        html_div("Select a model:"),
        dcc_dropdown(id="model-name",
                     options = [(label = "Regression", value = "Regression"),
                                (label = "Decision Tree", value = "Decision Tree"),
                                (label = "k-NN", value = "k-NN")],
                     value = "Regression", clearable=false),
        dcc_graph(id="graph")
    end
    
    tips = DataFrame(CSV.File(Downloads.download("https://git.io/J6x4j")));
    
    tips_train, tips_test = partitionTrainTest(tips, 0.8)
    
    callback!(app, Output("graph", "figure"), Input("model-name", "value")) do model_name
        model = models[model_name]()
        ScikitLearn.fit!(model, reshape(tips_train.bill,(:,1)), reshape(tips_train.tip,(:,1)))

        sorted_test = sort(tips_test.bill)
        sorted_predicted = reshape(ScikitLearn.predict(model, reshape(sorted_test,(:,1)) ),(:,))
        regression_trace = scatter(; x=sorted_test, y=sorted_predicted, 
                                   mode = "lines", line_color = "darkred", name="Prediction")

        scatter_train = scatter(tips_train; x=:bill, y=:tip, 
                                mode = "markers", opacity=0.65, name="Train", color="blue")

        scatter_test = scatter(tips_test; x=:bill, y=:tip,
                               mode = "markers", opacity=0.65, name="Test", color="red")

        return plot([scatter_train,scatter_test, regression_trace])
    end

    run_server(app, "0.0.0.0")
end

lr_dash_app()
```

# Adding additional statistics

Expanding upon the first plot, one can also display some statistical data of the model. Here, we use the **Printf** library to format the title string. **GLM** offers several methods to extract the coefficients of the data. Using the error of the slope, the standard deviation error of the y-intercept is displayed.

```julia
using CSV, Downloads, DataFrames, PlotlyJS, GLM, Printf

function plot_linear_regression_glm_tips_with_stats()
    tips = DataFrame(CSV.File(Downloads.download("https://git.io/J6x4j")))
    
    scatter_trace = scatter(tips; x=:bill, y=:tip, mode="markers", opacity=0.65, name="Tips")
    
    linear_model = lm(@formula(tip ~ bill), tips)
    insertcols!(tips, :lr_tips => GLM.predict(linear_model, tips))

    regression_trace = scatter(tips; x=:bill, y=:lr_tips, 
                               mode = "lines", line_color = "darkblue", name="Linear Regression")
    
    slope_stderror = stderror(linear_model)[1]
    regression_trace_upper = scatter(; x=tips.bill, y=tips.lr_tips .+ slope_stderror, 
                                     mode = "lines", line_color = "darkred", opacity=0.65, name="+ 1 STD")
    
    regression_trace_lower = scatter(; x=tips.bill, y=tips.lr_tips .- slope_stderror, 
                                     mode = "lines", line_color = "darkred", opacity=0.65, name="- 1 STD")
    
    plot_title = @sprintf "R²=%.3f, slope=%.3f, y-intercept=%.3f" r2(linear_model) coef(linear_model)[2] coef(linear_model)[1]
    layout = Layout(xaxis_title="Total Bill", yaxis_title="Tips", title=plot_title,
                    font=attr(family="Times New Roman", size=14, color="Black"))
    
    plot([scatter_trace,regression_trace,regression_trace_upper,regression_trace_lower], layout)
end

plot_linear_regression_glm_tips_with_stats()
```

# Further Reading

- [PlotlyJS Julia Documentation](http://juliaplots.org/PlotlyJS.jl/stable/)
	- [PlotlyJS Julia scatter](https://plotly.com/julia/line-and-scatter/)
- [GLM Documentation](https://juliastats.org/GLM.jl/stable/)
- [Scikitlearn.jl Github](https://github.com/cstjean/ScikitLearn.jl)
- [Dash.jl](https://dash-julia.plotly.com/)
    - **Note**: Some code is out of date.
    - [Dash.jl Layout](https://dash-julia.plotly.com/getting-started)
    - [Dash.jl Callbacks](https://dash-julia.plotly.com/basic-callbacks)
- [Julia Docs](https://docs.julialang.org/en/v1/)
    - [Julia Downloads](https://docs.julialang.org/en/v1/stdlib/Downloads/)
    - [Julia Printf](https://docs.julialang.org/en/v1/stdlib/Printf/)
    - [Julia Random](https://docs.julialang.org/en/v1/stdlib/Random/)
- [Julia CSV](https://csv.juliadata.org/stable/)
- [Julia Dataframes](https://dataframes.juliadata.org/stable/)
- [(R)Dataset Repo](https://vincentarelbundock.github.io/Rdatasets/articles/data.html)