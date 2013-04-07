\name{\%||\%}
\alias{\%||\%}
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
d <- a \%||\% b # d == "a"
a <- NULL
d <- a \%||\% b # d == "b"
}

