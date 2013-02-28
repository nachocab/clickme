#' Set up the default paths and the custom names for the input data and the visualization file names.
#'
#' @import yaml
populate_opts <- function(data, template_id, opts) {
    opts$skeleton_path <- system.file(.clickme_env$skeleton_file_name, package="clickme")

    opts$template_path <- file.path(.clickme_env$path, .clickme_env$templates_dir_name, template_id, .clickme_env$template_file_name)
    if (!file.exists(opts$template_path)) stop("Template", template_id, "not in: ", opts$template_path)

    opts$config_path <- file.path(.clickme_env$path, .clickme_env$templates_dir_name, template_id, .clickme_env$config_file_name)
    if (file.exists(opts$config_path)){
        opts$template_config <- yaml.load_file(opts$config_path)
    }

    opts$data_name <- opts$data_name %||% paste0(deparse(substitute(data)), ".json")

    opts$relative_data_path <- file.path(.clickme_env$data_dir_name, opts$data_name)
    opts$data_path <- file.path(.clickme_env$path, opts$relative_data_path)

    opts$relative_scripts_path <- file.path(.clickme_env$templates_dir_name, template_id, .clickme_env$scripts_dir_name)
    opts$relative_styles_path <- file.path(.clickme_env$templates_dir_name, template_id, .clickme_env$styles_dir_name)

    opts$viz_name <- opts$viz_name %||% paste0(deparse(substitute(data)), "_", template_id, ".html")
    opts$viz_path <- file.path(.clickme_env$path, opts$viz_name)

    opts
}