#' clickme
#'
#' The clickme folder structure is:
#'
#' |- USER_VISUALIZATIONS_FOLDER  <= get_root_path() - server is run from here
#'    |- data_name-ractive.html   <= opts$name$viz_file
#'    |- ractives                 <= opts$name$ractives
#'       |- ractive               <= opts$name$ractive
#'          |- data               <= opts$name$data
#'          |- external           <= opts$name$external
#'          |- template           <= opts$name$template
#'             |- template.Rmd    <= opts$name$template_file
#'             |- translator.R    <= opts$name$translator_file
#'             |- config.yml      <= opts$name$config_file
#'
#' @name clickme
#' @docType package
NULL

.clickme_env <- new.env()
.clickme_env$ractives_dir_name <- "ractives"
