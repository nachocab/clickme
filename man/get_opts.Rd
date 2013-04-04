\name{get_opts}
\alias{get_opts}
\title{Get options used by the current ractive}
\usage{
  get_opts(ractive, params = NULL, data_name = "data",
    html_file_name = NULL, port = 8888)
}
\arguments{
  \item{ractive}{name of the reactive}

  \item{params}{list containing the parameters and values
  that will be accessible from the template}

  \item{data_name}{name used to identify the output HTML
  file, default "data"}

  \item{html_file_name}{name of the output HTML file that
  contains the visualization, default
  "data_name-ractive.html"}

  \item{port}{port used to open a local browser, default
  8888}
}
\description{
  Get options used by the current ractive
}

