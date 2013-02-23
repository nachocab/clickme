#'
#'
#' @import yaml
populate_opts <- function(data, template_name, opts) {
    opts$templates_folder <- opts$templates_folder %||% system.file("templates", package="clickme")
    opts$template_path <- file.path(opts$templates_folder, paste0(template_name, ".Rmd"))
    if (!file.exists(opts$template_path)) stop("Template file not found: ", opts$template_path)
    opts$config_path <- file.path(opts$templates_folder, paste0(template_name, ".yml"))
    if (!file.exists(opts$config_path)) stop("Config file not found: ", opts$config_path)

    opts$template_config <- yaml.load_file(opts$config_path)

    opts$skeleton_path <- opts$skeleton_path %||% system.file("skeleton.Rmd", package="clickme")
    if (!file.exists(opts$skeleton_path)) stop("Skeleton file not found: ", opts$skeleton_path)

    opts$data_path <- opts$data_path %||% paste0(deparse(substitute(data)), ".json")
    opts$visualization_path <- opts$visualization_path %||% paste0(deparse(substitute(data)), ".html")

    opts
}