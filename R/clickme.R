#'
#'
#'
append_scripts <- function(opts) {
    paste(sapply(opts$template_config$scripts, function(script_path){
        script_path <- file.path(opts$relative_path$scripts, script_path)
        paste0("<script src=\"", script_path, "\"></script>")
    }), collapse="\n")
}

#'
#'
#'
append_external <- function(opts) {
    paste(sapply(opts$template_config$external, function(style_path){
        style_path <- file.path(opts$relative_path$external, style_path)
        paste0("<link href=\"", style_path, "\" rel=\"externalheet\">")
    }), collapse="\n")
}

#' Generate the JavaScript visualization
#'
#' Write the input data.frame to a file, for easier JavaScript consumption
#' we use capture.output to hide the knitr progress bars, how should we deal with errors?
#' @import knitr
generate_visualization <- function(data, opts){
    scaffold <- "`r append_scripts(opts)`
`r append_external(opts)`
<script type=\"text/javascript\">
`r knit(text = expanded_template)`
</script>"
    expanded_template <- knit_expand(opts$path$template_file, opts = opts)

    visualization <- knit_expand(text = scaffold, expanded_template = expanded_template)

    capture.output(knit2html(text = visualization, output = opts$path$viz_file))
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
clickme <- function(data, ractive, data_file_name = NULL, viz_file_name = NULL, browse = interactive()){
    if (is.null(get_root_path())) set_root_path()
    opts <- get_opts(ractive, data_file_name, viz_file_name)
    if (!file.exists(opts$path$template_file)) stop("Template ", opts$name$ractive, " not found in: ", opts$path$template_file)

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

#'
#'
#' translate is a function defined in ractive/lib/ it might return a JSON object or a file path
translate_data <- function(data, opts) {
    source(opts$path$translator_file)
    data <- translate(data, opts)
    data
}

# TODO: clickme_embed: returns code
# TODO: clickme_link: builds a link <a href>