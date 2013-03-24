\name{clickme}
\alias{clickme}
\title{Generates a JavaScript visualization}
\usage{
  clickme(data, ractive, params = NULL, data_name = NULL,
    html_file_name = NULL, browse = interactive(),
    port = 8888)
}
\arguments{
  \item{data}{input data}

  \item{ractive}{template id, it must match a folder within
  \code{set_root_path}}

  \item{params}{list containing the parameters and values
  that will be accessible from the template}

  \item{data_name}{name used to identify the output HTML
  file, default "dataRANDOMSTRING"}

  \item{html_file_name}{name of the output HTML file that
  contains the visualization, default
  "data_name-ractive.html"}

  \item{browse}{open browser, default TRUE}

  \item{port}{port used to open a local browser, default
  8888}
}
\description{
  Generates a JavaScript visualization
}
\examples{
library(clickme)

# visualize a zoomable phylogenetic tree (www.onezoom.org)
mammals_path <- system.file(file.path("examples", "one_zoom", "data", "mammals.tree"), package="clickme")
clickme(mammals_path, "one_zoom")

# visualize a force-directed interactive graph
items <- paste0("GENE_", 1:40)
n <- 30
df1 <- data.frame(a = sample(items, n, replace = TRUE), b = sample(items, n, replace = TRUE), type = sample(letters[1:3], n, replace=TRUE))
clickme(df1, "force_directed")

# visualize a line plot that allows zooming along the x-axis
n <- 30
cities <- c("Boston", "NYC", "Philadelphia")
df2 <- data.frame(name = rep(cities, each = n), x = rep(1:n, length(cities)), y = c(sort(rnorm(n)), -sort(rnorm(n)),sort(rnorm(n))))
clickme(df2, "line_with_focus")

# visualize an interactive heatmap next to a parallel coordinates plot
df3 <- matrix(rnorm(200), ncol = 8,nrow = 25)
rownames(df3) <- paste0("GENE_", 1:25)
colnames(df3) <- paste0("sample_", 1:8)
clickme(df3, "longitudinal_heatmap") # you will need to have a local server for this one. Try running server() if you have python installed
}

