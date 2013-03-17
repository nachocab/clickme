#' Read ractive configuration from yaml file
#'
#' @import yaml
get_template_config <- function(template_config_file_path){
    template_config <- NULL
    if (file.exists(template_config_file_path)){
        template_config <- yaml.load_file(template_config_file_path)
    }

    template_config$server <- template_config$server %||% FALSE

    template_config
}

add_ractive_opts <- function(ractive_name) {
    opts <- list()

    # folder names
    opts$name$ractive <- ractive_name
    opts$name$data <- "data"
    opts$name$template <- "template"
    opts$name$external <- "external"

    # file names
    opts$name$translator_file <- "translator.R"
    opts$name$template_config_file <- "config.yml"
    opts$name$template_file <- "template.Rmd"

    # folder absolute paths
    # PONDER: ractive is directly below the root path, maybe in the future we can allow nested paths for ractives (although, simple is better)
    opts$path$ractive <- file.path(get_root_path(), opts$name$ractive)
    opts$path$data <- file.path(opts$path$ractive, opts$name$data)
    opts$path$template <- file.path(opts$path$ractive, opts$name$template)
    opts$path$external <- file.path(opts$path$ractive, opts$name$external)

    # file absolute paths
    opts$path$translator_file <- file.path(opts$path$template, opts$name$translator_file)
    opts$path$template_config_file <- file.path(opts$path$template, opts$name$template_config_file)
    opts$path$template_file <- file.path(opts$path$template, opts$name$template_file)

    # paths relative to opts$path$ractive
    opts$relative_path$data <- file.path(opts$name$ractive, opts$name$data)
    opts$relative_path$external <- file.path(opts$name$ractive, opts$name$external)

    opts
}

get_opts <- function(ractive, data_file_name = NULL, viz_file_name = NULL){
    opts <- add_ractive_opts(ractive)
    opts$template_config <- get_template_config(opts$path$template_config_file)

    # file names
    opts$name$data_file <- data_file_name %||% paste0(basename(tempfile("data")), ".json")
    opts$name$viz_file <- viz_file_name %||% paste0(strsplit(opts$name$data_file, "\\.")[[1]][1], "-", opts$name$ractive, ".html")

    # file absolute paths
    opts$path$data_file <- file.path(opts$path$data, opts$name$data_file)
    opts$path$viz_file <- file.path(get_root_path(), opts$name$viz_file)

    opts
}