#'
#'
#'
append_scripts <- function(opts) {
    paste(sapply(opts$template_config$scripts, function(script_path){
        script_path <- file.path(opts$relative_scripts_path, script_path) # we could add a is_local option to config.yml so URLs can be used
        paste0("<script src=\"", script_path, "\"></script>")
    }), collapse="\n")
}

#'
#'
#'
append_styles <- function(opts) {
    paste(sapply(opts$template_config$styles, function(style_path){
        style_path <- file.path(opts$relative_styles_path, style_path)
        paste0("<link href=\"", style_path, "\" rel=\"stylesheet\">")
    }), collapse="\n")
}

#'
#'
#' translate is a function defined in template_id/lib/ it might return a JSON object or a file path
translate_data <- function(data, opts) {
    translator_path <- file.path(.clickme_env$path, opts$relative_translator_path)
    source_dir(translator_path)
    data <- translate(data)
    data
}

#' Generate the JavaScript visualization
#'
#' Write the input data.frame to a file, for easier JavaScript consumption
#' we use capture.output to hide the knitr progress bars, how should we deal with errors?
#' @import knitr
generate_visualization <- function(data, opts){
    visualization_template <- knit_expand(opts$template_path, opts = opts)
    skeleton_template <- "`r append_scripts(opts)`
`r append_styles(opts)`
<script type=\"text/javascript\">
`r knit(text = visualization_template)`
</script>"
    visualization <- knit_expand(text = skeleton_template, visualization_template = visualization_template)

    capture.output(knit2html(text = visualization, output = opts$viz_path))
}

#' Generates a JavaScript visualization
#'
#' @ param data
#' @ param template_id
#' @ param opts
#' @export
#' @examples
clickme <- function(data, template_id, opts = list()){
    if (is.null(.clickme_env$path)) clickme_path()

    opts$template_id <- template_id
    opts <- add_paths(opts)
    opts$template_config <- get_template_config(opts)
    opts$data <- translate_data(data, opts)

    generate_visualization(data, opts)

    opts$viz_path
}

# TODO: clickme_embed: returns code
# TODO: clickme_link: builds a link <a href>