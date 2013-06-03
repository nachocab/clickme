validate_points_params <- function(params) {
    validate_colorize(params)

    if (!is.null(params$main)) {
        params$title <- params$main
    }

    if (!is.null(params$point_names)){
        params$point_names <- as.character(params$point_names)
    } else {
        params$point_names <- get_row_names(params$x)
    }

    params[names(params) %in% c("x", "y", "main", "...")] <- NULL
    params
}

apply_points_limits <- function(data, params) {
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

get_points_data <- function(x, y, params){
    data <- suppressWarnings(xy.coords(x,y))
    data <- as.data.frame(data[c("x","y")])

    if (is.data.frame(x) | is.matrix(x)){
        rownames(data) <- rownames(x)
    }

    data$point_name <- params$point_names

    # we only create data$colorize when params$colorize is not NULL. When it is NULL, d3_color_scale(null) returns a color.
    if (!is.null(params$colorize)){
        data <- reorder_data_by_color(data, params)
    }

    data <- apply_points_limits(data, params)

    data
}



#' Generates an interactive scatterplot
#'
#' @param x x-values, but only if the "y" param is specified, otherwise it represents the y-values. It can be a dataframe, a matrix, a vector, a list, or a factor (test this).
#' @param y y-values (optional)
#' @param point_names point names
#' @param title title of the plot
#' @param main same as title, kept to be compatible with \code{base::plot}
#' @param xlab,ylab x- and y-axis labels
#' @param xlim,ylim x- and y-axis limits
#' @param width,height width and height of the plot
#' @param radius the radius of the points
#' @param box Draws a box around the plot if TRUE.
#' @param palette color palette. Quantitative scales expect a vector with a start color, and an end color (optionally, a middle color may be provided between both). Categorical scales expect a vector with a color for each category. Use category names to change the default color assignment \code{c(category1="color1", category2="color2")}. The order in which these colors are specified determines rendering order when points from different categories collide (colors specified first appear on top of later ones). Colors can be a variety of formats:
#' rgb decimal - "rgb(255,255,255)"
#' hsl decimal - "hsl(120,50%,20%)"
#' rgb hexadecimal - "#ffeeaa"
#' rgb shorthand hexadecimal - "#fea"
#' CSS named - "red", "white", "blue" (see http://www.w3.org/TR/SVG/types.html#ColorKeywords)
#' @param colorize a vector whose values are used to determine the color of the points. If it is a numeric vector, it will assume the scale is quantitative and it will generate a gradient using the start and end colors of the palette (also with the middle color, if it is provided). If it is a character vector, a logical vector, or a factor, it will generate a categorical scale with one color per unique value (or level).
#' @param color_domain [to implement] a vector with a start and end value (an optionally a middle value between them). It is only used for quantitative scales. Useful when the scale is continuous and, for example, we want to ensure it is symmetric in negative and positive values.
#' @param padding padding around the top-level object
#' @param ... additional arguments for \code{clickme}
#'
#' @export
clickme_points <- function(x, y = NULL,
                      point_names = rownames(x),
                      title = "Points", main = NULL,
                      xlab = NULL, ylab = NULL,
                      xlim = NULL, ylim = NULL,
                      width = 980, height = 980,
                      radius = 5,
                      box = NULL,
                      palette = NULL, colorize = NULL, color_domain = NULL, color_order = NULL,
                      padding = list(top = 80, right = 200, bottom = 30, left = 100),
                      ...){
    params <- as.list(environment())
    params <- validate_points_params(params)
    data <- get_points_data(x, y, params)

    # this must be done *after* data has been sorted to ensure the first category (which will be rendered at the bottom) gets the last color
    params$palette <- rev(params$palette)

    clickme(data, "points", params = params, ...)
}

