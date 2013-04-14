# clickme

**Clickme** is an R package that makes creating interactive JavaScript visualizations as easy as making a standard R plot.

Want to learn more? [See the wiki](https://github.com/nachocab/clickme/wiki) and join the [mailing list](https://groups.google.com/d/forum/rclickme).

## Quick Usage

Install the latest version of Clickme by running the following in your R console:

```S
install.packages("devtools") # run this if you don't have the devtools package installed.

library(devtools)
install_github("clickme", "nachocab")
```

Try the demos:

```S
library(clickme)

# See what ractives you have available
list_ractives()

# Pick a few and try them
demo_ractive("force_directed")

demo_ractive("line_with_focus")

demo_ractive("longitudinal_heatmap")

demo_ractive("par_coords")

demo_ractive("vega")
```

Your browser will open a new tab for each example. The first one should look something like [this](http://bl.ocks.org/nachocab/5178583).

## Acknowledgements
Thank you **Mike Bostock**. Making the [D3.js](http://d3js.org) library more accessible was my strongest motivation for developing Clickme.

Thank you **Yihui Xie**. The [knitr](https://github.com/yihui/knitr) R package has shown me the importance of building bridges across technologies, while also turning my scientific ramblings into reproducible work.

Thank you **Hadley Wickam**. The [testthat](https://github.com/hadley/test_that) R package is a big reason why I find coding Clickme so enjoyable.
