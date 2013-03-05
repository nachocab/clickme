#'
#'
#'
append_scripts <- function(opts) {
    scripts <- paste(sapply(opts$template_config$scripts, function(script_path){
        if (!grepl("^http", script_path)){
            script_path <- file.path(opts$relative_path$external, script_path)
        }
        paste0("<script src=\"", script_path, "\"></script>")
    }), collapse="\n")

    scripts
}

#'
#'
#'
append_styles <- function(opts) {
    styles <- paste(sapply(opts$template_config$styles, function(style_path){
        if (!grepl("^http", style_path)){
            style_path <- file.path(opts$relative_path$external, style_path)
        }
        paste0("<link href=\"", style_path, "\" rel=\"stylesheet\">")
    }), collapse="\n")

    styles
}

#' Generate the JavaScript visualization
#'
#' Write the input data.frame to a file, for easier JavaScript consumption
#' we use capture.output to hide the knitr progress bars, how should we deal with errors?
#' @import knitr
generate_visualization <- function(data, opts){
    visualization <- knit_expand(opts$path$template_file)

    capture.output(knit(text = visualization, output = opts$path$viz_file))
}

#' Generates a JavaScript visualization
#'
#' @param data input data
#' @param ractive template id, it must match a folder within \code{set_root_path}
#' @param opts optional, list of options
#' @export
#' @examples
#'
#' data(lawsuits)
#' head(lawsuits)
#' set_root_path(system.file("examples", package="clickme"))
#' clickme(lawsuits, "force_directed")
clickme <- function(data, ractive, data_file_name = NULL, viz_file_name = NULL, browse = interactive(), validate_names = TRUE){
    if (is.null(get_root_path())) set_root_path()

    opts <- get_opts(ractive, data_file_name, viz_file_name)

    validate_ractive(opts)
    if (validate_names){
        data <- validate_data_names(data, opts)
    }
    opts$data <- translate_data(data, opts)

    generate_visualization(data, opts)

    if (!is.null(opts$template_config$require_server) && opts$template_config$require_server){
        message("Run a local server in folder: ", get_root_path(),"\nand browse to http://LOCALHOST:PORT/", opts$name$viz_file)
        output <- opts$name$viz_file
    } else {
        if (browse) browseURL(opts$path$viz_file)
        output <- opts$path$viz_file
    }
    output
}

#' Translate data object to be used in the ractive (usually into JSON or a file path)
#'
#' \code{clickme_translate} is a function defined in opts$path$translator_file
translate_data <- function(data, opts) {
    source(opts$path$translator_file)
    data <- clickme_translate(data, opts)
    data
}
