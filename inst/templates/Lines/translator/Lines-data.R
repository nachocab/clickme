Lines$methods(
    get_data = function() {
        tmp_data <- unify_format()

        if (!is.null(internal$extra$color_group))
            tmp_data <- order_by_color_group(tmp_data)

        data_names <- names(tmp_data[[1]][[1]])
        validate_tooltip_formats(data_names)

        data <<- tmp_data
    },

    # internal, template-specific
    unify_format = function() {
        x <- params[["x"]]
        y <- params[["y"]]
        if (is.null(y)){
            if (is_data_frame_or_matrix(x)){
                if (ncol(x) < 2) {
                    stop("When x is a dataframe or a matrix, it must contain at least two columns", call. = FALSE)
                }
                data <- dataframes_to_line_data(x = x,
                                                y = NULL,
                                                extra = internal$extra)
            } else if (is_list_of_data_frames(x)) {
                if (any(sapply(x, ncol) != 2))
                    stop("When input is a list of dataframes, they must only have two columns", call. = FALSE)

                internal$extra$line_name <- names(x)
                data <- lists_to_line_data(x = lapply(x,function(x) x[,1]),
                                           y = lapply(x,function(x) x[,2]),
                                           extra = internal$extra)
            } else {
                data <- vectors_to_line_data(x = 1:length(x),
                                             y = x,
                                             extra = internal$extra)
            }
        } else {
            if (is_data_frame_or_matrix(x) || is_data_frame_or_matrix(y)) {
                # If params$x or params$y is a dataframe, the other must also be a dataframe.
                x <- ensure_is_dataframe(x, nrow(y))
                y <- ensure_is_dataframe(y, nrow(x))

                if (ncol(x) != ncol(y))
                    stop(sprintf("x and y have different number of columns: %s vs. %s",
                            ncol(x), ncol(y)), call. = FALSE)

                if (ncol(x) < 2)
                    stop("When x is a dataframe or a matrix, it must contain at least two columns", call. = FALSE)

                data <- dataframes_to_line_data(x = x,
                                                y = y,
                                                extra = internal$extra)
            } else {
                if (is.list(x) && is.list(y)){
                    if (any(sapply(x, length) != sapply(y, length)))
                        stop(sprintf("x and y have different lengths: %s vs. %s",
                             paste(sapply(x, length), collapse = " "),
                             paste(sapply(x, length), collapse = " ")), call. = FALSE)
                    data <- lists_to_line_data(x = x,
                                               y = y,
                                               extra = internal$extra)
                } else {
                    data <- vectors_to_line_data(x = x,
                                                 y = y,
                                                 extra = internal$extra)
                }
            }
        }
        data
    },

    # internal
    add_extra = function(line_data, extra, line_number){
        # some extra parameters are the same value for all lines
        # others are specific to each line
        extra <- lapply(extra, function(x) {
            if (is.na(x[line_number])){
                x
            } else {
                x[line_number]
            }
        })

        line_data <- cbind(line_data, extra)
        line_data
    },

    # internal
    to_line_data = function(data){
        names <- rownames(data)
        line_data <- unname(lapply(split(data, names)[names], as.list))
        line_data
    },

    # internal
    vectors_to_line_data = function(x, y, extra){
        num_lines <- 1
        extra <- validate_extra(extra, num_lines)

        data <- xy_to_data(x,y)
        data <- add_extra(data, extra, 1)
        data <- list(to_line_data(data))
        data
    },

    # internal
    dataframes_to_line_data = function(x, y, extra){
        num_lines <- nrow(x)
        extra <- validate_extra(extra, num_lines)

        data <- lapply(1:nrow(x), function(line_number){
            if (is.null(y)){
                line <- xy_to_data(x = 1:ncol(x),
                                   y = unname(unlist(x[line_number, ])))
            } else {
                line <- xy_to_data(x = unname(unlist(x[line_number, ])),
                                   y = unname(unlist(y[line_number, ])))
            }
            line <- add_extra(line, extra, line_number)
            line <- to_line_data(line)
            line
        })
        data
    },

    # internal
    lists_to_line_data = function(x, y, extra){
        num_lines <- length(x)
        extra <- validate_extra(extra, num_lines)

        data <- lapply(1:length(x), function(line_number){
            line <- xy_to_data(x = x[[line_number]],
                               y = y[[line_number]])
            line <- add_extra(line, extra, line_number)
            line <- to_line_data(line)
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
    validate_extra = function(extra, num_lines){
        param_lengths <- sapply(extra, length)
        if (any(param_lengths > num_lines))
            stop(sprintf("Number of lines is %s, but the following parameters have more values than lines: \n%s",
                    num_lines,
                    enumerate(names(extra)[param_lengths > num_lines])), call. = FALSE)

        extra$line_name <- extra$line_name %or% as.character(1:num_lines)
        extra
    },

    # internal
    order_by_color_group = function(data){
        if (length(internal$extra$color_group) != length(data)) {
            stop(sprintf("The number of color_groups is %s, but the number of lines is %s",
                length(internal$extra$color_group),
                length(data)), call. = FALSE)
        }

        line_names <- sapply(data, function(line) line[[1]]$line_name)
        ordered_color_group_names <- get_ordered_color_group_names()
        names_groups <- data.frame(names = line_names, groups = internal$extra$color_group)
        data_order <- unlist(sapply(ordered_color_group_names, function(group_name) {
            which(names_groups$groups == group_name)
        }))

        # Reverse so the first element is plotted last (and therefore
        # appears on top)
        data_order <- rev(data_order)
        data <- data[data_order]
        data
    },

    # internal
    get_point_value = function(lines_data, variable_name){
        unlist(sapply(lines_data, function(line) sapply(line, function(point) point[[variable_name]])))
    }

    # internal
    # apply_axes_limits = function() {
    #    if (!is.null(params$x_lim)){
    #        data <<- data[data$x >= params$x_lim[1],]
    #        data <<- data[data$x <= params$x_lim[2],]
    #    }

    #    if (!is.null(params$y_lim)){
    #        data <<- data[data$y >= params$y_lim[1],]
    #        data <<- data[data$y <= params$y_lim[2],]
    #    }
    #    return()
    # },

    # # internal
    # remove_invalid = function(){
    #     data <<- na.omit(data)
    #     return()
    # },


)