# clickme

**clickme** is an R package that makes JavaScript visualizations using R data objects as input. Its goal is to make interactive visualizations as easy to use as the base `plot` function.

Instead of static JS files, clickme works with [**ractives**](https://github.com/nachocab/clickme/wiki/Ractive-Structure) (short for *interactives*—a hat tip to [Neal Stephenson](https://en.wikipedia.org/wiki/The_Diamond_Age)), which are simple folder structures that contain a **template** file used to populate the JS code with R input data. This model makes visualizations easy to access and reuse within R.

Want to learn more? [See the wiki](https://github.com/nachocab/clickme/wiki).

## Quick Usage

Run this in your R session to install or update to the latest version of clickme:

```S
install.packages("devtools")

library(devtools)
install_github("clickme", "nachocab")
```

Now you can try the demos:

```S
library(clickme)

# see what ractives you have available
list_ractives()

# Pick one and run the examples
demo_ractive("force_directed")

demo_ractive("par_coords")

demo_ractive("longitudinal_heatmap")

demo_ractive("scatterplot")

demo_ractive("vega")
```

Your browser will open a new tab for each example. The first one should look something like [this](http://bl.ocks.org/nachocab/5178583).

## Acknowledgements
Thank you **Mike Bostock** for creating the [D3.js][] library. Being able to use it more effectively is the main reason why I developed clickme.

Thank you **Yihui Xie** for building the [knitr][] R package. Even though clickme only uses knitr as a templating engine, it is the most important part of my daily workflow.

## Contributing
If you can see the potential of clickme as a bridge between the R and JS worlds, please contribute by building a ractive, [reporting an issue](https://github.com/nachocab/clickme/issues), or improving the source code.

[D3.js]: http://d3js.org
[knitr]: https://github.com/yihui/knitr


