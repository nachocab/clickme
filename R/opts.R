add_names <- function(opts, template_id) {
    # folders
    opts$name$template_id <- template_id
    opts$name$templates <- opts$name$templates %||% "templates"
    opts$name$data <- opts$name$data %||% "data"
    opts$name$translator <- opts$name$translator %||% "translator"
    opts$name$scripts <- opts$name$scripts %||% "scripts"
    opts$name$styles <- opts$name$styles %||% "styles"

    # files
    opts$name$translator_file <- opts$name$translator_file %||% "translator.R"
    opts$name$template_file <- opts$name$template_file %||% "template.Rmd"
    opts$name$config_file <- opts$name$config_file %||% "config.yml"
    opts$name$data_file <- opts$name$data_file %||% basename(tempfile("data"))
    opts$name$viz_file <- opts$name$viz_file %||% paste0(opts$name$data_file, "-", opts$name$template_id, ".html")

    opts
}

#' Set up the default paths and the custom names for the input data and the visualization file names.
#'
#' @import yaml
add_paths <- function(opts) {
    # absolute paths
    opts$path$templates <- file.path(.clickme_env$path, opts$name$templates)
    opts$path$template_id <- file.path(opts$name$templates, opts$name$template_id)
    opts$path$viz_file <- file.path(.clickme_env$path, opts$name$viz_file)

    opts$path$config_file <- file.path(opts$path$template_id, opts$name$config_file)
    opts$path$template_file <- file.path(opts$path$template_id, opts$name$template_file)
    if (!file.exists(opts$path$template_file)) stop("Template ", opts$name$template_id, " not in: ", opts$path$template_file)

    # relative paths hang below opts$path$templates
    opts$relative_path$template_id <- file.path(opts$name$templates, opts$name$template_id)
    opts$relative_path$data <- file.path(opts$relative_path$template_id, opts$name$data)
    opts$relative_path$translator <- file.path(opts$relative_path$template_id, opts$name$translator)
    opts$relative_path$scripts <- file.path(opts$relative_path$template_id, opts$name$scripts)
    opts$relative_path$styles <- file.path(opts$relative_path$template_id, opts$name$styles)

    opts
}

#'
#'
#'
get_template_config <- function(opts){
    template_config <- NULL
    if (file.exists(opts$path$config_file)){
        template_config <- yaml.load_file(opts$path$config_file)
    }
    template_config
}


initialize_opts <- function(opts, template_id) {
    opts <- add_names(opts, template_id)
    opts <- add_paths(opts)
    opts
}
