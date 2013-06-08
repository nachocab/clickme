get_col_names_param <- function(opts){
    toJSON(opts$params$col_names)
}

get_row_names_param <- function(opts){
    toJSON(opts$params$row_names)
}

get_color_domain_param <- function(opts) {
    if (is.null(opts$params$color_domain)){
        max <- max(abs(range(opts$data$unformatted, na.rm = TRUE)))
        opts$params$color_domain <- c(-max, 0, max)
    }

    toJSON(opts$params$color_domain)
}

get_palette_param <- function(opts){
    toJSON(opts$params$palette)
}

get_d3_color_scale <- function(opts){
    color_scale <- gettextf("d3.scale.linear().domain(%s).range(%s)", get_color_domain_param(opts), get_palette_param(opts))
    color_scale
}

get_d3_x_scale <- function(opts){
    scale <- gettextf("d3.scale.ordinal().domain(d3.range(%d)).rangeBands([0, plot.width])", ncol(opts$data$unformatted))
    scale
}

get_d3_y_scale <- function(opts){
    scale <- gettextf("d3.scale.ordinal().domain(d3.range(%d)).rangeBands([0, plot.height])", nrow(opts$data$unformatted))
    scale
}

get_data_as_json <- function(opts) {
    json_data <- toJSON(opts$data$formatted)

    json_data
}

get_data_as_json_file <- function(opts) {
    opts$data <- get_data_as_json(opts)
    json_file <- create_data_file(opts, "json")

    json_file
}
