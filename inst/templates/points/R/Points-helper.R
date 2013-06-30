Points$methods(

    get_color_legend_counts = function() {
        table(data$colorize)
    }

)
# only for quantitative scales
get_color_domain_param <- function(opts){
    if (is.null(params$color_domain)){
        params$color_domain <- range(opts$data$colorize, na.rm = TRUE)
    }

    params$color_domain
}

get_palette_param <- function(opts) {
    palette_names <- names(params$palette)
    categories <- unique(params$colorize)
    if (is.null(params$palette)){
        if (is.null(opts$data$colorize) | length(unique(opts$data$colorize)) == 1){
                params$palette <- c("#000")
        } else {
            if (scale_type(opts$data$colorize) == "quantitative"){
                params$palette <- c("steelblue", "#CA0020") # blue-red gradient
            } else {
                params$palette <- rev(default_colors(length(categories)))
            }
        }
    }

    matrix2json(params$palette) # toJSON(c(2)) returns "2" instead of "[2]"
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

