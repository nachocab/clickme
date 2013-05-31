get_nested_lines <- function(data, x, data_colnames, params){
    data <- lapply(1:nrow(data), function(index){
        df <- data.frame(x = x, y = as.numeric(data[index, data_colnames]))
        values <- lapply(split(df, rownames(df)), as.list)
        names(values) <-  NULL
        if (is.null(data$colorize[index])){
            list(line_name = params$names[index], values = values)
        } else {
            list(line_name = params$names[index], values = values, colorize = data$colorize[index])
        }
    })

    data
}

undo_nested_lines <- function(data){
    df <- t(sapply(data, function(data){
        sapply(data$values, "[[", "y")
    }))

    x <- sapply(data[[1]]$values, "[[", "x")
    df <- as.data.frame(df)
    colnames(df) <- x
    rownames(df) <- sapply(data, "[[", "line_name")
    df
}

get_lines_data <- function(data, x, params){
    if (is.vector(data)){
        data <- as.data.frame(t(data))
    }

    if (is.matrix(data)){
        data <- as.data.frame(data)
    }

    if (is.null(x)){
        x <- 1:ncol(data)
    } else {
        if (length(x) > ncol(data)){
            stop("You have provided more x-values than columns in your data: ", paste0(x, collapse = ", "))
        } else {
            colnames(data) <- x
        }
    }

    if (is.null(params$names)) {
        params$names <- 1:nrow(data)
    }
    rownames(data) <- params$names

    # save colnames before adding colorize (and potentially, other columns)
    data_colnames <- colnames(data)

    # we only create data$colorize when params$colorize is not null
    if (!is.null(params$colorize)){
        data <- reorder_data_by_color(data, params)
    }

    data <- apply_limits(data, params)

    data <- get_nested_lines(data, x, data_colnames, params)

    data
}

validate_lines_params <- function(params) {

    if (!is.null(params$names)){
        params$names <- as.character(params$names)
    }

    if (scale_type(params$colorize) == "categorical" & !is.null(params$color_domain)){
        stop("A color domain can only be specified for quantitative scales. colorize has categorical values.")
    }

    palette_names <- names(params$palette)
    categories <- unique(params$colorize)
    if (!is.null(params$colorize) & !is.null(params$palette) & !is.null(palette_names)) {
        if (scale_type(params$colorize) == "categorical"){
            if (any(categories %notin% palette_names)){
                stop("The following categories don't have a color in palette: ", paste0(categories[categories %notin% palette_names], collapse = ", "))
            }
            if (any(palette_names %notin% categories)) {
                stop("The following palette names don't appear in colorize: ", paste0(palette_names[palette_names %notin% categories], collapse = ", "))
            }
        } else {
            stop("The values in colorize imply a quantitative scale, which requires an unnamed vector of the form c(start_color[, middle_color], end_color)")
        }
    }

    if (!is.null(params$main)) {
        params$title <- params$main
    }

    params[names(params) %in% c("data", "main", "...")] <- NULL
    params
}


#' Generates an interactive line plot
#'
#' @param data matrix, data frame, or vector specifying y-values. A line is defined by the values of one row.
#' @param x x-values (optional). If specified by a numeric vector, it is used to set the tick values.
#' @param names line names
#' @param lwd line width
#' @param interpolate interpolation mode. Linear by default, read about other options: https://github.com/mbostock/d3/wiki/SVG-Shapes#wiki-line_interpolate
#' @param title title of the plot
#' @param main same as title, kept to be compatible with \code{base::plot}
#' @param xlab,ylab x- and y-axis labels
#' @param xlim,ylim x- and y-axis limits
#' @param width,height width and height of the plot
#' @param radius the radius of the points
#' @param palette color palette. Quantitative scales expect a vector with a start color, and an end color (optionally, a middle color may be provided between both). Categorical scales expect a vector with a color for each category. Use category names to change the default color assignment \code{c(category1="color1", category2="color2")}. The order in which these colors are specified determines rendering order when points from different categories collide (colors specified first appear on top of later ones). Colors can be a variety of formats:
#' rgb decimal - "rgb(255,255,255)"
#' hsl decimal - "hsl(120,50%,20%)"
#' rgb hexadecimal - "#ffeeaa"
#' rgb shorthand hexadecimal - "#fea"
#' CSS named - "red", "white", "blue" (see http://www.w3.org/TR/SVG/types.html#ColorKeywords)
#' @param colorize a vector whose values are used to determine the color of the points. If it is a numeric vector, it will assume the scale is quantitative and it will generate a gradient using the start and end colors of the palette (also with the middle color, if it is provided). If it is a character vector, a logical vector, or a factor, it will generate a categorical scale with one color per unique value (or level).
#' @param color_domain [to implement] a vector with a start and end value (an optionally a middle value between them). It is only used for quantitative scales. Useful when the scale is continuous and, for example, we want to ensure it is symmetric in negative and positive values.
#' @param order order of categories (overrides the implicit order of names in palette)
#' @param padding padding around the top-level object
#' @param ... additional arguments for \code{clickme}
#'
#' \code{x} and \code{y} follow the same behavior as the base::plot function. If y is not defined, x is interpreted as y. x can be a vector, a list, a data.frame, or a matrix.
#'
#' @export
clickme_lines <- function(data, x = colnames(data),
                      names = rownames(data),
                      lwd = 3,
                      interpolate = "linear",
                      title = "Lines", main = NULL,
                      xlab = NULL, ylab = NULL,
                      xlim = NULL, ylim = NULL,
                      width = 980, height = 980,
                      palette = NULL, colorize = NULL, color_domain = NULL, order = NULL,
                      padding = list(top = 80, right = 150, bottom = 30, left = 100),
                      ...){
    params <- as.list(environment())[-1]
    params <- validate_lines_params(params)
    data <- get_lines_data(data, x, params)

    clickme(data, "lines", params = params, ...)
}


