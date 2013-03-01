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
  within \code{set_root_path}}

  \item{opts}{optional, list of options}
}
\description{
  Generates a JavaScript visualization

  The clickme folder structure is:
}
\details{
  |- USER_VISUALIZATIONS_FOLDER <= .clickme_env$root_path - set
  with set_root_path(USER_VISUALIZATIONS_FOLDER) |-
  name$data-template_id.html |- templates <=
  opts$name$templates |- template_id <=
  template_id |- data <= opts$name$data |-
  scripts <= opts$name$scripts |- styles <=
  opts$name$styles |- template.Rmd <=
  opts$name$template_file |- config.yml <=
  opts$name$config_file
}
\examples{
data <- data <- read.csv(system.file(file.path("demo", "templates", "force_directed", "data", "lawsuits.txt"), package="clickme"))
set_root_path(system.file("demo", package="clickme"))
clickme(data, "force_directed", opts=list(name$data="data"))
}

