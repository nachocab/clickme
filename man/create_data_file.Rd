\name{create_data_file}
\alias{create_data_file}
\title{Create a data file}
\usage{
  create_data_file(opts, extension, sep = ",",
    method = NULL, row_names = FALSE, relative_path = TRUE,
    quote_escaped = TRUE, ...)
}
\arguments{
  \item{opts}{the options of the current template}

  \item{extension}{the extension of the file}

  \item{sep}{the character used to separate fields in each
  line of the file ("," by default)}

  \item{method}{function used to generate the file (".csv"
  uses "write.csv" by default, every other file extension
  uses "writeLines")}

  \item{row_names}{show row names when using
  \code{write.csv}}

  \item{relative_path}{boolean indicating if the path to
  the file should be relative or absolute}

  \item{quote_escaped}{boolean indicating if the file name
  should be surrounded with escaped quotes.}

  \item{...}{arguments passed to the function specified by
  method}
}
\description{
  Creates a file in the ractive data directory
}

