get_color_legend_counts <- function(opts){
    toJSON(table(opts$data$unformatted$colorize))
}

get_x_tick_values <- function(opts) {
    if (!is.null(params$x) & is.numeric(params$x)){
        tick_values <- params$x
    } else {
        tick_values <- NULL
    }

    toJSON(tick_values)
}

get_d3_x_scale <- function(opts) {
    if (is.null(params$x)){
        x <- 1:ncol(opts$data$unformatted)
    } else {
        x <- params$x
    }

    if (scale_type(x) == "quantitative"){
        if (!is.null(params$xlim)){
            domain <- params$xlim
        } else {
            domain <- range(x, na.rm = TRUE)
        }
        scale <- paste0("d3.scale.linear()
                .domain(", toJSON(domain), ")
                .range([0, plot.width])")
    } else {
        scale <- paste0("d3.scale.ordinal()
                .domain(", toJSON(x), ")
                .rangePoints([0, plot.width], .1)")
    }

    scale
}

get_d3_y_scale <- function(opts) {
    if (!is.null(opts$data$unformatted$colorize)){
        y <- subset(opts$data$unformatted, select = -c(colorize))
    } else {
        y <- opts$data$unformatted
    }

    if (!is.null(params$ylim)){
        domain <- params$ylim
    } else {
        domain <- range(y, na.rm = TRUE)
    }

    scale <- paste0("d3.scale.linear()
            .domain(", toJSON(domain), ")
            .range([plot.height, 0])")

    scale
}

# only for quantitative scales
get_color_domain_param <- function(opts){
    colorize <- opts$data$unformatted$colorize
    # we don't do this in validate_lines_params because it depends on data$colorize, which is defined later, in get_lines_data().
    if (is.null(params$color_domain)){
        params$color_domain <- range(colorize, na.rm = TRUE)
    }

    toJSON(params$color_domain)
}

get_palette_param <- function(opts) {
    if (is.null(params$palette)){
        colorize <- opts$data$unformatted$colorize
        if (is.null(colorize) | length(unique(colorize)) == 1){
                params$palette <- c("#000")
        } else {
            if (scale_type(colorize) == "quantitative"){
                params$palette <- c("steelblue", "#CA0020") # blue-red gradient
            } else {
                params$palette <- rev(default_colors(length(unique(colorize))))
            }
        }
    }

    matrix2json(params$palette) # toJSON(c(2)) returns "2" instead of "[2]"
}

get_color_legend <- function(opts){
    toJSON(rev(params$palette))
}

get_d3_color_scale <- function(opts) {
    colorize <- opts$data$unformatted$colorize
    if (scale_type(colorize) == "quantitative") {
        color_scale <- paste0("d3.scale.linear()
               .domain(", get_color_domain_param(opts), ")
               .range(", get_palette_param(opts), ")
               .interpolate(d3.interpolateLab);")
    } else {
        color_scale <- paste0("d3.scale.ordinal().range(", get_palette_param(opts),");")
    }

    color_scale
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
