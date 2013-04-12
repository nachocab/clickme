#' @import knitr
generate_visualization <- function(opts){
    visualization <- knit_expand(opts$path$template_file)
    capture.output(knit(text = visualization, output = opts$path$html_file))
}

#' Generates a JavaScript visualization
#'
#' @param data input data
#' @param ractive template id, it must match a folder within \code{set_root_path}
#' @param browse open browser, default TRUE
#' @param ... additional arguments for \code{get_opts}
#' @export
#' @examples
#'
#' library(clickme)
#'
#' # visualize a zoomable phylogenetic tree (www.onezoom.org)
#' mammals_path <- system.file(file.path("examples", "one_zoom", "data", "mammals.tree"), package="clickme")
#' clickme(mammals_path, "one_zoom")
#'
#' # visualize a force-directed interactive graph
#' items <- paste0("GENE_", 1:40)
#' n <- 30
#' df1 <- data.frame(source = sample(items, n, replace = TRUE), target = sample(items, n, replace = TRUE), type = sample(letters[1:3], n, replace = TRUE))
#' clickme(df1, "force_directed")
#'
#' # visualize a line plot that allows zooming along the x-axis
#' n <- 30
#' cities <- c("Boston", "NYC", "Philadelphia")
#' df2 <- data.frame(x = rep(1:n, length(cities)), y = c(sort(rnorm(n)), -sort(rnorm(n)),sort(rnorm(n))), line = rep(cities, each = n))
#' clickme(df2, "line_with_focus")
#'
#' # visualize an interactive heatmap next to a parallel coordinates plot
#' df3 <- matrix(rnorm(200), ncol = 8, nrow = 25)
#' rownames(df3) <- paste0("GENE_", 1:25)
#' colnames(df3) <- paste0("sample_", 1:8)
#' clickme(df3, "longitudinal_heatmap") # you will need to have a local server for this one.
clickme <- function(data, ractive, browse = interactive(), ...){
    opts <- get_opts(ractive, ...)

    opts$data <- data
    if (!is.null(opts$name_mappings)){
        opts$data <- map_data_names(opts)
    }

    validate_data_names(opts)

    source(opts$path$translator_file)
    generate_visualization(opts)

    if (opts$template_config$require_server){
        message("Make sure you have a server running at: ", get_root_path())
        message("(try running: python -m SimpleHTTPServer)")
    }

    if (browse) browseURL(opts$url)

    invisible(opts)
}


