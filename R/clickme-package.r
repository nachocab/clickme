#' clickme
#'
#' The clickme folder structure is:
#'
#' |- USER_VISUALIZATIONS_FOLDER    <= .clickme_env$root_path - set with set_root_path(USER_VISUALIZATIONS_FOLDER)
#'    |- data_name-template_id.html <= opts$name$viz_file
#'    |- templates                  <= opts$name$templates
#'       |- template_id             <= opts$name$template_id
#'          |- data                 <= opts$name$data
#'          |- scripts              <= opts$name$scripts
#'          |- styles               <= opts$name$styles
#'          |- template.Rmd         <= opts$name$template_file
#'          |- config.yml           <= opts$name$config_file
#'
#' @name clickme
#' @docType package
NULL

.clickme_env <- new.env()
.clickme_env$root_path <- NULL
