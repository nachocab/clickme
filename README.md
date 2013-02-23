# clickme

clickme integrates R objects with JavaScript visualizations.


## Installation

```r
install.packages("devtools")
library(devtools)
install_github("clickme","nachocab")
```

## Motivation
How can we enjoy the flexibility of JS without straying from our R workflow. clickme.
What is great about JS viz is that you can interact, but they are a pain to adapt to a new dataset. R makes reusing plots with different datasets easy, but the plots are static. Clickme bridges the gap between static R plots and dynamic JS visualizations. If you are allergic to JS, you can write them in CoffeeScript using the knitr engine (thanks Yihui)

you have to specify the list of scripts and styles (order is important)

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
Templates are the backbone behind clickme, they can use any javascript library, although I have only tested D3 so far. Once you make a visualization you like to use you can share it [here](linkto clickme_templates)
The templates that come by default are in D3

## Creating a visualization template
Converting data.frames to JSON is ideal because it means you can refer to each column by name, irrespective of the order. This isn't true for CSV files, where each column has a number.

## Report a bug
Report them [here](link).