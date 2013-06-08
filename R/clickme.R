#' @import knitr
generate_visualization <- function(opts){
    source(opts$path$translator_file)
    raw_template <- knit_expand(opts$path$template_file)
    capture.output(knit(text = raw_template, output = opts$path$html_file))
}

#' Generates a JavaScript visualization
#'
#' @param data input data
#' @param ractive template id, it must match a folder within \code{set_templates_path}
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
clickme <- function(data, ractive, params = NULL, open = interactive(), link = FALSE, ...){

    get_opts_fix_args <- function(..., open, link) get_opts(...)
    opts <- get_opts_fix_args(ractive, params, ...)

    validate_server(opts)
    validate_coffee(opts)

    # could this go in get_opts?
    opts$data <- data
    if (!is.null(opts$name_mappings)){
        opts$data <- map_data_names(opts)
    }

    validate_data_names(opts)

    generate_visualization(opts)

    if (open) browseURL(opts$url)

    if (link){
        make_link(opts$name$html_file, opts$params$title)
    } else {
        invisible(opts)
    }
}


