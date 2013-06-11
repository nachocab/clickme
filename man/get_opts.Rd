\name{get_opts}
\alias{get_opts}
\title{Get options used by the current template}
\usage{
  get_opts(template_name, params = NULL, file_name = NULL,
    file = NULL, dir = NULL, port = 8000)
}
\arguments{
  \item{template_name}{name of the reactive}

  \item{params}{named vector or list containing the
  parameters and values that will be accessible from the
  template}

  \item{file_name}{name for the output HTML file (the .html
  extension will be appended if not present). It will be
  saved in the default output path
  \code{getOption("clickme_output_path")}}

  \item{dir}{folder where the output HTML file will be
  created.}

  \item{file}{full path to the output HTML file.
  \code{file} overrides \code{file_name} and \code{dir}}

  \item{port}{port number used to open output files using a
  local server. Defaults to 8000.}
}
\description{
  Get options used by the current template
}

