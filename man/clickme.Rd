\docType{package}
\name{clickme}
\alias{clickme}
\alias{clickme-package}
\title{Straight from R to JS: Create interactive visualizations from R}
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
  Straight from R to JS: Create interactive visualizations
  from R

  Generates a JavaScript visualization
}
\section{Package options}{
  Clickme uses the following \code{options} to configure
  behaviour:

  \itemize{

  \item \code{clickme_templates_path}: path where the
  templates are stored

  \item \code{clickme_output_path}: path where the
  generated visualizations are saved (along with their
  dependencies)

  }
}
\examples{
library(clickme)

# visualize a force-directed interactive graph
items <- paste0("GENE_", 1:40)
n <- 30
df1 <- data.frame(source = sample(items, n, replace = TRUE), target = sample(items, n, replace = TRUE), type = sample(letters[1:3], n, replace = TRUE))
clickme(df1, "force_directed")
}
\author{
  Nacho Caballero <\url{http://reasoniamhere.com}>
}
\references{
  Full documentation:
  \url{https://github.com/nachocab/clickme/wiki};
}

