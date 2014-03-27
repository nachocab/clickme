Lines$methods(
    get_data = function() {
        # TODO: eventually, you should put names and color_groups inside extra
        data <<- unify_format(x = params[["x"]],
                              y = params[["y"]],
                              names = params$names,
                              color_groups = params$color_groups,
                              extra = params$extra)

        if (!is.null(params$color_groups) && length(params$color_groups) > 1) {
            if (length(params$color_groups) != length(data))
                stop(sprintf("\nThe number of color_groups is %s, but the number of lines is %s",
                    length(params$color_groups),
                    length(data)))

            line_names <- sapply(data, function(line) line[[1]]$line_name)
            ordered_color_group_names <- get_ordered_color_group_names()
            data <<- order_data_by_color_group(data,
                                               line_names,
                                               params$color_groups,
                                               ordered_color_group_names)
        }

        # apply_axes_limits() # TODO: not a priority, maybe we should just change viewport
        # remove_invalid() # TODO

        # Reverse so the last color group gets the last color
        # TODO: move this to get_params()
        # params$palette <<- rev(params$palette)

        # we call validate_tooltip_formats here because it depends on data
        # validate_tooltip_formats()
    },

    # internal, template-specific
    unify_format = function(x, y, names, color_groups, extra) {
        if (is.null(y)){
            if (is_data_frame_or_matrix(x)){
                if (ncol(x) < 2) {
                    stop("When x is a dataframe or a matrix, it must contain at least two columns")
                }
                data <- dataframes_to_line_data(x = x,
                                                 y = NULL,
                                                 names = names,
                                                 color_groups = color_groups,
                                                 extra = extra)
            } else {
                data <- vectors_to_line_data(x = 1:length(x),
                                              y = x,
                                              names = names,
                                              extra = extra)
            }
        } else {
            if (is_data_frame_or_matrix(x) || is_data_frame_or_matrix(y)) {
                # If params$x or params$y is a dataframe, the other must also be a dataframe.
                x <- ensure_is_dataframe(x, nrow(y))
                y <- ensure_is_dataframe(y, nrow(x))

                if (ncol(x) != ncol(y))
                    stop(sprintf("\nx and y have different number of columns: %s vs. %s",
                            ncol(x), ncol(y)))

                if (ncol(x) < 2)
                    stop("When x is a dataframe or a matrix, it must contain at least two columns")

                data <- dataframes_to_line_data(x = x,
                                                 y = y,
                                                 names = names,
                                                 color_groups = color_groups,
                                                 extra = extra)
            } else {
                if (is.list(x) && is.list(y)){
                    if (all(sapply(x, length) != sapply(y, length)))
                        stop(sprintf("\nx and y have different lengths: %s vs. %s",
                             paste(sapply(x, length), collapse = " "),
                             paste(sapply(x, length), collapse = " ")))
                    data <- lists_to_line_data(x = x,
                                                y = y,
                                                names = names,
                                                color_groups = color_groups,
                                                extra = extra)
                } else {
                    data <- vectors_to_line_data(x = x,
                                                  y = y,
                                                  names = names,
                                                  extra = extra)
                }
            }
        }
        data
    },

    # internal
    add_extra = function(data, extra){
        if (!is.null(extra)) {
            data <- cbind(data, extra)
        }
        data
    },

    # internal
    to_line_data = function(data, names){
        unname(lapply(split(data, names)[names], as.list))
    },

    # internal
    vectors_to_line_data = function(x, y, names, extra){
        if (is.null(names))
            names <- "1"
        data <- xy_to_data(x,y)

        data$line_name <- names
        data <- add_extra(data, extra)

        data <- list(to_line_data(data, rownames(data)))
        data
    },

    # internal
    dataframes_to_line_data = function(x, y, names, color_groups, extra){
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
            line$color_group <- color_groups[line_number]
            line <- add_extra(line, extra[[line_number]])

            line <- to_line_data(line, rownames(line))
            line
        })
        data
    },

    # internal
    lists_to_line_data = function(x, y, names, color_groups, extra){
        if (is.null(names))
            names <- as.character(1:length(x))

        data <- lapply(1:length(x), function(line_number){
            line <- xy_to_data(x = x[[line_number]],
                               y = y[[line_number]])

            line$line_name <- names[line_number]
            line$color_group <- color_groups[line_number]
            line <- add_extra(line, extra[[line_number]])

            line <- to_line_data(line, rownames(line))
            line
        })
        data
    },

    # internal
    # If x is a vector, convert it to a dataframe
    ensure_is_dataframe = function(x, num_rows){
        if (!is.null(num_rows) && !is_data_frame_or_matrix(x)){
            x <- matrix(rep(x, num_rows), nrow=num_rows, byrow=T)
        }
        x
    },

    # internal
    order_data_by_color_group = function(data, data_names, color_groups, ordered_color_group_names){
        names_groups <- data.frame(names = data_names, groups = color_groups)
        data_order <- unlist(sapply(ordered_color_group_names, function(group_name) {
            which(names_groups$group == group_name)
        }))

        # Reverse so the first element is plotted last (and therefore
        # appears on top)
        data_order <- rev(data_order)
        data <- data[data_order]
        data
    },

    # internal
    get_point_value = function(lines_data, variable_name){
        as.vector(sapply(lines_data, function(line) sapply(line, function(point) point[[variable_name]])))
    },

    # internal
    # apply_axes_limits = function() {
    #    if (!is.null(params$xlim)){
    #        data <<- data[data$x >= params$xlim[1],]
    #        data <<- data[data$x <= params$xlim[2],]
    #    }

    #    if (!is.null(params$ylim)){
    #        data <<- data[data$y >= params$ylim[1],]
    #        data <<- data[data$y <= params$ylim[2],]
    #    }
    #    return()
    # },

    # # internal
    # remove_invalid = function(){
    #     data <<- na.omit(data)
    #     return()
    # },

    # internal
    validate_tooltip_formats = function(){
        if (any(names(params$tooltip_formats) %notin% colnames(data))){
            wrong_names <- names(params$tooltip_formats)[names(params$tooltip_formats) %notin% colnames(data)]
            stop(sprintf("\nThe following format names are not x, y, or any of the extra names:\n%s\n\n",
                 enumerate(wrong_names)))
        }
        return()
    }

)