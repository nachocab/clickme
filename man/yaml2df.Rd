\name{yaml2df}
\alias{yaml2df}
\title{Convert a YAML string into a data frame}
\usage{
  yaml2df(yaml)
}
\arguments{
  \item{yaml}{input yaml object}
}
\description{
  Convert a YAML string into a data frame
}
\examples{
library(df2json)
yaml <- "- a: 1.0\\n  b: 2.0\\n- a: 3.0\\n  b: 4.0\\n"
yaml2df(json)
}

