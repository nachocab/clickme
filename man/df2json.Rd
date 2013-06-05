\name{df2json}
\alias{df2json}
\title{Convert a data frame to JSON}
\usage{
  df2json(df)
}
\arguments{
  \item{df}{input dataframe object}
}
\description{
  It returns a string that contains an array of objects.
  There are as many JS objects as there are rows in the
  data frame. The column names are used as the keys of each
  object. The objects are separated by newlines.
}
\examples{
df <- data.frame(name=c("a", "b", "c"), x=c(NA, 2 ,3), y=c(10, 20, -Inf), show=c(TRUE, FALSE, TRUE))
df2json(df)
}

