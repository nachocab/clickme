# Aux functions
vectors_to_line_data <- function(x, y, name){
    if (is.null(name))
        name <- "1"
    data <- xy_to_data(x,y)
    data$line_name <- name
    data <- list(unname(lapply(split(data, rownames(data)), as.list)))
    data
}

dataframes_to_line_data <- function(x, y, names){
    if (is.null(names))
        names <- as.character(1:nrow(x))
    data <- lapply(1:nrow(x), function(line_number){
        if (is.null(y)){
            line <- xy_to_data(x = 1:ncol(x),
                               y = unname(unlist(x[line_number, ])))
        } else {
            line <- xy_to_data(x = unname(unlist(x[line_number, ])),
                               y = unname(unlist(y[line_number, ])))
        }
        line$line_name <- names[line_number]
        line <- unname(lapply(split(line, rownames(line)), as.list))
        line
    })
    data
}

lists_to_line_data <- function(x, y, names){
    if (is.null(names))
        names <- as.character(1:length(x))

    data <- lapply(1:length(x), function(line_number){
        line <- xy_to_data(x = x[[line_number]],
                           y = y[[line_number]])
        line$line_name <- names[line_number]
        line <- unname(lapply(split(line, rownames(line)), as.list))
        line
    })
    data
}

# If x is a vector, convert it to a dataframe
ensure_dataframe <- function(x, num_rows){
    if (!is.null(num_rows) && !is_data_frame_or_matrix(x)){
        x <- matrix(rep(x, num_rows), nrow=num_rows, byrow=T)
    }
    x
}

Lines$methods(
    get_data = function(){
        if (is.null(params[["y"]])){
            if (is_data_frame_or_matrix(params[["x"]])){
                if (ncol(params[["x"]]) < 2) {
                    stop("When x is a dataframe or a matrix, it must contain at least two columns")
                }
                data <<- dataframes_to_line_data(x = params[["x"]],
                                                 y = NULL,
                                                 names = params$names)
            } else {
                data <<- vectors_to_line_data(x = 1:length(params[["x"]]),
                                              y = params[["x"]],
                                              name = params$names)
            }
        } else {
            if (is_data_frame_or_matrix(params[["x"]]) || is_data_frame_or_matrix(params[["y"]])) {
                # If params$x or params$y is a dataframe, the other must also be a dataframe.
                x <- ensure_dataframe(params[["x"]], nrow(params[["y"]]))
                y <- ensure_dataframe(params[["y"]], nrow(params[["x"]]))

                if (ncol(x) != ncol(y))
                    stop(sprintf("\nx and y have different number of columns: %s vs. %s",
                            ncol(x), ncol(y)))

                if (ncol(x) < 2)
                    stop("When x is a dataframe or a matrix, it must contain at least two columns")

                data <<- dataframes_to_line_data(x = x,
                                                 y = y,
                                                 names = params$names)
            } else {
                if (is.list(params[["x"]]) && is.list(params[["y"]])){
                    if (all(sapply(params[["x"]], length) != sapply(params[["y"]], length)))
                        stop(sprintf("\nx and y have different lengths: %s vs. %s",
                             paste(sapply(params[["x"]], length), collapse = " "),
                             paste(sapply(params[["x"]], length), collapse = " ")))
                    data <<- lists_to_line_data(x = params[["x"]],
                                                y = params[["y"]],
                                                names = params$names)
                } else {
                    data <<- vectors_to_line_data(x = params[["x"]],
                                                  y = params[["y"]],
                                                  name = params$names)
                }
            }
        }


       # data$line_name <<- as.character(params$names %or% rownames(data))
       # rownames(data) <<- NULL

       # data <<- add_extra_data_fields(data)
       # data <<- cluster_data_rows(data, params$color_groups, group_variable = "color_group", group_order = internal$ordered_color_group_names)

       # Reverse so the last color group gets the last color
       # params$palette <<- rev(params$palette)

       # data <<- apply_axes_limits(data)
       # data <<- na.omit(data)
       # params$formats <<- validate_formats(params$formats)
    },

    # Add any extra fields to the data object.
    # extra can be a list with as many elements as rows in data, or a data.frame or matrix with as many rows as data
    # This methods should be called before grouping rows
    add_extra_data_fields = function(x) {
        x$radius <- params$radius
        if (!is.null(params$extra)){
            x <- cbind(x, params$extra)
        }

        x
    },

    # It makes adjacent rows that belong to the same group
    # groups must have as many elements as data has rows
    # group_variable is the name of the varible that will be used to group the rows
    # group_order must have as many elements as groups, by default the order is
    # alphanumeric
    cluster_data_rows = function(x, groups, group_variable, group_order = NULL){
       if (!is.data.frame(x)){
           stop("\nData must be a dataframe to group its rows")
       }

       if (length(groups) > 1){
           x[[group_variable]] <- as.character(groups)

           if (!is.null(group_order)){
               order <- unlist(sapply(group_order, function(group_name) {
                   which(x[[group_variable]] == group_name)
               }))
           } else {
               order <- order(x[[group_variable]])
           }

           # Reverse so the first element is plotted last (and therefore
           # appears on top)
           x <- x[rev(order),]
       }

       x
    },

    apply_axes_limits = function(x) {
       if (!is.null(params$xlim)){
           x <- x[x$x >= params$xlim[1],]
           x <- x[x$x <= params$xlim[2],]
       }

       if (!is.null(params$ylim)){
           x <- x[x$y >= params$ylim[1],]
           x <- x[x$y <= params$ylim[2],]
       }

       x
    },

    validate_formats = function(formats){
        if (any(names(formats) %notin% colnames(data))){
            wrong_names <- names(formats)[names(formats) %notin% colnames(data)]
            stop(sprintf("\nThe following format names are not x, y, or any of the extra names:\n%s\n\n", enumerate(wrong_names)))
        }

        formats
    }

)