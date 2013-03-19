\docType{package}
\name{clickme}
\alias{clickme}
\alias{clickme-package}
\title{Generates a JavaScript visualization}
\usage{
  clickme(data, ractive, data_name = NULL,
    html_file_name = NULL, params = NULL,
    browse = interactive(), port = 8888)
}
\arguments{
  \item{data}{input data}

  \item{ractive}{template id, it must match a folder within
  \code{set_root_path}}

  \item{data_name}{}

  \item{html_file_name}{name of HTML file}

  \item{browse}{open browser, default TRUE}
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
items <- paste0("GENE_", 1:40)
n <- 30
df1 <- data.frame(a=sample(items, n, replace=TRUE), b=sample(items, n, replace=TRUE), type=sample(letters[1:3], n, replace=TRUE))
clickme(df1, "force_directed")

n <- 30
cities <- c("Boston", "NYC", "Philadelphia")
df2 <- data.frame(name=rep(cities, each=n), x=rep(1:n,length(cities)), y=c(sort(rnorm(n)),-sort(rnorm(n)),sort(rnorm(n))))
clickme(df2, "line_with_focus")

df3 <- matrix(rnorm(200),ncol=8,nrow=25)
rownames(df3) <- paste0("GENE_", 1:25)
colnames(df3) <- paste0("sample_", 1:8)
clickme(df3, "longitudinal_heatmap") # you will need to have a local server running for this example to work
}

