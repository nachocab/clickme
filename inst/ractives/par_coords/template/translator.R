is_categorical_scale <- function(opts){
    color_values <- opts$data[, get_color_by_param(opts)]
    !is.numeric(color_values)
}

get_color_scale <- function(opts) {
    if (is_categorical_scale(opts)) {
        color_scale <- paste0("d3.scale.ordinal().range(", get_colors_param(opts),");")
    } else {
        color_scale <- paste0("d3.scale.linear()
               .domain(", get_domain_param(opts), ")
               .range(", get_colors_param(opts), ")
               .interpolate(d3.interpolateLab);")
    }

    color_scale
}

get_colors_param <- function(opts){
    if (is.null(opts$params$colors)){
        if (is_categorical_scale(opts)){
            d3_category10 <- c("#1f77b4", "#ff7f0e", "#2ca02c", "#d62728", "#9467bd", "#8c564b", "#e377c2", "#7f7f7f", "#bcbd22", "#17becf")
            d3_category10b <- c("#aec7e8", "#ffbb78", "#98df8a", "#ff9896", "#c5b0d5", "#c49c94", "#f7b6d2", "#c7c7c7", "#dbdb8d", "#9edae5")
            opts$params$colors <- c(d3_category10, d3_category10b)
        } else {
            opts$params$colors <- c("steelblue", "brown")
        }
    }
    opts$params$colors <- toJSON(opts$params$colors)
    opts$params$colors
}

get_color_by_param <- function(opts) {
    if (is.null(opts$params$color_by)){
        opts$params$color_by <- colnames(opts$data)[1]
    } else if (opts$params$color_by %notin% colnames(opts$data)){
        stop("The input data doesn't contain a column named: ", opts$params$color_by)
    }

    opts$params$color_by
}

get_domain_param <- function(opts){
    if (is.null(opts$params$domain)){
        color_values <- opts$data[, get_color_by_param(opts)]
        if (is.numeric(color_values)){
            opts$params$domain <- range(color_values, na.rm = TRUE)
        } else {
            opts$params$domain <- c(1, length(unique(color_values)))
        }
    }
    opts$params$domain <- toJSON(opts$params$domain)

    opts$params$domain
}

get_data_as_csv_file <- function(opts) {
    csv_file <-  create_data_file(opts, "csv")

    csv_file
}
