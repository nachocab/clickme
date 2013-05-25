
get_points_data <- function(x,y){
    data <- suppressWarnings(xy.coords(x,y))
    data <- as.data.frame(data[c("x","y")])

    if (is.data.frame(x)){
        if ("name" %in% colnames(x)){
            data$name <- x$name
        } else {
            data$name <- rownames(x)
        }
        # if ("group" %in% colnames(x)){
        #     data$group <- x$group
        # } else {
        #     data$group <- 1
        # }
    } else if (is.list(x)){
        if ("name" %in% names(x)){
            data$name <- x$name
        } else {
            data$name <- rownames(data)
        }
        # if ("group" %in% names(x)){
        #     data$group <- x$group
        # } else {
        #     data$group <- 1
        # }
    } else if (is.matrix(x)){
        if ("name" %in% colnames(x)){
            data$name <- x[, "name"]
        } else {
            data$name <- rownames(x)
        }
        # if ("group" %in% colnames(x)){
        #     data$group <- x[, "group"]
        # } else {
        #     data$group <- 1
        # }
    } else {
        data$name <- rownames(data)
        # data$group <- 1
    }

    data
}

#' Generates an interactive scatterplot
#'
#' @param x x-values
#' @param y y-values
#' @param ... additional arguments for \code{clickme}
#'
#' \code{x} and \code{y} follow the same behavior as the base::plot function. If y is not defined, x is interpreted as y. x can be a vector, a list, a data.frame, or a matrix.
#'
#' @export
clickme_points <- function(x, y = NULL,
                           title = "Points", main = NULL,
                           xlab = NULL, ylab = NULL,
                           xlim = NULL, ylim = NULL,
                           width = 650, height = 650,
                           radius = 5,
                           palette = NULL, color_group = NULL, color_domain = NULL,
                           padding = c(top = 80, right = 150, bottom = 30, left = 100),
                           ...){

    data <- get_points_data(x,y)

    if (!is.null(main)) title <- main

    aux_clickme <- function(...){ clickme(...) }
    aux_clickme(data, "points", ...)
}


