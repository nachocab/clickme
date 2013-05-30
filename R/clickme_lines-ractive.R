get_nested_lines <- function(data, x, params){
    data <- lapply(params$names, function(name){
        df <- data.frame(x = x, y = as.numeric(data[name, x]))
        values <- lapply(split(df, rownames(df)), as.list)
        names(values) <-  NULL
        if (is.null(data$colorize__[name])){
            list(name = name, values = values)
        } else {
            list(name = name, values = values, colorize__ = data$colorize__[name])
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
    rownames(df) <- sapply(data, "[[", "name")
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

    if (!is.null(params$colorize)){
        data <- reorder_data_by_color(data, params)
    }

    data <- apply_limits(data, params)

    data <- get_nested_lines(data, x, params)

    data
}

validate_lines_params <- function(params) {

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

    params[names(params) %in% c("data", "x", "main", "...")] <- NULL
    params
}

clickme_lines <- function(data, x = colnames(data),
                      names = rownames(data),
                      title = "Lines", main = NULL,
                      xlab = NULL, ylab = NULL,
                      xlim = NULL, ylim = NULL,
                      width = 980, height = 980,
                      palette = NULL, colorize = NULL, color_domain = NULL,
                      padding = list(top = 80, right = 150, bottom = 30, left = 100),
                      ...){
    params <- as.list(environment())[-1]
    params <- validate_lines_params(params)
    data <- get_lines_data(data, x, params)

    # this must be done *after* data has been sorted to ensure the first category (which will be rendered at the bottom) gets the last color
    # params$palette <- rev(params$palette)

    clickme(data, "lines", params = params, ...)
}


