#' clickme
#'
#' The clickme folder structure is:
#'
#' |- USER_VISUALIZATIONS_FOLDER    <= .clickme_env$path - set with clickme_path(USER_VISUALIZATIONS_FOLDER)
#'    |- data_name-template_id.html
#'    |- templates                  <= .clickme_env$templates_dir_name
#'       |- template_id             <= template_id
#'          |- data                 <= .clickme_env$data_dir_name
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
.clickme_env$translator_dir_name <- "translator"
.clickme_env$scripts_dir_name <- "scripts"
.clickme_env$styles_dir_name <- "styles"

.clickme_env$translator_file_name <- "translator.R"
.clickme_env$template_file_name <- "template.Rmd"
.clickme_env$config_file_name <- "config.yml"
