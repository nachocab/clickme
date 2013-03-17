#' clickme
#'
#' The clickme folder structure is:
#'
#' <my visualizations root folder>                          <= get_root_path()
#'   +- <my ractive>                                        <= opts$name$ractive
#'   |  +- template                                         <= opts$name$template
#'   |  |  +- template.Rmd                                  <= opts$name$template_file
#'   |  |  +- translator.R                                  <= opts$name$translator_file
#'   |  |  +- template_config.yml                           <= opts$name$template_config_file
#'   |  +- external                                         <= opts$name$external
#'   |  |  +- <my_library.js>
#'   |  |  +- <my_styles.css>
#'   |  +- data                                             <= opts$name$data
#'   |  +- tests                                            <= opts$name$tests
#'   |      +- test-translator.R                            <= opts$name$tests
#'   +- <visualization_generated_using_my_ractive.html>     <= opts$name$html_file
#'
#' @name clickme
#' @docType package
NULL

.clickme_env <- new.env()
