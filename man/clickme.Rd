\docType{package}
\name{clickme}
\alias{clickme}
\alias{clickme-package}
\title{Generates a JavaScript visualization}
\usage{
  clickme(data, template_id, opts = list())
}
\arguments{
  \item{data}{input data}

  \item{template_id}{template id, it must match a folder
  within \code{clickme_path}}

  \item{opts}{optional, list of options}
}
\description{
  Generates a JavaScript visualization

  The clickme folder structure is:
}
\details{
  |- USER_VISUALIZATIONS_FOLDER <= .clickme_env$path - set
  with clickme_path(USER_VISUALIZATIONS_FOLDER) |-
  name$data-template_id.html |- templates <=
  .clickme_env$name$templates |- template_id <=
  template_id |- data <= .clickme_env$name$data |-
  scripts <= .clickme_env$name$scripts |- styles <=
  .clickme_env$name$styles |- template.Rmd <=
  .clickme_env$name$template_file |- config.yml <=
  .clickme_env$name$config_file
}
\examples{
data <- data <- read.csv(system.file(file.path("demo", "templates", "force_directed", "data", "lawsuits.txt"), package="clickme"))
clickme_path(system.file("demo", package="clickme"))
clickme(data, "force_directed", opts=list(name$data="data"))
}

