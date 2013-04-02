\name{create_data_file}
\alias{create_data_file}
\title{Create a data file}
\usage{
  create_data_file(data, opts, extension, sep = ",",
    method = NULL, row.names = FALSE, ...)
}
\arguments{
  \item{data}{the input data object}

  \item{opts}{the options of the current template}

  \item{extension}{the extension of the file}

  \item{sep}{the character used to separate fields in each
  line of the file ("," by default)}

  \item{method}{function used to generate the file (".csv"
  uses "write.csv" by default, every other file extension
  uses "writeLines")}

  \item{row.names}{show row names when using
  \code{write.csv}}

  \item{...}{arguments passed to the function specified by
  method}
}
\description{
  Creates a file in the ractive data directory
}

