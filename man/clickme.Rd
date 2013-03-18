\docType{package}
\name{clickme}
\alias{clickme}
\alias{clickme-package}
\title{Generates a JavaScript visualization}
\usage{
  clickme(data, ractive, data_file_name = NULL,
    html_file_name = NULL, browse = interactive(),
    validate_names = TRUE)
}
\arguments{
  \item{data}{input data}

  \item{ractive}{template id, it must match a folder within
  \code{set_root_path}}

  \item{data_file_name}{}

  \item{html_file_name}{name of HTML file}

  \item{browse}{open browser, default TRUE}

  \item{validate_names,}{default TRUE}
}
\description{
  Generates a JavaScript visualization

  The clickme folder structure is:
}
\details{
  <my visualizations root folder> <= get_root_path() +- <my
  ractive> <= opts$name$ractive | +- template <=
  opts$name$template | | +- template.Rmd <=
  opts$name$template_file | | +- translator.R <=
  opts$name$translator_file | | +- template_config.yml <=
  opts$name$template_config_file | +- external <=
  opts$name$external | | +- <my_library.js> | | +-
  <my_styles.css> | +- data <= opts$name$data | +- tests <=
  opts$name$tests | +- test-translator.R <= opts$name$tests
  +- <visualization_generated_using_my_ractive.html> <=
  opts$name$html_file
}
\examples{
data(lawsuits)
set_root_path(system.file("examples", package="clickme"))
clickme(lawsuits, "force_directed")
}

