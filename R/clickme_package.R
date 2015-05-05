#' Clickme: use R to create interactive visualizations
#'
#' @section Package options:
#'
#' Clickme uses the following \code{options} to configure behaviour:
#'
#' \itemize{
#'
#'   \item \code{clickme_templates_path}: path where the templates are stored
#'
#'   \item \code{clickme_output_path}: path where the generated visualizations are saved (along with their dependencies)
#'
#' }
#' @docType package
#' @name clickme
#' @import methods yaml stringr knitr rjson
#' @author Nacho Caballero <\url{http://reasoniamhere.com}>
#' @references Full documentation: \url{https://github.com/nachocab/clickme/wiki};
NULL

# document datasets
#' 500 genes with the highest fold-change between two conditions
#'
#' A microarray dataset showing the expression values of 500 genes
#'  The variables include:
#'
#' \itemize{
#'   \item logFC. Fold change between two conditions (log2)
#'   \item magnitude. Average magnitude of the change (log2)
#'   \item P.Value. t-test-derived p-value
#'   \item adj.P.Val. Benjamini-Hochberg corrected p-value
#'   \item probe_name. Agilent v2 probe name
#'   \item gene_name. Gene symbol
#'   \item significance. -log10(adj.P.Val)
#'   ...
#' }
#'
#' @docType data
#' @keywords datasets
#' @format A data frame with 500 rows and 7 variables
#' @name microarray
NULL

set_default_paths <- function() {
    opts <- options()
    opts_clickme <- list(
      clickme_templates_path = file.path(system.file(package = "clickme"), "templates"),
      clickme_output_path = file.path(system.file(package = "clickme"), "output")
    )

    # only set options that have not already been set by the user
    to_set <- !(names(opts_clickme) %in% names(opts))
    if(any(to_set)) options(opts_clickme[to_set])
}

.onLoad <- function(libname, pkgname) {
    # I need to load it explicitly or I get an error when running in non-interactive mode
    library(methods)
    set_default_paths()
}
