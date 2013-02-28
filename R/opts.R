#' Set up the default paths and the custom names for the input data and the visualization file names.
#'
#' @import yaml
add_paths <- function(opts) {
    opts$template_path <- file.path(.clickme_env$path, .clickme_env$templates_dir_name, opts$template_id, .clickme_env$template_file_name)
    if (!file.exists(opts$template_path)) stop("Template", opts$template_id, "not in: ", opts$template_path)

    opts$config_path <- file.path(.clickme_env$path, .clickme_env$templates_dir_name, opts$template_id, .clickme_env$config_file_name)

    opts$data_name <- opts$data_name %||% basename(tempfile("data"))

    opts$relative_data_path <- file.path(.clickme_env$templates_dir_name, opts$template_id, .clickme_env$data_dir_name)
    opts$relative_translator_path <- file.path(.clickme_env$templates_dir_name, opts$template_id, .clickme_env$translator_dir_name)
    opts$relative_scripts_path <- file.path(.clickme_env$templates_dir_name, opts$template_id, .clickme_env$scripts_dir_name)
    opts$relative_styles_path <- file.path(.clickme_env$templates_dir_name, opts$template_id, .clickme_env$styles_dir_name)

    opts$viz_name <- opts$viz_name %||% paste0(opts$data_name, "-", opts$template_id, ".html")

    # viz_path must be in the same folder as templates, so the relative paths to scripts and styles are correct
    opts$viz_path <- file.path(.clickme_env$path, opts$viz_name)

    opts
}

#'
#'
#'
get_template_config <- function(opts){
    template_config <- NULL
    if (file.exists(opts$config_path)){
        template_config <- yaml.load_file(opts$config_path)
    }
    template_config
}

