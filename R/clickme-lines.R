format_lines_data <- function(data, x, data_colnames, params){
    formatted_data <- lapply(1:nrow(data), function(index){
        df <- data.frame(x = x, y = as.numeric(data[index, data_colnames]))
        values <- unname(lapply(split(df, rownames(df)), as.list))
        if (is.null(params$colorize)){
            list(line_name = rownames(data)[index], values = values)
        } else {
            list(line_name = rownames(data)[index], values = values, colorize = data$colorize[index])
        }
    })

    list(formatted = formatted_data, unformatted = data)
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

    rownames(data) <- params$line_names

    # save colnames before adding colorize (and potentially, other columns)
    data_colnames <- colnames(data)

    # we only create data$colorize when params$colorize is not null
    if (!is.null(params$colorize)){
        data <- reorder_data_by_color(data, params)
    }

    # data <- apply_limits(data, params)
    data <- format_lines_data(data, x, data_colnames, params)

    data
}


get_line_names <- function(data) {
    if (is.matrix(data)){
        line_names <- as.character(1:nrow(data))
    } else if (is.list(data)){
        if (is.null(names(data))){
            line_names <- as.character(1:length(data))
        } else {
            line_names <- names(data)
        }
    } else {
        # TODO: what if it is a factor? if as.character(factor) is not unique, stop("not unique values: ")
        line_names <- "1"
    }

    line_names
}

validate_lines_params <- function(params) {
    validate_colorize(params)

    if (!is.null(params$main)) {
        params$title <- params$main
    }

    if (!is.null(params$line_names)){
        params$line_names <- as.character(params$line_names)
    } else {
        params$line_names <- get_line_names(params$data)
    }

    params[names(params) %in% c("data", "main", "...")] <- NULL
    params
}


#' Generates an interactive line plot
#'
#' @param data matrix, data frame, or vector specifying y-values. A line is defined by the values of one row.
#' @param x x-values (optional). If specified by a numeric vector, it is used to set the tick values.
#' @param line_names line names
#' @param lwd line width
#' @param interpolate interpolation mode. Values linear (default), basis, cardinal and more: https://github.com/mbostock/d3/wiki/SVG-Shapes#wiki-line_interpolate
#' @param title title of the plot
#' @param main same as title, kept to be compatible with \code{base::plot}
#' @param xlab,ylab x- and y-axis labels
#' @param width,height width and height of the plot
#' @param box draw a box around the plot
#' @param palette color palette. Quantitative scales expect a vector with a start color, and an end color (optionally, a middle color may be provided between both). Categorical scales expect a vector with a color for each category. Use category names to change the default color assignment \code{c(category1="color1", category2="color2")}. The order in which these colors are specified determines rendering order when points from different categories collide (colors specified first appear on top of later ones). Colors can be a variety of formats: "#ffeeaa" "rgb(255,255,255)" "hsl(120,50%,20%)" "blue" (see http://www.w3.org/TR/SVG/types.html#ColorKeywords)
#' @param colorize a vector whose values are used to determine the color of the points. If it is a numeric vector, it will assume the scale is quantitative and it will generate a gradient using the start and end colors of the palette (also with the middle color, if it is provided). If it is a character vector, a logical vector, or a factor, it will generate a categorical scale with one color per unique value (or level).
#' @param color_domain a vector with a start and end value (an optionally a middle value between them). It is only used for quantitative scales. Useful when the scale is continuous and, for example, we want to ensure it is symmetric in negative and positive values.
#' @param color_legend_title the title of the color legend
#' @param padding padding around the top-level object
#' @param ... additional arguments for \code{clickme}
#'
#' @export
clickme_lines <- function(data, x = colnames(data),
                      line_names = rownames(data),
                      lwd = 3,
                      interpolate = "linear",
                      title = "Lines", main = NULL,
                      xlab = NULL, ylab = NULL,
                      # xlim = NULL, ylim = NULL,
                      width = 980, height = 980,
                      box = NULL,
                      palette = NULL, colorize = NULL, color_domain = NULL, color_legend_title = NULL,
                      padding = list(top = 80, right = 400, bottom = 30, left = 100),
                      ...){
    params <- as.list(environment())
    params <- validate_lines_params(params)
    params$code <- paste(deparse(sys.calls()[[1]]), collapse="")
    data <- get_lines_data(data, x, params)

    # this must be done *after* data has been sorted to ensure the first category (which will be rendered at the bottom) gets the last color
    params$palette <- rev(params$palette)

    clickme(data, "lines", params = params, ...)
}


