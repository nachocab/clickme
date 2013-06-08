#' Straight from R to JS: Create intetemplate visualizations from R
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
#' @author Nacho Caballero <\url{http://reasoniamhere.com}>
#' @references Full documentation: \url{https://github.com/nachocab/clickme/wiki};
NULL

.onLoad <- function(libname, pkgname) {
  opts <- options()
  opts_clickme <- list(
    clickme_templates_path = system.file("templates", package = "clickme"),
    clickme_output_path = system.file("output", package = "clickme")
  )

  # only set options that have not been already set by the user
  to_set <- !(names(opts_clickme) %in% names(opts))
  if(any(to_set)) options(opts_clickme[to_set])

  invisible()
}
