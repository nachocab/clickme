\docType{package}
\name{clickme}
\alias{clickme}
\alias{clickme-package}
\title{Generates a JavaScript visualization}
\usage{
  clickme(data, ractive, data_file_name = NULL,
    viz_file_name = NULL, browse = interactive())
}
\arguments{
  \item{data}{input data}

  \item{ractive}{template id, it must match a folder within
  \code{set_root_path}}

  \item{opts}{optional, list of options}
}
\description{
  Generates a JavaScript visualization

  The clickme folder structure is:
}
\details{
  |- USER_VISUALIZATIONS_FOLDER <= get_root_path() - server
  is run from here |- data_name-ractive.html <=
  opts$name$viz_file |- ractives <= opts$name$ractives |-
  ractive <= opts$name$ractive |- data <= opts$name$data |-
  external <= opts$name$external |- template <=
  opts$name$template |- template.Rmd <=
  opts$name$template_file |- translator.R <=
  opts$name$translator_file |- config.yml <=
  opts$name$config_file
}
\examples{
data(lawsuits)
head(lawsuits)
set_root_path(system.file("examples", package="clickme"))
clickme(lawsuits, "force_directed")
}

