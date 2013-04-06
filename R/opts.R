add_ractive_opts <- function(ractive_name) {
    opts <- list()

    # folder names
    opts$name$ractive <- ractive_name
    opts$name$data <- "data"
    opts$name$template <- "template"
    opts$name$external <- "external"

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

    # file absolute paths
    opts$path$template_file <- file.path(opts$path$template, opts$name$template_file)
    opts$path$template_config_file <- file.path(opts$path$template, opts$name$template_config_file)
    opts$path$translator_file <- file.path(opts$path$template, opts$name$translator_file)
    opts$path$translator_test_file <- file.path(opts$path$template, opts$name$translator_test_file)

    # paths relative to opts$path$ractive
    opts$relative_path$data <- file.path(opts$name$ractive, opts$name$data)
    opts$relative_path$external <- file.path(opts$name$ractive, opts$name$external)

    opts
}

add_params <- function(opts, params) {
    opts$params <- opts$template_config$default_parameters
    valid_param_names <- names(opts$template_config$default_parameters)

    for (param in names(params)){
        if (param %notin% valid_param_names) stop(param, " is not a valid parameter\n(Use one of: ", paste(valid_param_names, collapse=", "), ")")

        opts$params[[param]] <- params[[param]]
    }

    opts
}

#' Get options used by the current ractive
#'
#' @param ractive name of the reactive
#' @param params list containing the parameters and values that will be accessible from the template
#' @param data_name name used to identify the output HTML file, default "data"
#' @param html_file_name name of the output HTML file that contains the visualization, default "data_name-ractive.html"
#' @param port port used to open a local browser, default 8888
#' @export
#' @import yaml
get_opts <- function(ractive, params = NULL, data_name = "data", html_file_name = NULL, port = 8888){
    opts <- add_ractive_opts(ractive)
    if (!file.exists(opts$path$ractive)) stop("No ractive named ", ractive, " found at:", get_root_path())
    if (!file.exists(opts$path$template_config_file)) stop("No template configuration file found at:", opts$path$template_config_file)
    opts$template_config <- yaml.load_file(opts$path$template_config_file)
    validate_ractive(opts)

    # user provided options
    opts <- add_params(opts, params)
    opts$data_name <- data_name %||% basename(tempfile("data"))
    opts$name$html_file <- html_file_name %||% paste0(opts$data_name, "-", opts$name$ractive, ".html")
    opts$path$html_file <- file.path(get_root_path(), opts$name$html_file)

    if (opts$template_config$require_server){
        opts$url <- paste0("http://localhost:", port, "/", opts$name$html_file)
    } else {
        opts$url <- opts$path$html_file
    }

    opts
}