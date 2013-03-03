# clickme

clickme integrates R objects with JavaScript visualizations.

I love R and I love JavaScript visualizations (especially those made with the D3 library).

What you need:
A computer with a UNIX terminal (Windows support is coming)
A template
R

It is easier to write a translator function than to modify the javascript visualization.

We encourage using tests to make sure the format is correct.

clickme is an R package that lets you plot your data on the browser using JavaScript visualizations. So you can do

```r
library(clickme)
df <- data.frame(a=rnorm(50), b=rnorm(50), names=paste0("point_", 1:50))
clickme(df, "nachocab_scatterplot")
```

You should put set_clickme_path() in your .Rprofile

```
Create a server in the path ~/my_viz (by doing, for example: python -m SimpleHTTPServer)
and browse to http://localhost:8888/data_nachocab_scatterplot.html
```


Which generates the html file containing your visualization. To open it start a server in the location indicated. See here for a live example.


## Motivation
Setting up all those scripts and external is a pain, but with clickme ractives you only have to set it up once.

## Usage

## Installation

```r
install.packages("devtools")
library(devtools)
install_github("clickme","nachocab")
```

## Motivation
How can we enjoy the flexibility of JS without straying from our R workflow. clickme.
What is great about JS viz is that you can interact, but they are a pain to adapt to a new dataset. R makes reusing plots with different datasets easy, but the plots are static. Clickme bridges the gap between static R plots and dynamic JS visualizations. If you are allergic to JS, you can write them in CoffeeScript using the knitr engine (thanks Yihui)

you have to specify the list of scripts and external (order is important)

JS (especially D3) visualizations are awesome, interactive, but I'd like to access them from R, providing my own R objects as input. Roadblock: static variable names, so we build ractives with a defined folder structure that can interpret R objects, use knit_expand to substitute the curly braces.

ractives are self-contained

template config
    numeric
    character
    logical

It is a way to take an R data.frame and visualize it using JS.
It is a way to add interactivity into your workflow, by building reusable JS interactive plots.

Restrictions in using JavaScript visualizations
* Hard to change the input, so they don't get reused.
* Fixed named variables: clickme allows you to specify what variables are expected by each template and does tries to rename the columns of your R dataframe accordingly.
* Use files instead of objects is often more efficient
*
Uses knitr for templating and the CoffeeScript engine

## Usage


## Loading a visualization template
A visualization template is an Rmd file with embedded javascript or CoffeeScript code. It is populated with an R data.frame. It specifies how this data.frame should be prepared and the default opts (width, height, etc.)
ractives are the backbone behind clickme, they can use any javascript library, although I have only tested D3 so far. Once you make a visualization you like to use you can share it [here](linkto clickme_ractives)
The ractives that come by default are in D3

## Creating a visualization template
Converting data.frames to JSON is ideal because it means you can refer to each column by name, irrespective of the order. This isn't true for CSV files, where each column has a number.

## Report a bug
Report them [here](link).