# clickme

**clickme** is a package that lets you use R objects as input for JavaScript visualizations.

JS libraries like [D3.js][] or [Raphaël.js][] can be used to generate powerful visualizations that run on the browser, giving users unprecedented levels of interactivity and flexibility. Unfortunately, they are hard to access within R. The design goal of **clickme** is to make them as easy to use as the base `plot()` function.

The variables used in JS visualizations are statically-defined, making them hard to customize. Instead of using static JS files, clickme works with **templates** that allow users to specify the input data that will be used by the JS code, along with other parameters that affect the behavior of the visualization.

Each template is embedded into a simple folder structure called a **ractive** (short for *interactive*—a hat tip to [Neal Stephenson](https://en.wikipedia.org/wiki/The_Diamond_Age)), which is designed to improve reusability, encourage sharing, and minimize overhead.

Want to learn more? [See the wiki]().

## Quick Usage

You can install clickme by running this in your R session:

```r
install.packages("devtools") # In case you don't have it already installed

library(devtools)
install_github("clickme", "nachocab")
```

Now you can try the examples:

```r
library(clickme)

# visualize a force-directed interactive graph
items <- paste0("GENE_", 1:40)
n <- 30
df1 <- data.frame(a=sample(items, n, replace=TRUE), b=sample(items, n, replace=TRUE), type=sample(letters[1:3], n, replace=TRUE))
clickme(df1, "force_directed")

# visualize a line plot that allows zooming along the x-axis
n <- 30
cities <- c("Boston", "NYC", "Philadelphia")
df2 <- data.frame(name=rep(cities, each=n), x=rep(1:n,length(cities)), y=c(sort(rnorm(n)),-sort(rnorm(n)),sort(rnorm(n))))
clickme(df2, "line_with_focus")

# visualize an interactive heatmap alongside a parallel coordinates plot
rownames(df3) <- paste0("GENE_", 1:25)
colnames(df3) <- paste0("sample_", 1:8)
clickme(df3, "longitudinal_heatmap") # you will need to have a local server running for this example to work
```

Your browser will open a new tab for each example. The first one should look something like [this](http://bl.ocks.org/nachocab/5178583).

## Acknowledgements
Thank you **Mike Bostock** for creating the [D3.js][] library. Being able to use it more effectively is the main reason why I developed clickme.

Thank you **Yihui Xie** for building the [knitr][] R package. Even though clickme only uses knitr as a templating engine, it is the most important part of my daily workflow.

## Contributing
If you can see the potential of clickme as a bridge between the R and JS worlds, please contribute by improving the source code or making your ractives publicly available.

[D3.js]: http://d3js.org
[Raphaël.js]: http://raphaeljs.com
[knitr]: http://yihui.name/knitr/


