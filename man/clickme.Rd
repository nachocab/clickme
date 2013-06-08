\name{clickme}
\alias{clickme}
\title{Generates a JavaScript visualization}
\usage{
  clickme(data, ractive, params = NULL,
    open = interactive(), link = FALSE, ...)
}
\arguments{
  \item{data}{input data}

  \item{ractive}{template id, it must match a folder within
  \code{set_templates_path}}

  \item{params}{parameters}

  \item{open}{open browser tab with the generated
  visualization.}

  \item{...}{additional arguments for \code{get_opts}}
}
\description{
  Generates a JavaScript visualization
}
\examples{
library(clickme)

# visualize a force-directed interactive graph
items <- paste0("GENE_", 1:40)
n <- 30
df1 <- data.frame(source = sample(items, n, replace = TRUE), target = sample(items, n, replace = TRUE), type = sample(letters[1:3], n, replace = TRUE))
clickme(df1, "force_directed")
}

