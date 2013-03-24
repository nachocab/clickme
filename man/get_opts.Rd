\name{get_opts}
\alias{get_opts}
\title{Get options used by the current ractive}
\usage{
  get_opts(ractive, params = NULL, data_name = NULL,
    html_file_name = NULL)
}
\arguments{
  \item{ractive}{name of the reactive}

  \item{params}{list containing the parameters and values
  that will be accessible from the template}

  \item{data_name}{name used to identify the output HTML
  file, default "dataRANDOMSTRING"}

  \item{html_file_name}{name of the output HTML file that
  contains the visualization, default
  "data_name-ractive.html"}
}
\description{
  Get options used by the current ractive
}

