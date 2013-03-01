#' Read template configuration from yaml file
#'
#' @import yaml
get_template_config <- function(config_file_path){
    template_config <- NULL
    if (file.exists(config_file_path)){
        template_config <- yaml.load_file(config_file_path)
    }
    template_config
}


initialize_opts <- function() {
    opts <- list()
    opts$name$templates <- .clickme_env$templates_dir_name
    opts$path$templates <- file.path(get_root_path(), opts$name$templates)

    opts
}

add_template_opts <- function(template_id) {
    opts <- initialize_opts()

    # folder names
    opts$name$template_id <- template_id
    opts$name$data <- "data"
    opts$name$translator <- "translator"
    opts$name$scripts <- "scripts"
    opts$name$styles <- "styles"

    # file names
    opts$name$translator_file <- "translator.R"
    opts$name$config_file <- "config.yml"
    opts$name$template_file <- "template.Rmd"

    # folder absolute paths - for now, template_id is directly below opts$path$templates, maybe in the future we can allow nested paths (simple is better)
    opts$path$template_id <- file.path(opts$path$templates, opts$name$template_id)
    opts$path$translator <- file.path(opts$path$template_id, opts$name$translator)
    opts$path$data <- file.path(opts$path$template_id, opts$name$data)
    opts$path$scripts <- file.path(opts$path$template_id, opts$name$scripts)
    opts$path$styles <- file.path(opts$path$template_id, opts$name$styles)

    # file absolute paths
    opts$path$translator_file <- file.path(opts$path$translator, opts$name$translator_file)
    opts$path$config_file <- file.path(opts$path$template_id, opts$name$config_file)
    opts$path$template_file <- file.path(opts$path$template_id, opts$name$template_file)

    # paths relative to opts$path$templates
    opts$relative_path$template_id <- file.path(opts$name$templates, opts$name$template_id)
    opts$relative_path$data <- file.path(opts$relative_path$template_id, opts$name$data)
    opts$relative_path$scripts <- file.path(opts$relative_path$template_id, opts$name$scripts)
    opts$relative_path$styles <- file.path(opts$relative_path$template_id, opts$name$styles)

    opts
}

get_opts <- function(template_id, data_file_name = NULL, viz_file_name = NULL){
    opts <- add_template_opts(template_id)
    opts$template_config <- get_template_config(opts$path$config_file)

    # file names
    opts$name$data_file <- data_file_name %||% basename(tempfile("data"))
    opts$name$viz_file <- viz_file_name %||% paste0(opts$name$data_file, "-", opts$name$template_id, ".html")

    # file absolute paths
    opts$path$viz_file <- file.path(get_root_path(), opts$name$viz_file)

    opts
}