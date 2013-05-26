get_points_data <- function(x,y){
    data <- suppressWarnings(xy.coords(x,y))
    data <- as.data.frame(data[c("x","y")])

    if (is.data.frame(x) | is.matrix(x)){
        rownames(data) <- rownames(x)
    }

    data
}


#' Generates an interactive scatterplot
#'
#' @param x x-values
#' @param y y-values
#' @param names y-values
#' @param title y-values
#' @param main same as title, kept for compatibility with \code{base::plot}
#' @param xlab,ylab x- and y-axis labels
#' @param xlim,ylim [to implement]
#' @param width,height width and height of the plot
#' @param radius the radius of the points
#' @param palette color palette. Quantitative scales expect a vector with a start color, and an end color (optionally, a middle color may be provided between both). Categorical scales expect a vector with a color for each category.
#' @param color_group. If it is a numeric vector, it will assume the scale is quantitative and it will generate a gradient using the start and end colors of the palette (also with the middle color, if it is provided). If it is a character vector, a logical vector, or a factor it will generate a categorical scale with one color per unique value (or level).
#' @param color_domain [to implement] a vector with a start and end value (an optionally a middle value between them). It is only used for quantitative scales. Useful when the scale is continuous and, for example, we want to ensure it is symmetric in negative and positive values.
#' @param padding padding around the top-level object
#' @param ... additional arguments for \code{clickme}
#'
#' \code{x} and \code{y} follow the same behavior as the base::plot function. If y is not defined, x is interpreted as y. x can be a vector, a list, a data.frame, or a matrix.
#'
#' @export
clickme_points <- function(x, y = NULL,
                      names = NULL,
                      title = "Points", main = NULL,
                      xlab = NULL, ylab = NULL,
                      xlim = NULL, ylim = NULL,
                      width = 980, height = 980,
                      radius = 5,
                      palette = NULL, color_group = NULL, color_domain = NULL,
                      padding = list(top = 80, right = 150, bottom = 30, left = 100),
                      ...){
    if (!is.null(main)) title <- main
    params <- as.list(environment())[-1]
    params[names(params) %in% c("x", "y", "main", "...")] <- NULL

    data <- get_points_data(x,y)

    if (is.null(names)){
        data$.name <- rownames(data)
    } else {
        data$.name <- names
    }

    if (!is.null(color_group)){
        data$.color_group <- color_group

        # ensure that the first group is rendered on top, then the second, and so on.
        data <- data[order(data$.color_group),] # TODO: ensure that this actually sorts by color_group
    }

    if (scale_type(data$.color_group) == "categorical" & !is.null(color_domain)){
        stop("A color domain can only be specified for quantitative scales. Current color_group: ", head(color_group))
    }

    clickme(data, "points", params = params, ...)
}



