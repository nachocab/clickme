# Clickme

**Clickme** is an R package that lets you create interactive visualizations in the browser directly from your R session.

That means you don't have to generate boring static plots ever again.

## Install

Run the following R code:

```S
install.packages("devtools") # you don't need to run this command if you already have the devtools package installed.

library(devtools)
install_github("clickme", "nachocab")
```

## Examples

Let's take it out for a spin.

```S
library(clickme)
clickme("points", rnorm(1:100)) # try zooming in and out, click the Show names button, hover over points
```
Here is the [interactive version](http://)

You can put

## Resources

* Clickme is served with [a generous serving of wiki](https://github.com/nachocab/clickme/wiki).
* There is also [a mailing list](https://groups.google.com/d/forum/rclickme) where you can share your thoughts with people who care about pixels.
* There are other fine people trying to move visualization to the browser. Check out [rCharts](http://rcharts.io/) by Ramnath Vaidyanathan.

## Acknowledgements
Thank you **Mike Bostock**. Making the [D3.js](http://d3js.org) library more accessible was my strongest motivation for developing Clickme.

Thank you **Yihui Xie**. The [knitr](https://github.com/yihui/knitr) R package has shown me the importance of building bridges across technologies, while also turning my scientific ramblings into reproducible work.

Thank you **Hadley Wickam**. The [testthat](https://github.com/hadley/test_that) R package has been consistently saving my butt since I started coding for a living.
