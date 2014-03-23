Lines$methods(

    get_data = function(){
        if (is.null(params[["y"]])){
            if (is_data_frame_or_matrix(params[["x"]])){
                data <<- params[["x"]]
                if (ncol(data) %% 2 != 0){
                    # skip the last column, so they're even
                    warning(sprintf("\n\ndata doesn't have an even number of columns. Skipping column %s", ncol(data)))
                    data <<- data[, 1:(ncol(data) - 1)]
                }

                lines <- list()
                line_number <- 1
                for (column_number in seq(1, ncol(data), by = 2)){
                    x <- column_number
                    y <- column_number + 1
                    line <- xy_to_data(params[["x"]][, c(x,y)], NULL)
                    line$line_name <- as.character(line_number)
                    line_number <- line_number + 1
                    line <- unname(lapply(split(line, rownames(line)), as.list))
                    lines[[length(lines) + 1]] <- line
                }
                data <<- lines
            } else {
                data <<- xy_to_data(params[["x"]], NULL)
                data$line_name <<- "1"
                data <<- list(unname(lapply(split(data, rownames(data)), as.list)))
            }
        } else {
            if (is_data_frame_or_matrix(params[["y"]]) && !is_data_frame_or_matrix(params[["x"]])){
                stop(sprintf("\n\nIf y is a dataframe, x must also be a dataframe, but it's a %s",
                     class(params[["x"]])))
            }

            if (is_data_frame_or_matrix(params[["x"]])) {
                if (nrow(params[["x"]]) == nrow(params[["y"]])) {
                    lines <- list()
                    for (row_number in 1:length(params[["x"]])) {
                        line <- xy_to_data(params[["x"]][, row_number], params[["y"]][, row_number])
                        line$line_name <- as.character(row_number)
                        line <- unname(lapply(split(line, rownames(line)), as.list))
                        lines[[length(lines) + 1]] <- line
                    }
                    data <<- lines
                } else {
                    stop(sprintf("\n\nx and y have different number of columns: %s vs. %s",
                            nrow(params[["x"]]), nrow(params[["y"]])))
                }
            } else {
                data <<- xy_to_data(params[["x"]], params[["y"]])
                data$line_name <<- "1"
                data <<- list(unname(lapply(split(data, rownames(data)), as.list)))
            }
        }

       data <<- cluster_data_rows(data, params$color_groups, group_variable = "color_group", group_order = internal$ordered_color_group_names)
       # Reverse so the last color group gets the last color
       params$palette <<- rev(params$palette)

       data <<- apply_axes_limits(data)

       data <<- na.omit(data)

       params$formats <<- validate_formats(params$formats)

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
    # group_order must have as many elements as groups, by default the order is alphanumeric
    cluster_data_rows = function(x, groups, group_variable, group_order = NULL){
       if (!is.data.frame(x)){
           stop("\n\n\tdata must be a dataframe to group its rows")
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

           # Reverse so the first element is plotted last (and therefore appears on top)
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
            stop(sprintf("\n\n\tThe following format names are not x, y, or any of the extra names:\n%s\n\n", enumerate(wrong_names)))
        }

        formats
    }

)