add_names <- function(opts, template_name) {

    # folder names
    opts$names$template <- template_name
    opts$names$template_assets <- "assets"
    opts$names$shared_assets <- "__shared_assets"
    opts$names$output_assets <- "clickme_assets"

    # file names
    opts$names$template_file <- "template.Rmd"
    opts$names$template_coffee_file <- "template.coffee.Rmd"
    opts$names$config_file <- "config.yml"
    opts$names$translator_file <- "translator.R"
    opts$names$translator_test_file <- "test-translator.R"

    opts
}

add_output_file_name <- function(opts, file = NULL, file_name = NULL) {
    if (is.null(file)){
        if (is.null(file_name)){
            opts$names$output_file <- paste0("temp-", opts$names$template, ".html")
        } else {
            if (!grepl(".\\.html$", file_name)) {
                opts$names$output_file <- paste0(file_name, ".html")
            } else {
                opts$names$output_file <- file_name
            }
        }
    } else {
        if (!is.null(file_name)) warning(gettextf("The \"file_name\" argument was ignored because the \"file\" argument was present: %s", file))

        if (!grepl(".\\.html$", file)) {
            file <- paste0(file, ".html")
        }
        opts$names$output_file <- basename(file)
    }

    opts
}

add_output_paths <- function(opts, file = NULL, dir = NULL) {
    if (is.null(file)){
        if (is.null(dir)){
            opts$paths$output <- getOption("clickme_output_path")
        } else {
            opts$paths$output <- dir
        }
        opts$paths$output_file <- file.path(opts$path$output, opts$names$output_file)
    } else {
        if (!is.null(dir)) warning(gettextf("The \"dir\" argument was ignored because the \"file\" argument was present: %s", file))

        opts$paths$output <- dirname(file)
        opts$paths$output_file <- file
    }

    opts$paths$shared_assets <- file.path(getOption("clickme_templates_path"), opts$names$shared_assets)
    opts$paths$output_template_assets <- file.path(opts$paths$output, opts$names$output_assets, opts$names$template)
    opts$paths$output_shared_assets <- file.path(opts$paths$output, opts$names$output_assets)

    # relative paths (they go in the HTML files)
    opts$relative_path$template_assets <- file.path(opts$names$output_assets, opts$names$template)
    opts$relative_path$shared_assets <- file.path(opts$names$output_assets)

    opts
}

add_paths <- function(opts) {

    # folder absolute paths
    opts$paths$template <- file.path(getOption("clickme_templates_path"), opts$names$template)
    opts$paths$template_assets <- file.path(opts$paths$template, opts$names$template_assets)

    # file absolute paths
    opts$paths$template_file <- file.path(opts$paths$template, opts$names$template_file)
    opts$paths$template_coffee_file <- file.path(opts$paths$template, opts$names$template_coffee_file)
    opts$paths$config_file <- file.path(opts$paths$template, opts$names$config_file)
    opts$paths$translator_file <- file.path(opts$paths$template, opts$names$translator_file)
    opts$paths$translator_test_file <- file.path(opts$paths$template, opts$names$translator_test_file)

    opts
}

validate_paths <- function(opts) {
    if (!file.exists(getOption("clickme_templates_path")))
        stop(gettextf("getOption(\"clickme_templates_path\") doesn't contain a valid path: %s", getOption("clickme_templates_path")))

    if (!file.exists(opts$paths$template))
        stop(gettextf("There is no template %s located in: %s ", opts$names$template, opts$paths$template))

    if (!file.exists(opts$paths$template_file) && !(opts$coffee && file.exists(opts$paths$template_coffee_file)))
        stop(gettextf("The %s template doesn't contain a template file in: %s ", opts$names$template, opts$paths$template_file))

    if (!file.exists(opts$paths$config_file))
        stop(gettextf("The %s template doesn't contain a configuration file in: %s ", opts$names$template, opts$paths$config_file))

    if (!file.exists(opts$paths$translator_file))
        stop(gettextf("The %s template doesn't contain a translator file in: %s ", opts$names$template, opts$paths$translator_file))

    if (!file.exists(opts$paths$output)){
        dir.create(opts$paths$output)
    }

    invisible()
}

validate_required_packages <- function(opts) {
    if (!is.null(opts$config$require_packages)){
        missing_packages <- opts$config$require_packages[!is.installed(opts$config$require_packages)]

        if (length(missing_packages) != 0){
            message(separator())
            message(gettextf("The %s template requires the following packages:\n\n%s\nPress Enter to install them automatically or \"c\" to cancel.",
                    opts$names$template,
                    paste0(missing_packages, collapse="\n"))
            )
            response <- readline()
            if (tolower(response) == "c"){
                message(gettextf("Try running: install.packages(%s)", paste0(missing_packages, collapse=",")))
                capture.output(return())
            } else {
                install.packages(missing_packages)
            }
            message(separator())
        }

        sapply(opts$config$require_packages, library, character.only = TRUE)
    }

    invisible()
}

get_template_and_shared_assets <- function(opts) {

    local_assets <- grep("^http://", c(opts$config$styles, opts$config$scripts), value = TRUE, invert = TRUE)
    if (length(local_assets) > 0){
        shared_assets <- grep("^\\$shared/", local_assets, value = TRUE)
        if (length(shared_assets) > 0){
            template_assets <- setdiff(local_assets, shared_assets)
            shared_assets <- str_match(shared_assets, "^\\$shared/(.+)")[,2]
        } else {
            template_assets <- local_assets
            shared_assets <- NULL
        }
        assets <- list(template = template_assets, shared = shared_assets)
    } else {
        assets <- NULL
    }

    assets
}

validate_assets <- function(opts) {
    assets <- get_template_and_shared_assets(opts)

    sapply(assets$template, function(asset){
        path <- file.path(opts$paths$template_assets, asset)
        if (!file.exists(path)) stop(asset, " not found at: ", path)
    })

    sapply(assets$shared, function(asset){
        path <- file.path(opts$paths$shared_assets, asset)
        if (!file.exists(path)) stop(asset, " not found at: ", path)
    })

    invisible()
}

get_default_opts <- function(template_name){
    opts <- list()
    opts <- add_names(opts, template_name)
    opts <- add_paths(opts)
    opts
}

#' Get options used by the current template
#'
#' @param template_name name of the reactive
#' @param params named vector or list containing the parameters and values that will be accessible from the template
#' @param file full path to the output HTML file. \code{file} overrides \code{file_name} and \code{dir}
#' @param dir folder where the output HTML file will be created. Ignored if \code{file} is specified.
#' @param file_name name for the output HTML file (the .html extension will be appended if not present). Ignored if \code{file} is specified. If \code{dir} is not specified, it will be created under the default output path \code{getOption("clickme_output_path")}
#' @param port port number used to open output files using a local server. Defaults to 8000.
#' @export
#' @import yaml
get_opts <- function(template_name, params, coffee, port, file_name = NULL, file = NULL, dir = NULL){

    opts <- get_default_opts(template_name)
    opts$coffee <- coffee

    opts <- add_output_file_name(opts, file, file_name)
    opts <- add_output_paths(opts, file, dir)
    validate_paths(opts)

    opts$config <- yaml.load_file(opts$paths$config_file)
    validate_required_packages(opts)
    validate_assets(opts)

    opts$params <- params

    if (opts$config$require_server){
        opts$url <- paste0("http://localhost:", port, "/", opts$names$output_file)
    } else {
        opts$url <- opts$paths$output_file
    }

    opts
}
