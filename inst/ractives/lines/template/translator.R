get_x_tick_values <- function(opts) {
    if (!is.null(opts$params$x) & is.numeric(opts$params$x)){
        tick_values <- opts$params$x
    } else {
        tick_values <- NULL
    }

    toJSON(tick_values)
}

get_d3_x_scale <- function(opts) {
    if (is.null(opts$params$x)){
        x <- 1:ncol(unformat_lines_data(opts$data))
    } else {
        x <- opts$params$x
    }

    if (scale_type(x) == "quantitative"){
        if (!is.null(opts$params$xlim)){
            domain <- opts$params$xlim
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
    y <- unformat_lines_data(opts$data)

    if (!is.null(opts$params$ylim)){
        domain <- opts$params$ylim
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
    colorize <- sapply(opts$data, "[[", "colorize")

    # we don't do this in validate_lines_params because it depends on data$colorize, which is defined later, in get_lines_data().
    if (is.null(opts$params$color_domain)){
        opts$params$color_domain <- range(colorize, na.rm = TRUE)
    }

    toJSON(opts$params$color_domain)
}

get_palette_param <- function(opts) {
    if (is.null(opts$params$palette)){
        colorize <- sapply(opts$data, "[[", "colorize")
        if (is.null(colorize) | length(unique(colorize)) == 1){
                opts$params$palette <- c("#000")
        } else {
            if (scale_type(colorize) == "quantitative"){
                opts$params$palette <- c("steelblue", "#CA0020") # blue-red gradient
            } else {
                opts$params$palette <- rev(default_colors(length(unique(colorize))))
            }
        }
    }

    matrix2json(opts$params$palette) # toJSON(c(2)) returns "2" instead of "[2]"
}

get_color_legend <- function(opts){
    toJSON(rev(opts$params$palette))
}

get_d3_color_scale <- function(opts) {
    colorize <- sapply(opts$data, "[[", "colorize")
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
    json_data <- toJSON(opts$data)

    json_data
}

get_data_as_json_file <- function(opts) {
    opts$data <- get_data_as_json(opts)
    json_file <- create_data_file(opts, "json")

    json_file
}
