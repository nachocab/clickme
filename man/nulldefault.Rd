\name{\%or\%}
\alias{\%or\%}
\title{Set default value}
\usage{
  a \%||\% b
}
\arguments{
  \item{a}{an object}

  \item{b}{an object}
}
\description{
  If a is not null, return a. Otherwise, return b.
}
\examples{
a <- "a"
b <- "b"
d <- a \%or\% b # d == "a"
a <- NULL
d <- a \%or\% b # d == "b"
}

