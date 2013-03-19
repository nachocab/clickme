#' Read ractive configuration from yaml file
#'
#' @import yaml
get_template_config <- function(template_config_file_path){
    template_config <- NULL
    if (file.exists(template_config_file_path)){
        template_config <- yaml.load_file(template_config_file_path)
    }

    template_config$require_server <- template_config$require_server %||% FALSE

    template_config
}

add_ractive_opts <- function(ractive_name) {
    opts <- list()

    # folder names
    opts$name$ractive <- ractive_name
    opts$name$data <- "data"
    opts$name$template <- "template"
    opts$name$external <- "external"
    opts$name$tests <- "tests"

    # file names
    opts$name$template_file <- "template.Rmd"
    opts$name$template_config_file <- "template_config.yml"
    opts$name$translator_file <- "translator.R"
    opts$name$translator_test_file <- "test-translator.R"

    # folder absolute paths
    # PONDER: ractive is directly below the root path, maybe in the future we can allow nested paths for ractives (although, simple is better)
    opts$path$ractive <- file.path(get_root_path(), opts$name$ractive)
    opts$path$data <- file.path(opts$path$ractive, opts$name$data)
    opts$path$template <- file.path(opts$path$ractive, opts$name$template)
    opts$path$external <- file.path(opts$path$ractive, opts$name$external)
    opts$path$tests <- file.path(opts$path$ractive, opts$name$tests)

    # file absolute paths
    opts$path$template_file <- file.path(opts$path$template, opts$name$template_file)
    opts$path$template_config_file <- file.path(opts$path$template, opts$name$template_config_file)
    opts$path$translator_file <- file.path(opts$path$template, opts$name$translator_file)
    opts$path$translator_test_file <- file.path(opts$path$tests, opts$name$translator_test_file)

    # paths relative to opts$path$ractive
    opts$relative_path$data <- file.path(opts$name$ractive, opts$name$data)
    opts$relative_path$external <- file.path(opts$name$ractive, opts$name$external)

    opts
}

#' Get options used by ractive
#'
#' @param ractive name of the reactive
#' @param data_name name of input data
#' @param html_file_name name of output HTML file
#' @export
get_opts <- function(ractive, data_name = NULL, html_file_name = NULL){
    opts <- add_ractive_opts(ractive)
    opts$template_config <- get_template_config(opts$path$template_config_file)

    opts$data_name <- data_name %||% basename(tempfile("data"))

    opts$name$html_file <- html_file_name %||% paste0(opts$data_name, "-", opts$name$ractive, ".html")

    # file absolute paths
    opts$path$data_file <- file.path(opts$path$data, opts$name$data_file)
    opts$path$html_file <- file.path(get_root_path(), opts$name$html_file)

    opts
}