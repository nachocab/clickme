\name{json2df}
\alias{json2df}
\title{Convert a JSON string into a data frame}
\usage{
  json2df(json)
}
\arguments{
  \item{json}{input json object}
}
\description{
  Convert a JSON string into a data frame
}
\examples{
library(df2json)
json <- "[{\\"a\\":1, \\"b\\":2},{\\"a\\":3,\\"b\\":4}]"
json2df(json)
}

