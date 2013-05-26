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
#' @param palette color palette
#' @param color_group vector used to determine how to color each point. If it contains numeric values, it will generate a continuous gradient from the colors in the palette. If it contains factors or characters, it will generate a discrete scale (one color per level, or unique character element)
#' @param color_domain [to implement]
#' @param padding padding around the top-level object
#' @param ... additional arguments for \code{clickme}
#'
#' \code{x} and \code{y} follow the same behavior as the base::plot function. If y is not defined, x is interpreted as y. x can be a vector, a list, a data.frame, or a matrix.
#'
#' @export
cm_points <- function(x, y = NULL,
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
    data$.color_group <- color_group

    if (!is.null(data$.color_group)){
        data <- data[order(data$.color_group),]
    }

    clickme(data, "points", params = params, ...)
}



