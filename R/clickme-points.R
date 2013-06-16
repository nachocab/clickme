get_point_names <- function(data) {
    if (is.matrix(data)){
        point_names <- as.character(1:nrow(data))
    } else if (is.list(data)){
        if (is.null(names(data))){
            point_names <- as.character(1:length(data))
        } else {
            point_names <- names(data)
        }
    } else {
        # TODO: what if it is a factor? if as.character(factor) is not unique, stop("not unique values: ")
        point_names <- as.character(1:length(data))
    }

    point_names
}

# ensure that main is converted to title, and that there are point_names
validate_points_params <- function(params) {
    params <- validate_colorize_and_palette(params)

    if (!is.null(params$main)) {
        params$title <- params$main
    }

    if (!is.null(params$point_names)){
        params$point_names <- as.character(params$point_names)
    } else {
        params$point_names <- get_point_names(params$x)
    }

    params[names(params) %in% c("x", "y", "main", "...")] <- NULL
    params
}


add_extra_fields <- function(data, params) {
    if (!is.null(params$extra)){
        data <- cbind(data, params$extra)
    }
    data
}

# TODO: these functions should be private to the clickme points class. utils should be a global template class, and points/lines/heatmap should be instances of that class
apply_axes_limits <- function(data, params) {
    if (!is.null(params$xlim)){
        data <- data[data$x >= params$xlim[1],]
        data <- data[data$x <= params$xlim[2],]
    }

    if (!is.null(params$ylim)){
        data <- data[data$y >= params$ylim[1],]
        data <- data[data$y <= params$ylim[2],]
    }
    data
}

get_points_data <- function(data, params){

    if (is.null(params$point_names)){
        data$point_name <- rownames(data)
    } else {
        data$point_name <- params$point_names
    }
    rownames(data) <- NULL

    data <- add_extra_fields(data, params)

    # we only create data$colorize when params$colorize is not NULL. When it is NULL, d3_color_scale(null) returns "black"
    if (!is.null(params$colorize)){
        data <- reorder_data_by_color(data, params)
    }

    data <- apply_axes_limits(data, params)

    data
}


# data is assumed to have at least x, y, and point_name
get_tooltip_content_points <- function(data, params){
    names <- colnames(data)
    tooltip_contents <- c("<strong>#{d.point_name}</strong>", paste0(params$ylab, ": #{format_property(d.y)}"), paste0(params$xlab, ": #{format_property(d.x)}"))
    names <- setdiff(names, c("x", "y", "point_name", "colorize"))

    tooltip_contents <- c(tooltip_contents, sapply(names, function(name) paste0(name, ": #{format_property(d[\"", name, "\"])}")))
    tooltip_contents <- paste(tooltip_contents, collapse = "<br>")
    tooltip_contents
}


#' Generates an interactive scatterplot
#'
#' @param x x-values, but only if the "y" param is specified, otherwise it represents the y-values. It can be a dataframe, a matrix, a vector, a list, or a factor (TODO test this).
#' @param y y-values (optional)
#' @param point_names point names
#' @param title title of the plot
#' @param main same as title, kept to be compatible with \code{base::plot}
#' @param xlab,ylab x- and y-axis labels
#' @param xlim,ylim x- and y-axis limits
#' @param width,height width and height of the plot
#' @param radius the radius of the points
#' @param box draws a box around the plot
#' @param palette color palette. Quantitative scales expect a vector with a start color, and an end color (optionally, a middle color may be provided between both). Categorical scales expect a vector with a color for each category. Use category names to change the default color assignment \code{c(category1="color1", category2="color2")}. The order in which these colors are specified determines rendering order when points from different categories collide (colors specified first appear on top of later ones). Colors can be a variety of formats: "#ffeeaa" "rgb(255,255,255)" "hsl(120,50%,20%)" "blue" (see http://www.w3.org/TR/SVG/types.html#ColorKeywords)
#' @param colorize a vector whose values are used to determine the color of the points. If it is a numeric vector, it will assume the scale is quantitative and it will generate a gradient using the start and end colors of the palette (also with the middle color, if it is provided). If it is a character vector, a logical vector, or a factor, it will generate a categorical scale with one color per unique value (or level).
#' @param color_domain a vector with a start and end value (an optionally a middle value between them). It is only used for quantitative scales. Useful when the scale is continuous and, for example, we want to ensure it is symmetric in negative and positive values.
#' @param color_title the title of the color legend
#' @param extra a data frame, list or matrix whose fields will appear in the tooltip on hover
#' @param padding padding around the top-level object
#' @param ... additional arguments for \code{clickme}
#'
#' @export
clickme_points <- function(x, y = NULL,
                      point_names = rownames(x),
                      title = "Points", main = NULL,
                      xlab = "x", ylab = "y",
                      xlim = NULL, ylim = NULL,
                      width = 980, height = 980,
                      radius = 5,
                      box = FALSE,
                      jitter = 0,
                      extra = NULL,
                      palette = NULL, colorize = NULL, color_domain = NULL, color_title = NULL,
                      padding = list(top = 80, right = 400, bottom = 30, left = 100),
                      ...){
    params <- as.list(environment())
    params <- validate_points_params(params)

    params$code <- paste(deparse(sys.calls()[[1]]), collapse="")

    data <- xy_to_data(x,y)
    params$x_categorical_domain <- data$x
    data <- get_points_data(data, params)

    # this must be done *after* data has been sorted to ensure the first category (which will be rendered at the bottom) gets the last color
    params$palette <- rev(params$palette)

    clickme(data, "points", params = params, ...)
}

