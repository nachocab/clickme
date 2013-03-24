\name{set_root_path}
\alias{set_root_path}
\title{Set the root path}
\usage{
  set_root_path(path)
}
\arguments{
  \item{path}{path to be used as root}
}
\description{
  The root path is the folder that contains the ractives
  that you have installed in your system. It will also
  contain the HTML visualization files that you generate.
  If you a using a local server to serve your HTML files,
  you should run it at the root path. \code{set_root_path}
  will set the root path and generate the ractives folder
  below it. The ractives folder is where you should install
  existing ractives, or create new ones (see
  \code{?new_ractive})
}

