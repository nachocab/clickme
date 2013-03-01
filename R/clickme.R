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
append_styles <- function(opts) {
    paste(sapply(opts$template_config$styles, function(style_path){
        style_path <- file.path(opts$relative_path$styles, style_path)
        paste0("<link href=\"", style_path, "\" rel=\"stylesheet\">")
    }), collapse="\n")
}

#' Generate the JavaScript visualization
#'
#' Write the input data.frame to a file, for easier JavaScript consumption
#' we use capture.output to hide the knitr progress bars, how should we deal with errors?
#' @import knitr
generate_visualization <- function(data, opts){
    visualization_template <- knit_expand(opts$path$template_file, opts = opts)
    skeleton_template <- "`r append_scripts(opts)`
`r append_styles(opts)`
<script type=\"text/javascript\">
`r knit(text = visualization_template)`
</script>"
    visualization <- knit_expand(text = skeleton_template, visualization_template = visualization_template)

    capture.output(knit2html(text = visualization, output = opts$path$viz_file))
}

#' Generates a JavaScript visualization
#'
#' @param data input data
#' @param template_id template id, it must match a folder within \code{set_root_path}
#' @param opts optional, list of options
#' @export
#' @examples
#'
#' data <- read.csv(system.file(file.path("demo", "templates", "force_directed", "data", "lawsuits.txt"), package="clickme"))
#' set_root_path(system.file("demo", package="clickme"))
#' clickme(data, "force_directed", opts=list(name$data="data"))
clickme <- function(data, template_id, data_file_name = NULL, viz_file_name = NULL, browse = interactive()){
    if (is.null(get_root_path())) set_root_path()
    opts <- get_opts(template_id, data_file_name, viz_file_name)
    if (!file.exists(opts$path$template_file)) stop("Template ", opts$name$template_id, " not found in: ", opts$path$template_file)

    opts$data <- translate_data(data, opts)

    generate_visualization(data, opts)

    if (browse) browseURL(opts$path$viz_file)

    if (!is.null(opts$template_config$require_server) && opts$template_config$require_server){
        message("Run a local server in folder: ", get_root_path(),"\nand browse to http://LOCALHOST:PORT/", opts$name$viz_file)
        output <- opts$name$viz_file
    } else {
        output <- opts$path$viz_file
    }
    output
}

#'
#'
#' translate is a function defined in template_id/lib/ it might return a JSON object or a file path
translate_data <- function(data, opts) {
    source_dir(opts$path$translator)
    data <- translate(data, opts)
    data
}

# TODO: clickme_embed: returns code
# TODO: clickme_link: builds a link <a href>