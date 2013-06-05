\name{matrix2json}
\alias{matrix2json}
\title{Convert a matrix to JSON}
\usage{
  matrix2json(mat)
}
\arguments{
  \item{mat}{input matrix object}
}
\description{
  It returns a string of nested arrays. One array per row.
}
\examples{
library(df2json)
df <- matrix(1:9, byrow = TRUE, nrow=3)
matrix2json(df)
}

