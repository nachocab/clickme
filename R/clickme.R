Clickme <- setRefClass('Clickme',

    fields = c("params", "data"),

    methods = list(

        # Validates colorize and palette
        validate_colorize_and_palette = function() {
            if (scale_type(params$colorize) == "categorical" & !is.null(params$color_domain)){
                stop("A color domain can only be specified for quantitative scales. colorize has categorical values.")
            }

            palette_names <- names(params$palette)
            categories <- unique(params$colorize)
            if (!is.null(params$colorize) & !is.null(params$palette) & !is.null(palette_names)) {
                if (scale_type(params$colorize) == "categorical"){
                    if (any(palette_names %notin% categories)) {
                        warning("The following palette names don't appear in colorize: ", paste0(palette_names[palette_names %notin% categories], collapse = ", "))
                    }

                    if (any(is.na(params$palette))) {
                        categories_with_default_colors <- names(params$palette[is.na(params$palette)])
                        default_palette <- setNames(default_colors(length(categories_with_default_colors)), categories_with_default_colors)
                        params$palette <<- c(default_palette, na.omit(params$palette))
                    }

                    if (any(categories %notin% palette_names)){
                        categories_without_color <- categories[categories %notin% palette_names]
                        missing_palette <- setNames(default_colors(length(categories_without_color)), categories_without_color)
                        params$palette <<- c(missing_palette, params$palette)
                    }
                } else {
                    stop("The values in colorize imply a quantitative scale, which requires an unnamed vector of the form c(start_color[, middle_color], end_color)")
                }
            }
        },

        reorder_data_by_color = function(){
            data$colorize <<- params$colorize

            if (!is.null(names(params$palette))){
                category_order <- unlist(sapply(names(params$palette), function(category) {
                    which(data$colorize == category)
                }))
                data <<- data[rev(category_order),]
            } else {
                data <<- data[order(data$colorize, decreasing = TRUE),]
            }
        }

   )
)

# Ensures that a copy of all the assets used by the visualization exists in the output_xxx_assets path
export_assets <- function(opts){

    if (file.exists(opts$paths$shared_assets) && (!file.exists(opts$paths$output_shared_assets) || file.info(opts$paths$shared_assets)$mtime > file.info(opts$paths$output_shared_assets)$mtime)){
        dir.create(opts$paths$output_shared_assets, showWarnings = FALSE)
        file.copy(from = list.files(opts$paths$shared_assets, full.names = TRUE), to = opts$paths$output_shared_assets, overwrite = TRUE)
    }

    if (file.exists(opts$paths$template_assets) && (!file.exists(opts$paths$output_template_assets) || file.info(opts$paths$template_assets)$mtime > file.info(opts$paths$output_template_assets)$mtime)){
        dir.create(opts$paths$output_template_assets, showWarnings = FALSE)
        file.copy(from = list.files(opts$paths$template_assets, full.names = TRUE), to = opts$paths$output_template_assets, overwrite = TRUE)
    }

    invisible()
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
clickme <- function(data,
                    template,
                    params = NULL,
                    open = interactive(), link = FALSE, coffee = FALSE,
                    port = 8000,
                    ...){

    get_opts__ <- function(..., open, link) get_opts(...)
    opts <- get_opts__(template, params, coffee, port, ...)
    opts$data <- data

    generate_visualization(opts)

    export_assets(opts)

    if (open) browseURL(opts$url)

    if (link){
        make_link(opts$names$output_file, opts$params$title)
    } else {
        invisible(opts)
    }
}


