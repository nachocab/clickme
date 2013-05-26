get_xlim_param <- function(opts) {

    if (is.null(opts$params$xlim)){
        opts$params$xlim <- range(opts$data$x)
    }
    opts$params$xlim <- toJSON(opts$params$xlim)
    opts$params$xlim
}

get_ylim_param <- function(opts) {

    if (is.null(opts$params$ylim)){
        opts$params$ylim <- range(opts$data$y)
    }
    opts$params$ylim <- toJSON(opts$params$ylim)
    opts$params$ylim
}


# default: last column/variable name
get_color_group_param <- function(opts) {
    if (is.null(opts$params$color_group)){
        opts$params$color_group <- colnames(opts$data)[ncol(opts$data)]
    }
    # else if (opts$params$color_group %notin% colnames(opts$data)){
    #     browser()
    #     stop("The input data doesn't contain a column/variable named: ", opts$params$color_group)
    # }

    # TODO: decide what happens when length != nrows
    opts$data$color_group <- opts$params$color_group
    opts$params$color_group
}

get_color_values <- function(opts){
    color_values <- get_color_group_param(opts)
    color_values
}

get_color_domain_param <- function(opts){
    if (is.null(opts$params$color_domain)){
        color_values <- get_color_values(opts)
        if (is.numeric(color_values)){
            # quantitative
            opts$params$color_domain <- range(color_values, na.rm = TRUE)
        } else {
            # categorical
            opts$params$color_domain <- c(1, length(unique(color_values)))
        }
    }
    opts$params$color_domain <- toJSON(opts$params$color_domain)

    opts$params$color_domain
}

get_palette_param <- function(opts) {
    if (is.null(opts$params$palette)){
        color_values <- get_color_values(opts)
        if (is.numeric(color_values)){
            # quantitative
            if (length(unique(color_values)) == 1){
                opts$params$palette <- c("#000")
            } else {
                opts$params$palette <- c("steelblue", "#CA0020") # blue-red gradient
            }
        } else {
            # categorical
            if (length(unique(color_values)) == 1){
                opts$params$palette <- c("#000")
            } else {
                opts$params$palette <- default_colors(length(unique(color_values)))
            }
        }
    }

    opts$params$palette <- matrix2json(opts$params$palette)
    opts$params$palette
}

get_d3_color_scale <- function(opts) {
    color_values <- get_color_values(opts)
    if (is.numeric(color_values)) {
        # quantitative scale
        color_scale <- paste0("d3.scale.linear()
               .domain(", get_color_domain_param(opts), ")
               .range(", get_palette_param(opts), ")
               .interpolate(d3.interpolateLab);")
    } else {
        # categorical scale
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