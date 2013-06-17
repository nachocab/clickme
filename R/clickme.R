#' @import knitr
generate_visualization <- function(opts){
    source(opts$paths$translator_file)
    raw_template <- knit_expand(opts$paths$template_file)
    suppressMessages(knit(text = raw_template, output = opts$paths$output_file, quiet = TRUE))
}

#' Generates a JavaScript visualization
#'
#' @param data input data
#' @param template template id, it must match a folder within \code{set_templates_path}
#' @param params parameters
#' @param open open browser tab with the generated visualization.
#' @param ... additional arguments for \code{get_opts}
#' @export
#' @examples
#'
#' library(clickme)
#'
#' # visualize a force-directed interactive graph
#' items <- paste0("GENE_", 1:40)
#' n <- 30
#' df1 <- data.frame(source = sample(items, n, replace = TRUE), target = sample(items, n, replace = TRUE), type = sample(letters[1:3], n, replace = TRUE))
#' clickme(df1, "force_directed")
clickme <- function(data, template, params = NULL, open = interactive(), link = FALSE, ...){

    get_opts_skip_args <- function(..., open, link) get_opts(...)
    opts <- get_opts_skip_args(template, params, ...)
    opts$data <- data

    generate_visualization(opts)

    export_assets(opts)

    validate_server(opts)
    validate_coffee(opts)

    if (open) browseURL(opts$url)

    if (link){
        make_link(opts$names$output_file, opts$params$title)
    } else {
        invisible(opts)
    }
}


