#' clickme
#'
#' The clickme folder structure is:
#'
#' |- clickme                       <= .clickme_env$path
#'    |- data_name_template_id.html
#'    |- data                       <= .clickme_env$data_dir_name
#'    |   |- data_name.json
#'    |- templates                  <= .clickme_env$templates_dir_name
#'       |- template_id             <= template_id
#'          |- scripts              <= .clickme_env$scripts_dir_name
#'          |- styles               <= .clickme_env$styles_dir_name
#'          |- template.Rmd         <= .clickme_env$template_file_name
#'          |- config.yml           <= .clickme_env$config_file_name
#'
#' @name clickme
#' @docType package
NULL

.clickme_env <- new.env()

.clickme_env$path <- NULL

.clickme_env$templates_dir_name <- "templates"
.clickme_env$data_dir_name <- "data"
.clickme_env$scripts_dir_name <- "scripts"
.clickme_env$styles_dir_name <- "styles"

.clickme_env$template_file_name <- "template.Rmd"
.clickme_env$config_file_name <- "config.yml"

.clickme_env$skeleton_file_name <- "skeleton.Rmd"
