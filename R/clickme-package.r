#' clickme
#'
#' The clickme folder structure is:
#'
#' |- USER_VISUALIZATIONS_FOLDER    <= get_root_path() - server is run from here
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
.clickme_env$templates_dir_name <- "templates"
