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
