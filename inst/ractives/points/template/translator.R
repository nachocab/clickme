get_xlim_param <- function(opts) {
    if (is.null(opts$params$xlim)){
        opts$params$xlim <- range(opts$data$x)
    }
    toJSON(opts$params$xlim)
}

get_ylim_param <- function(opts) {
    if (is.null(opts$params$ylim)){
        opts$params$ylim <- range(opts$data$y)
    }
    toJSON(opts$params$ylim)
}

# only for quantitative scales
get_color_domain_param <- function(opts){
    if (is.null(opts$params$color_domain)){
        opts$params$color_domain <- range(opts$data$colorize, na.rm = TRUE)
    }
    opts$params$color_domain <- toJSON(opts$params$color_domain)

    opts$params$color_domain
}

get_palette_param <- function(opts) {
    if (is.null(opts$params$palette)){
        if (is.null(opts$data$colorize) | length(unique(opts$data$colorize)) == 1){
                opts$params$palette <- c("#000")
        } else {
            if (scale_type(opts$data$colorize) == "quantitative"){
                opts$params$palette <- c("steelblue", "#CA0020") # blue-red gradient
            } else {
                opts$params$palette <- rev(default_colors(length(unique(opts$data$colorize))))
            }
        }
    }

    matrix2json(opts$params$palette) # toJSON(c(2)) returns "2" instead of "[2]"
}

get_color_legend <- function(opts){
    toJSON(rev(opts$params$palette))
}

get_d3_color_scale <- function(opts) {
    if (scale_type(opts$data$colorize) == "quantitative") {
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
    library(df2json)
    json_data <- df2json(opts$data)

    json_data
}

get_data_as_json_file <- function(opts) {
    opts$data <- as.data.frame(opts$data, stringsAsFactors= FALSE)
    opts$data <- get_data_as_json(opts)
    json_file <- create_data_file(opts, "json")

    json_file
}